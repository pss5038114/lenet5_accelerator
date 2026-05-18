`timescale 1ns / 1ps

module tb_lenet5_ctrl_skeleton();
    reg clk;
    reg reset_n;
    reg dma_done;
    reg layer_done;
    reg ps_read_done;

    wire ping_pong_state;
    wire [1:0] mode_select;
    wire [7:0] input_width;
    wire [7:0] fm_width;
    wire [2:0] current_state;

    // FSM 인스턴스화
    lenet5_ctrl_skeleton uut (
        .clk(clk), .reset_n(reset_n),
        .dma_done(dma_done), .layer_done(layer_done), .ps_read_done(ps_read_done),
        .ping_pong_state(ping_pong_state), .mode_select(mode_select),
        .input_width(input_width), .fm_width(fm_width),
        .current_state(current_state)
    );

    // 10ns 클럭 생성
    always #5 clk = ~clk;

    initial begin
        // 1. 초기화
        clk = 0; reset_n = 0;
        dma_done = 0; layer_done = 0; ps_read_done = 0;

        #25 reset_n = 1; // 리셋 해제 -> IDLE 상태 진입
        #20;

        // 2. 가상 완료 신호 발생 (State 변경 유도)
        
        // IDLE (0) -> CONV1 (1)
        #20 dma_done = 1; #10 dma_done = 0;
        
        // CONV1 (1) -> CONV2 (2)
        #50 layer_done = 1; #10 layer_done = 0;
        
        // CONV2 (2) -> FC1 (3)
        #50 layer_done = 1; #10 layer_done = 0;
        
        // FC1 (3) -> FC2 (4)
        #50 layer_done = 1; #10 layer_done = 0;
        
        // FC2 (4) -> FC3 (5)
        #50 layer_done = 1; #10 layer_done = 0;
        
        // FC3 (5) -> FINISH (6)
        #50 layer_done = 1; #10 layer_done = 0;
        
        // FINISH (6) -> IDLE (0) 사이클 리셋
        #50 ps_read_done = 1; #10 ps_read_done = 0;

        #50 $finish;
    end
endmodule