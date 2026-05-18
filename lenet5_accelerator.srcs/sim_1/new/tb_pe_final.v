`timescale 1ns / 1ps

module tb_pe_final();
    reg clk; reg reset_n; reg [1:0] opcode; 
    reg col_en; reg row_en; // 💡 행/열 제어 신호 추가
    reg signed [7:0] iact_in; reg signed [31:0] top_in; reg valid_in;
    
    wire signed [7:0] iact_out; wire signed [31:0] bottom_out; 
    wire valid_out; wire valid_hor_out; // 💡 방향별 Valid 출력

    // 💡 IS_TOP_ROW = 1 로 설정하여 가로 Valid 출력 활성화
    pe #(.BW_W(8), .BW_A(8), .BW_P(32), .IS_TOP_ROW(1), .IS_RIGHT_COL(0)) uut (
        .clk(clk), .reset_n(reset_n), .opcode(opcode),
        .col_en(col_en), .row_en(row_en),
        .iact_in(iact_in), .top_in(top_in), .valid_in(valid_in),
        .iact_out(iact_out), .bottom_out(bottom_out), 
        .valid_out(valid_out), .valid_hor_out(valid_hor_out)
    );

    always #5 clk = ~clk;
    localparam IDLE = 2'b00, LOAD = 2'b01, MAC = 2'b10;

    // 💡 반복되는 연산 테스트를 깔끔하게 처리하기 위한 Task
    task run_test_sequence;
        begin
            // 1. 가중치 로드 (W = 5)
            @(negedge clk); opcode = LOAD; top_in = 32'sd5; 
            @(negedge clk); opcode = IDLE; top_in = 0;
            
            // 2. 파이프라인 가동 (1, 2, 3, 4 주입)
            @(negedge clk); opcode = MAC; iact_in = 8'sd1; top_in = 32'sd10; valid_in = 1; 
            @(negedge clk); iact_in = 8'sd2; top_in = 32'sd20; valid_in = 1; 
            @(negedge clk); iact_in = 8'sd3; top_in = 32'sd30; valid_in = 1; 
            @(negedge clk); iact_in = 8'sd4; top_in = 32'sd40; valid_in = 1; 
            
            // 3. 파이프라인 비우기
            @(negedge clk); iact_in = 0; top_in = 0; valid_in = 0; opcode = IDLE;
            #30; // 결과가 다 빠져나오도록 충분히 대기
        end
    endtask

    initial begin
        // 초기화
        clk = 0; reset_n = 0; opcode = IDLE; 
        col_en = 0; row_en = 0;
        iact_in = 0; top_in = 0; valid_in = 0;
        #25 reset_n = 1; 

        // =========================================================
        // 🟢 [Case 1] 정상 동작 (col_en = 1, row_en = 1)
        // =========================================================
        $display("--- Test Case 1: PE Enabled ---");
        @(negedge clk); col_en = 1; row_en = 1;
        run_test_sequence();

        // =========================================================
        // 🔴 [Case 2] 열(Column) 꺼짐 (col_en = 0, row_en = 1)
        // =========================================================
        $display("--- Test Case 2: Column Disabled ---");
        @(negedge clk); col_en = 0; row_en = 1;
        // 내부 레지스터를 확실히 비우기 위해 하드 리셋
        reset_n = 0; #10 reset_n = 1; 
        run_test_sequence();

        // =========================================================
        // 🔴 [Case 3] 행(Row) 꺼짐 (col_en = 1, row_en = 0)
        // =========================================================
        $display("--- Test Case 3: Row Disabled ---");
        @(negedge clk); col_en = 1; row_en = 0;
        reset_n = 0; #10 reset_n = 1; 
        run_test_sequence();

        // =========================================================
        // 🔴 [Case 4] 둘 다 꺼짐 (col_en = 0, row_en = 0)
        // =========================================================
        $display("--- Test Case 4: Completely Disabled ---");
        @(negedge clk); col_en = 0; row_en = 0;
        reset_n = 0; #10 reset_n = 1; 
        run_test_sequence();

        #50 $finish;
    end
endmodule