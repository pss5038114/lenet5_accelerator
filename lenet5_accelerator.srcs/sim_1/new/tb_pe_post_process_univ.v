`timescale 1ns / 1ps

module tb_pe_post_process_univ();
    parameter BW_P = 32;
    parameter BW_A = 8;
    parameter SHIFT_VAL = 4; // >> 4 (즉, 16으로 나눔)
    parameter MAX_FM_WIDTH = 28; // 물리적 최대 크기

    reg clk;
    reg reset_n;
    reg [7:0] fm_width; // 컨트롤러가 보내주는 레이어 크기
    reg signed [BW_P-1:0] psum_in;
    reg valid_in;

    wire [BW_A-1:0] pool_out;
    wire valid_out;

    pe_post_process_col #(
        .BW_P(BW_P), .BW_A(BW_A), .SHIFT_VAL(SHIFT_VAL), .MAX_FM_WIDTH(MAX_FM_WIDTH)
    ) uut (
        .clk(clk), .reset_n(reset_n),
        .fm_width(fm_width), // 컨트롤러 제어선 연결
        .psum_in(psum_in), .valid_in(valid_in),
        .pool_out(pool_out), .valid_out(valid_out)
    );

    always #5 clk = ~clk;

    integer i;

    initial begin
        clk = 0; reset_n = 0; fm_width = 28; 
        psum_in = 0; valid_in = 0;
        #25 reset_n = 1;
        #20;

        // =======================================================
        // 🌊 [Phase 1] fm_width = 28 모드 (LeNet-5 Conv1 출력 크기)
        // =======================================================
        fm_width = 28; // 컨트롤러가 28로 세팅

        // 윗줄 (Row 0) : 1 ~ 28 주입 (16을 곱해서 넣으면 양자화 후 1~28이 됨)
        for (i = 1; i <= 28; i = i + 1) begin
            @(posedge clk);
            psum_in = i * 16; 
            valid_in = 1;
        end
        
        // 아랫줄 (Row 1) : 29 ~ 56 주입
        // 💡 짝수 번째(30, 32...)가 들어갈 때마다 pool_out에 30, 32...가 튀어나와야 함
        for (i = 29; i <= 56; i = i + 1) begin
            @(posedge clk);
            psum_in = i * 16; 
            valid_in = 1;
        end

        // 잠시 대기 (Layer 연산 종료 후 다음 Layer 준비 모사)
        @(posedge clk);
        psum_in = 0; valid_in = 0;
        #100;

        // =======================================================
        // 🌊 [Phase 2] fm_width = 10 모드 (LeNet-5 Conv2 출력 크기)
        // =======================================================
        fm_width = 10; // 컨트롤러가 10으로 크기 변경!

        // 윗줄 (Row 0) : 데이터 구분을 위해 100 단위로 주입 (100 ~ 1000)
        for (i = 1; i <= 10; i = i + 1) begin
            @(posedge clk);
            psum_in = i * 100 * 16; 
            valid_in = 1;
        end
        
        // 아랫줄 (Row 1) : 1100 ~ 2000 주입
        // 💡 짝수 번째가 들어갈 때마다 1200, 1400... 이 튀어나와야 함
        for (i = 11; i <= 20; i = i + 1) begin
            @(posedge clk);
            psum_in = i * 100 * 16; 
            valid_in = 1;
        end

        // 주입 완료 및 종료
        @(posedge clk);
        psum_in = 0; valid_in = 0;

        #100 $finish;
    end
endmodule