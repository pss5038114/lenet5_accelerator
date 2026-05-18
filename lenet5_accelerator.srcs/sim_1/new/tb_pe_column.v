`timescale 1ns / 1ps

module tb_pe_column();
    reg clk; reg reset_n; reg [1:0] opcode;
    reg col_en; reg [4:0] row_en;
    
    // 💡 8비트 단일 입력 (Broadcast)
    reg signed [7:0] iact_in; 
    reg signed [31:0] top_in; reg valid_in;
    
    wire [39:0] iact_out; wire signed [31:0] bottom_out;
    wire valid_out; wire valid_hor_out;

    pe_column #(.NUM_PE(5)) uut (
        .clk(clk), .reset_n(reset_n), .opcode(opcode),
        .col_en(col_en), .row_en(row_en),
        .iact_in(iact_in), .top_in(top_in), .valid_in(valid_in),
        .iact_out(iact_out), .bottom_out(bottom_out),
        .valid_out(valid_out), .valid_hor_out(valid_hor_out)
    );

    always #5 clk = ~clk;

    // 시뮬레이션을 위한 인덱스 변수
    integer r, c;
    integer pixel_val;

    initial begin
        clk = 0; reset_n = 0; opcode = 2'b00;
        col_en = 1; row_en = 5'b11111; 
        iact_in = 0; top_in = 0; valid_in = 0;
        #25 reset_n = 1;

        // ==========================================
        // 1. 가중치 로드 (PE0부터 PE4까지 차례대로 채워짐)
        // ==========================================
        @(negedge clk); opcode = 2'b01; 
        top_in = 32'sd5; @(negedge clk); 
        top_in = 32'sd4; @(negedge clk); 
        top_in = 32'sd3; @(negedge clk); 
        top_in = 32'sd2; @(negedge clk); 
        top_in = 32'sd1; @(negedge clk); 
        opcode = 2'b00; top_in = 0;

        // ==========================================
        // 2. MAC Operation (32x32 인풋, 5x5 필터 모사)
        // ==========================================
        @(negedge clk); opcode = 2'b10;
        
        // 💡 28개의 행(Row)을 돕니다.
        for (r = 0; r < 28; r = r + 1) begin
            // 💡 1행당 32개의 픽셀(Col)이 들어옵니다.
            for (c = 1; c <= 32; c = c + 1) begin
                @(negedge clk);
                
                // 실제 이미지의 픽셀 번호 (1 ~ 896)
                pixel_val = (r * 32) + c;
                
                // ⚠️ 주의: iact_in은 8비트이므로 pixel_val이 255를 넘어가면 파형에서는 
                // 잘려서(오버플로우) 보입니다. 하지만 Valid 타이밍을 보는 데는 문제가 없습니다!
                // iact_in = pixel_val[7:0];
                
                // 💡 수정된 코드: 픽셀 값이 계속 커지더라도 0~99 사이의 값만 빙글빙글 돌면서 들어가게 만듦
                iact_in = (pixel_val % 100);
                
                // 💡 승현 님의 핵심 로직: 28번째 픽셀까지만 Valid 1, 나머지는 0
                if (c <= 28) begin
                    valid_in = 1;
                end else begin
                    valid_in = 0; // 이 순간 PE0가 꺼지고, 1클럭 뒤 PE1이 꺼집니다!
                end
            end
        end
        
        // 파이프라인 비우기 (마지막 연산 결과가 바닥까지 떨어지도록 대기)
        @(negedge clk);
        iact_in = 0; valid_in = 0;
        
        #100 opcode = 2'b00;
        #100 $finish;
    end
endmodule