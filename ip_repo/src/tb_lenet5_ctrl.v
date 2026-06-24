`timescale 1ns / 1ps

module tb_lenet5_ctrl();

    // 📥 입력 레지스터 선언
    reg clk;
    reg reset_n;
    reg dma_done;
    reg ps_read_done;

    // 📤 출력 와이어 선언
    wire ping_pong_state;
    wire [1:0] mode_select;
    wire [7:0] input_width;
    wire [7:0] fm_width;
    
    wire shift_en;
    wire [1:0] opcode;
    wire use_bias;
    wire start;
    wire [2:0] stage_idx;
    
    wire start_node;
    wire valid_in;
    wire end_node;
    
    wire [2:0] current_state;

    // 💡 컨트롤러 인스턴스화 (Device Under Test)
    lenet5_ctrl uut (
        .clk(clk),
        .reset_n(reset_n),
        .dma_done(dma_done),
        .ps_read_done(ps_read_done),
        
        .ping_pong_state(ping_pong_state),
        .mode_select(mode_select),
        .input_width(input_width),
        .fm_width(fm_width),
        
        .shift_en(shift_en),
        .opcode(opcode),
        .use_bias(use_bias),
        .start(start),
        .stage_idx(stage_idx),
        
        .start_node(start_node),
        .valid_in(valid_in),
        .end_node(end_node),
        
        .current_state(current_state)
    );

    // ⏰ 10ns 클럭 생성 (100MHz)
    always #5 clk = ~clk;

    // 📊 디버깅을 위한 상태 변화 모니터링 (콘솔 출력)
    always @(current_state) begin
        case(current_state)
            3'd0: $display("[%0t] STATE: IDLE", $time);
            3'd1: $display("[%0t] STATE: CONV1 (Filter Batch 1)", $time);
            3'd2: $display("[%0t] STATE: CONV2 (Filter Batch 2)", $time);
            3'd3: $display("[%0t] STATE: FC1 (120 Nodes)", $time);
            3'd4: $display("[%0t] STATE: FC2 (84 Nodes)", $time);
            3'd5: $display("[%0t] STATE: FC3 (10 Nodes)", $time);
            3'd6: $display("[%0t] STATE: FINISH (Waiting for PS)", $time);
        endcase
    end

    // 🚀 시뮬레이션 시나리오
    initial begin
        // 1. 초기화
        clk = 0;
        reset_n = 0;
        dma_done = 0;
        ps_read_done = 0;

        #100;
        reset_n = 1; // 리셋 해제 (IDLE 상태 진입)
        #50;

        // 2. 연산 시작 트리거 발사! (DMA 로드 완료)
        $display("=============================================");
        $display("[%0t] System Start: dma_done Pulse Triggered", $time);
        $display("=============================================");
        dma_done = 1; 
        #10; 
        dma_done = 0;

        // 3. 💡 마법의 코드: 컨트롤러가 모든 연산을 스스로 끝내고 FINISH(6) 상태가 될 때까지 기다림
        // (이 과정에서 내부 서브 FSM들이 수만 클럭 동안 알아서 동작합니다)
        wait(current_state == 3'd6);
        
        #100;
        $display("=============================================");
        $display("[%0t] Inference Complete! ps_read_done Pulse Triggered", $time);
        $display("=============================================");

        // 4. PS 읽기 완료 신호 발사 -> 다시 IDLE로 복귀 확인
        ps_read_done = 1;
        #10;
        ps_read_done = 0;

        #200;
        $display("[%0t] Simulation Finished Perfectly.", $time);
        $finish;
    end

endmodule