`timescale 1ns / 1ps

module tb_pe();
    reg clk; reg reset_n; reg [1:0] opcode; 
    reg signed [7:0] iact_in; reg signed [31:0] top_in; reg valid_in;
    
    wire signed [7:0] iact_out; wire signed [31:0] bottom_out; wire valid_out;

    pe #(.BW_W(8), .BW_A(8), .BW_P(32)) uut (
        .clk(clk), .reset_n(reset_n), .opcode(opcode),
        .iact_in(iact_in), .top_in(top_in), .valid_in(valid_in),
        .iact_out(iact_out), .bottom_out(bottom_out), .valid_out(valid_out)
    );

    // 10ns 주기 클럭 (상승 엣지: 5, 15, 25... / 하강 엣지: 0, 10, 20...)
    always #5 clk = ~clk;
    localparam IDLE = 2'b00, LOAD = 2'b01, MAC = 2'b10;

    initial begin
        clk = 0; reset_n = 0; opcode = IDLE; 
        iact_in = 0; top_in = 0; valid_in = 0;
        #25 reset_n = 1; // 25ns 상승 엣지에서 리셋 해제
        
        // 💡 모든 데이터는 클럭 상승 엣지와 겹치지 않도록 '하강 엣지'에 주입!
        @(negedge clk); // 30ns
        opcode = LOAD; top_in = 32'sd5; 
        
        @(negedge clk); // 40ns
        opcode = IDLE; top_in = 0;
        
        // --- 파이프라인 풀 가동 ---
        @(negedge clk); // 50ns
        opcode = MAC;
        iact_in = 8'sd1; top_in = 32'sd10; valid_in = 1; 
        
        @(negedge clk); // 60ns
        iact_in = 8'sd2; top_in = 32'sd20; valid_in = 1; 
        
        @(negedge clk); // 70ns
        iact_in = 8'sd3; top_in = 32'sd30; valid_in = 1; 
        
        @(negedge clk); // 80ns
        iact_in = 8'sd4; top_in = 32'sd40; valid_in = 1; 
        
        @(negedge clk); // 90ns
        iact_in = 0; top_in = 0; valid_in = 0; opcode = IDLE;

        #50 $finish;
    end
endmodule