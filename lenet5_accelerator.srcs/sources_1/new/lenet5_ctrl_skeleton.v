`timescale 1ns / 1ps

module lenet5_ctrl_skeleton (
    input wire clk,
    input wire reset_n,
    
    // ==========================================
    // 📥 가상 완료 보고 신호 (Mock Triggers)
    // ==========================================
    input wire dma_done,      // DMA 로드 완료
    input wire layer_done,    // 현재 레이어(Conv 또는 FC) 연산 완료
    input wire ps_read_done,  // PS단(ARM)에서 최종 결과 읽기 완료

    // ==========================================
    // 📤 하위 모듈로 뿌려줄 환경 설정(파라미터) 신호
    // ==========================================
    output wire ping_pong_state,
    output wire [1:0] mode_select, // 0: DMA, 1: CONV, 2: FC
    output wire [7:0] input_width,
    output wire [7:0] fm_width,
    
    // 디버깅 및 시뮬레이션 확인용 현재 상태 출력
    output reg [2:0] current_state
);

    // 💡 7개의 Macro State 정의
    parameter IDLE   = 3'd0;
    parameter CONV1  = 3'd1;
    parameter CONV2  = 3'd2;
    parameter FC1    = 3'd3;
    parameter FC2    = 3'd4;
    parameter FC3    = 3'd5;
    parameter FINISH = 3'd6;

    reg [2:0] next_state;

    // --------------------------------------------------
    // [1] State Register (순차 논리: 클럭마다 상태 갱신)
    // --------------------------------------------------
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) current_state <= IDLE;
        else          current_state <= next_state;
    end

    // --------------------------------------------------
    // [2] Next State Logic (조합 논리: 다음 상태 결정)
    // --------------------------------------------------
    always @(*) begin
        next_state = current_state; // 기본값: 현재 상태 유지
        
        case (current_state)
            IDLE:   if (dma_done)     next_state = CONV1;
            CONV1:  if (layer_done)   next_state = CONV2;
            CONV2:  if (layer_done)   next_state = FC1;
            FC1:    if (layer_done)   next_state = FC2;
            FC2:    if (layer_done)   next_state = FC3;
            FC3:    if (layer_done)   next_state = FINISH;
            FINISH: if (ps_read_done) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // --------------------------------------------------
    // [3] Output Logic (조합 논리: 상태에 따른 환경 설정)
    // --------------------------------------------------
    // 핑퐁 스위치: CONV2와 FC2에서만 B 읽기(1)로 세팅
    assign ping_pong_state = (current_state == CONV2 || current_state == FC2) ? 1'b1 : 1'b0;
    
    // 라우터 모드: IDLE(0), CONV(1), FC(2)
    assign mode_select = (current_state == IDLE) ? 2'd0 :
                         (current_state == CONV1 || current_state == CONV2) ? 2'd1 : 2'd2;
                         
    // 인풋 크기 및 피처맵 크기 할당 (Conv 모드에서만 사용)
    assign input_width = (current_state == CONV1) ? 8'd32 :
                         (current_state == CONV2) ? 8'd14 : 8'd0;
                         
    assign fm_width    = (current_state == CONV1) ? 8'd28 :
                         (current_state == CONV2) ? 8'd10 : 8'd0;

endmodule