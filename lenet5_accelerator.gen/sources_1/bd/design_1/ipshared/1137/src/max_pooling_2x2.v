`timescale 1ns / 1ps

module max_pooling_2x2 #(
    parameter BW_A = 8,
    parameter MAX_FM_WIDTH = 28 // 💡 칩에 물리적으로 만들 최대 크기 (메모리 할당용)
)(
    input wire clk,
    input wire reset_n,
    
    // 💡 컨트롤러에서 보내주는 현재 레이어의 피처맵 가로 크기 (예: 28 또는 10)
    input wire [7:0] fm_width, 
    
    input wire [BW_A-1:0] quant_in,
    input wire valid_in,
    
    output reg [BW_A-1:0] pool_out,
    output reg valid_out
);

    reg [7:0] col_cnt; // 가로 픽셀 위치 (여유 있게 8비트로 설정)
    reg row_lsb;       // 0: 짝수 줄 (위쪽), 1: 홀수 줄 (아래쪽)

    reg [BW_A-1:0] h_max; 

    // 💡 메모리는 무조건 '가장 큰 사이즈' 기준으로 물리적으로 고정 생성!
    reg [BW_A-1:0] line_buf [0:(MAX_FM_WIDTH/2)-1];

    wire [BW_A-1:0] current_max_1x2 = (h_max > quant_in) ? h_max : quant_in;
    
    wire [6:0] buf_idx = col_cnt[7:1]; // col_cnt / 2
    wire [BW_A-1:0] top_max_1x2 = line_buf[buf_idx];
    
    wire [BW_A-1:0] final_max_2x2 = (top_max_1x2 > current_max_1x2) ? top_max_1x2 : current_max_1x2;

    integer i;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            col_cnt <= 0;
            row_lsb <= 0;
            h_max <= 0;
            pool_out <= 0;
            valid_out <= 0;
            for (i = 0; i < (MAX_FM_WIDTH/2); i = i + 1) begin
                line_buf[i] <= 0;
            end
        end else begin
            if (valid_in) begin
                
                // --- 1. 데이터 처리 로직 ---
                if (col_cnt[0] == 1'b0) begin
                    h_max <= quant_in;
                    valid_out <= 1'b0; 
                end else begin
                    if (row_lsb == 1'b0) begin
                        line_buf[buf_idx] <= current_max_1x2;
                        valid_out <= 1'b0; 
                    end else begin
                        pool_out <= final_max_2x2;
                        valid_out <= 1'b1; 
                    end
                end

                // --- 2. 카운터 증가 로직 ---
                // 💡 고정된 파라미터가 아니라 컨트롤러가 준 fm_width와 비교!
                if (col_cnt == fm_width - 1) begin
                    col_cnt <= 0;            
                    row_lsb <= ~row_lsb;     
                end else begin
                    col_cnt <= col_cnt + 1;
                end
                
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule