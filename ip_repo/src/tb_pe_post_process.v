`timescale 1ns / 1ps

module tb_pe_post_process();
    parameter BW_P = 32;
    parameter BW_A = 8;
    parameter SHIFT_VAL = 4; // >> 4 (즉, 16으로 나눔)
    
    // 가로 길이 4. 즉 4x4 = 16개 픽셀을 연속으로 붓습니다.
    parameter FM_WIDTH = 4;  

    reg clk;
    reg reset_n;
    reg signed [BW_P-1:0] psum_in;
    reg valid_in;

    wire [BW_A-1:0] pool_out;
    wire valid_out;

    pe_post_process_col #(
        .BW_P(BW_P), .BW_A(BW_A), .SHIFT_VAL(SHIFT_VAL), .FM_WIDTH(FM_WIDTH)
    ) uut (
        .clk(clk), .reset_n(reset_n),
        .psum_in(psum_in), .valid_in(valid_in),
        .pool_out(pool_out), .valid_out(valid_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset_n = 0; psum_in = 0; valid_in = 0;
        #25 reset_n = 1;

        // =======================================================
        // 🌊 Row 1 (윗줄) - 10, 0, 127, 20
        // =======================================================
        @(negedge clk); psum_in = 32'sd160;  valid_in = 1; 
        @(negedge clk); psum_in = -32'sd500; valid_in = 1; 
        @(negedge clk); psum_in = 32'sd3200; valid_in = 1; 
        @(negedge clk); psum_in = 32'sd320;  valid_in = 1;  

        // =======================================================
        // 🌊 Row 2 (아랫줄) - 💡 쉬지 않고 바로 들어갑니다! (30, 40, 50, 100)
        // =======================================================
        @(negedge clk); psum_in = 32'sd480;  valid_in = 1;  
        @(negedge clk); psum_in = 32'sd640;  valid_in = 1;  // 🌟 첫 번째 2x2 출력 (기대값: 40)
        @(negedge clk); psum_in = 32'sd800;  valid_in = 1;  
        @(negedge clk); psum_in = 32'sd1600; valid_in = 1; // 🌟 두 번째 2x2 출력 (기대값: 127)

        // =======================================================
        // 🌊 Row 3 (새로운 윗줄) - 💡 라인버퍼를 덮어쓰며 계속 들어갑니다! (5, 15, 25, 35)
        // =======================================================
        @(negedge clk); psum_in = 32'sd80;   valid_in = 1;
        @(negedge clk); psum_in = 32'sd240;  valid_in = 1;
        @(negedge clk); psum_in = 32'sd400;  valid_in = 1;
        @(negedge clk); psum_in = 32'sd560;  valid_in = 1;

        // =======================================================
        // 🌊 Row 4 (새로운 아랫줄) - (10, 20, 30, 40)
        // =======================================================
        @(negedge clk); psum_in = 32'sd160;  valid_in = 1;
        @(negedge clk); psum_in = 32'sd320;  valid_in = 1; // 🌟 세 번째 2x2 출력 (기대값: 20)
        @(negedge clk); psum_in = 32'sd480;  valid_in = 1;
        @(negedge clk); psum_in = 32'sd640;  valid_in = 1; // 🌟 네 번째 2x2 출력 (기대값: 40)

        // 주입 완료
        @(negedge clk); psum_in = 0; valid_in = 0;

        #100 $finish;
    end
endmodule