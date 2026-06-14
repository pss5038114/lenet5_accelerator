`timescale 1ns / 1ps

module lenet5_ctrl (
    input wire clk,
    input wire reset_n,
    
    input wire dma_done,      
    input wire ps_read_done,  

    output wire ping_pong_state,
    output wire [1:0] mode_select, 
    output wire [7:0] input_width,
    output wire [7:0] fm_width,
    
    output wire shift_en,
    output wire [1:0] opcode,
    output wire use_bias,
    output wire start,
    output wire [2:0] stage_idx,

    output wire start_node,
    output wire valid_in,
    output wire end_node,
    
    output reg [2:0] current_state
);

    parameter IDLE = 3'd0, CONV1 = 3'd1, CONV2 = 3'd2;
    parameter FC1  = 3'd3, FC2   = 3'd4, FC3   = 3'd5, FINISH = 3'd6;

    reg [2:0] next_state;
    
    wire conv_layer_done; 
    wire fc_layer_done;   
    
    wire is_conv = (current_state == CONV1 || current_state == CONV2);
    wire is_fc   = (current_state == FC1 || current_state == FC2 || current_state == FC3);
    
    assign ping_pong_state = (current_state == CONV2 || current_state == FC2) ? 1'b1 : 1'b0;
    assign mode_select = (current_state == IDLE) ? 2'd0 : (is_conv) ? 2'd1 : 2'd2;
    assign input_width = (current_state == CONV1) ? 8'd32 : (current_state == CONV2) ? 8'd14 : 8'd0;
    assign fm_width    = (current_state == CONV1) ? 8'd28 : (current_state == CONV2) ? 8'd10 : 8'd0;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) current_state <= IDLE;
        else          current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE:   if (dma_done)        next_state = CONV1;
            CONV1:  if (conv_layer_done) next_state = CONV2;
            CONV2:  if (conv_layer_done) next_state = FC1;
            FC1:    if (fc_layer_done)   next_state = FC2;
            FC2:    if (fc_layer_done)   next_state = FC3;
            FC3:    if (fc_layer_done)   next_state = FINISH;
            FINISH: if (ps_read_done)    next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    reg [2:0] c_state;
    reg [3:0] load_cnt;
    reg [15:0] wait_cnt;
    reg [2:0] stage_cnt;
    reg [1:0] batch_cnt; // Conv1은 1배치(6개), Conv2는 2배치(16개)
    
    // 각 레이어별 목표 설정
    wire [15:0] target_wait  = (current_state == CONV1) ? 16'd950 : 16'd200; // 파이프라인 여유분 포함
    wire [1:0]  target_batch = (current_state == CONV1) ? 2'd1 : 2'd2;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            c_state <= 0; load_cnt <= 0; wait_cnt <= 0; stage_cnt <= 0; batch_cnt <= 0;
        end else if (!is_conv) begin
            // Conv 상태가 아니면 모두 초기화하고 휴식
            c_state <= 0; load_cnt <= 0; wait_cnt <= 0; stage_cnt <= 0; batch_cnt <= 0;
        end else begin
            case (c_state)
                0: c_state <= 1; // 시작
                1: begin // [상태 1] 가중치 로드 (10클럭 대기)
                    if (load_cnt == 4'd9) begin
                        load_cnt <= 0; c_state <= 2;
                    end else load_cnt <= load_cnt + 1;
                end
                2: c_state <= 3; // [상태 2] Stage 시작 펄스 (1클럭 발사)
                3: begin // [상태 3] Stage 완료 대기 (픽셀 연산 중)
                    if (wait_cnt == target_wait) begin
                        wait_cnt <= 0;
                        if (stage_cnt == 3'd4) begin // Stage 5번(0~4) 완료
                            stage_cnt <= 0; c_state <= 4;
                        end else begin // 다음 Stage 진행
                            stage_cnt <= stage_cnt + 1; c_state <= 2;
                        end
                    end else wait_cnt <= wait_cnt + 1;
                end
                4: begin // [상태 4] 배치 완료 점검
                    if (batch_cnt == target_batch - 1) begin
                        batch_cnt <= 0; c_state <= 5; // 전체 레이어 완료!
                    end else begin
                        batch_cnt <= batch_cnt + 1; c_state <= 1; // 다음 8개 필터 가중치 로드
                    end
                end
                5: c_state <= 5; // 메인 FSM이 상태를 바꿔줄 때까지 대기 (DONE)
            endcase
        end
    end

    // CONV 제어 신호 매핑
    assign shift_en = (c_state == 1);
    assign opcode   = (c_state == 1) ? 2'd1 : (c_state == 2 || c_state == 3) ? 2'd2 : 2'd0;
    assign start    = (c_state == 2);
    assign stage_idx = stage_cnt;
    assign use_bias = (stage_cnt == 3'd0); // 첫 Stage(0)일 때만 Bias 사용
    assign conv_layer_done = (c_state == 5);

    // =========================================================
    // 🧠 [3] FC Sub-FSM (실무 과장님)
    // =========================================================
    reg [1:0] f_state;
    reg [7:0] node_cnt;  // 완료된 노드 개수
    reg [7:0] acc_cnt;   // 누적 횟수(클럭)
    
    // FC 레이어별 목표 설정
    wire [7:0] target_nodes = (current_state == FC1) ? 8'd120 : (current_state == FC2) ? 8'd84 : 8'd10;
    wire [7:0] target_acc   = (current_state == FC1) ? 8'd50  : (current_state == FC2) ? 8'd15 : 8'd11;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            f_state <= 0; node_cnt <= 0; acc_cnt <= 0;
        end else if (!is_fc) begin
            f_state <= 0; node_cnt <= 0; acc_cnt <= 0;
        end else begin
            case (f_state)
                0: f_state <= 1; // 시작
                1: f_state <= 2; // [상태 1] 시작 펄스 (Bias 로드)
                2: begin         // [상태 2] 데이터 누적
                    if (acc_cnt == target_acc - 1) begin
                        acc_cnt <= 0; f_state <= 3;
                    end else acc_cnt <= acc_cnt + 1;
                end
                3: begin         // [상태 3] 노드 연산 종료 (양자화 및 저장)
                    if (node_cnt == target_nodes - 1) begin
                        node_cnt <= 0; f_state <= 0; // 레이어 완료 (서브 FSM 초기화)
                    end else begin
                        node_cnt <= node_cnt + 1; f_state <= 1; // 다음 노드 시작
                    end
                end
            endcase
        end
    end

    // FC 제어 신호 매핑
    assign start_node = (f_state == 1);
    assign valid_in   = (f_state == 2);
    assign end_node   = (f_state == 3);
    
    // 방금 전 노드를 마쳤고, 다음 노드를 시작하기 직전(0으로 돌아감)일 때 레이어 완료!
    assign fc_layer_done = (f_state == 3 && node_cnt == target_nodes - 1);

endmodule