`timescale 1ns / 1ps

module tb_pe_array();
    reg clk; reg reset_n; reg [1:0] opcode;
    reg [7:0] col_en; reg [4:0] row_en;
    
    // 마스터 입력 (좌측 상단 PE[0,0]으로 진입)
    reg signed [7:0] iact_in_master;
    reg master_valid_in;
    
    // 8개 컬럼의 독립적인 Weight/Bias 입력 (상단 진입)
    reg signed [31:0] top_in_0, top_in_1, top_in_2, top_in_3;
    reg signed [31:0] top_in_4, top_in_5, top_in_6, top_in_7;
    
    // 8개 컬럼의 독립적인 PSum/Valid 출력 (하단 출력)
    wire signed [31:0] bottom_out_0, bottom_out_1, bottom_out_2, bottom_out_3;
    wire signed [31:0] bottom_out_4, bottom_out_5, bottom_out_6, bottom_out_7;
    wire valid_out_0, valid_out_1, valid_out_2, valid_out_3;
    wire valid_out_4, valid_out_5, valid_out_6, valid_out_7;

    pe_array #(.NUM_ROW(5), .NUM_COL(8)) uut (
        .clk(clk), .reset_n(reset_n), .opcode(opcode),
        .col_en(col_en), .row_en(row_en),
        .iact_in_master(iact_in_master), .master_valid_in(master_valid_in),
        .top_in_0(top_in_0), .top_in_1(top_in_1), .top_in_2(top_in_2), .top_in_3(top_in_3),
        .top_in_4(top_in_4), .top_in_5(top_in_5), .top_in_6(top_in_6), .top_in_7(top_in_7),
        .bottom_out_0(bottom_out_0), .bottom_out_1(bottom_out_1), .bottom_out_2(bottom_out_2), .bottom_out_3(bottom_out_3),
        .bottom_out_4(bottom_out_4), .bottom_out_5(bottom_out_5), .bottom_out_6(bottom_out_6), .bottom_out_7(bottom_out_7),
        .valid_out_0(valid_out_0), .valid_out_1(valid_out_1), .valid_out_2(valid_out_2), .valid_out_3(valid_out_3),
        .valid_out_4(valid_out_4), .valid_out_5(valid_out_5), .valid_out_6(valid_out_6), .valid_out_7(valid_out_7)
    );

    always #5 clk = ~clk;

    integer r, c, pixel_count;

    // Weight Load를 편하게 하기 위한 Task
    task load_weights(
        input integer w0, input integer w1, input integer w2, input integer w3,
        input integer w4, input integer w5
    );
        begin
            @(negedge clk);
            top_in_0 = w0; top_in_1 = w1; top_in_2 = w2; 
            top_in_3 = w3; top_in_4 = w4; top_in_5 = w5;
            // 💡 6, 7번 컬럼은 안 쓰니까 무조건 0
            top_in_6 = 0;  top_in_7 = 0;
        end
    endtask

    initial begin
        clk = 0; reset_n = 0; opcode = 2'b00;
        // 💡 6개의 필터만 켜기 (Col 0~5: ON, Col 6~7: OFF) => 8'b0011_1111
        col_en = 8'b0011_1111; 
        row_en = 5'b11111; 
        
        iact_in_master = 0; master_valid_in = 0;
        top_in_0 = 0; top_in_1 = 0; top_in_2 = 0; top_in_3 = 0;
        top_in_4 = 0; top_in_5 = 0; top_in_6 = 0; top_in_7 = 0;
        #25 reset_n = 1;

        // ==========================================
        // 1. 가중치 로드 (PE0부터 PE4까지 차례대로 Shift)
        // 승현 님 요청: Col0(1~5), Col1(6~10) ... Col5(26~30)
        // 맨 아래 PE(Row 4)에 들어갈 값부터 먼저 쏴줍니다 (5, 4, 3, 2, 1 순서)
        // ==========================================
        opcode = 2'b01; 
        load_weights(5, 10, 15, 20, 25, 30); // Row 4 (Bottom)
        load_weights(4,  9, 14, 19, 24, 29); // Row 3
        load_weights(3,  8, 13, 18, 23, 28); // Row 2
        load_weights(2,  7, 12, 17, 22, 27); // Row 1
        load_weights(1,  6, 11, 16, 21, 26); // Row 0 (Top)
        
        @(negedge clk); opcode = 2'b00; 
        load_weights(0,0,0,0,0,0);

        // ==========================================
        // 2. MAC Operation (32x32 인풋, 1~32 반복 주입)
        // ==========================================
        @(negedge clk); opcode = 2'b10;
        pixel_count = 0;
        
        // 28개의 행(Row)을 돕니다.
        for (r = 0; r < 28; r = r + 1) begin
            // 1행당 32개의 픽셀(Col)
            for (c = 1; c <= 32; c = c + 1) begin
                @(negedge clk);
                
                // 💡 1~32 사이의 숫자가 무한 반복되도록 설정
                iact_in_master = (pixel_count % 32) + 1;
                pixel_count = pixel_count + 1;
                
                // 28번째 픽셀까지만 Valid 1, 나머지는 0
                if (c <= 28) master_valid_in = 1;
                else         master_valid_in = 0;
            end
        end
        
        // 파이프라인 비우기
        @(negedge clk);
        iact_in_master = 0; master_valid_in = 0;
        
        #200 opcode = 2'b00;
        #100 $finish;
    end
endmodule