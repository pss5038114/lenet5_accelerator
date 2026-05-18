`timescale 1ns / 1ps

module weight_buffer_array #(
    parameter BW_W = 8
)(
    input wire clk,
    input wire reset_n,
    
    // 💡 컨트롤러 제어 신호
    input wire shift_en, // 1일 때 BRAM->Buffer, Buffer->PE 방향으로 1칸씩 밀어냄
    
    // Weight BRAM (Port B)에서 들어오는 데이터
    input wire [BW_W-1:0] bram_w_0, bram_w_1, bram_w_2, bram_w_3,
    input wire [BW_W-1:0] bram_w_4, bram_w_5, bram_w_6, bram_w_7,
    
    // PE Array 상단의 weight_in_master 로 들어갈 데이터 (버퍼의 맨 끝단)
    output wire [BW_W-1:0] pe_w_0, pe_w_1, pe_w_2, pe_w_3,
    output wire [BW_W-1:0] pe_w_4, pe_w_5, pe_w_6, pe_w_7
);

    // 💡 8개 컬럼 x 5바이트 깊이의 쉬프트 레지스터 배열 선언
    reg [BW_W-1:0] buf_0 [0:4];
    reg [BW_W-1:0] buf_1 [0:4];
    reg [BW_W-1:0] buf_2 [0:4];
    reg [BW_W-1:0] buf_3 [0:4];
    reg [BW_W-1:0] buf_4 [0:4];
    reg [BW_W-1:0] buf_5 [0:4];
    reg [BW_W-1:0] buf_6 [0:4];
    reg [BW_W-1:0] buf_7 [0:4];

    integer i;

    // 출력은 항상 쉬프트 레지스터의 맨 끝(4번 인덱스)에 있는 값
    assign pe_w_0 = buf_0[4];
    assign pe_w_1 = buf_1[4];
    assign pe_w_2 = buf_2[4];
    assign pe_w_3 = buf_3[4];
    assign pe_w_4 = buf_4[4];
    assign pe_w_5 = buf_5[4];
    assign pe_w_6 = buf_6[4];
    assign pe_w_7 = buf_7[4];

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            for (i = 0; i < 5; i = i + 1) begin
                buf_0[i] <= 0; buf_1[i] <= 0; buf_2[i] <= 0; buf_3[i] <= 0;
                buf_4[i] <= 0; buf_5[i] <= 0; buf_6[i] <= 0; buf_7[i] <= 0;
            end
        end else if (shift_en) begin
            // 💡 데이터를 1칸씩 아래로 밀어냅니다. (4 <- 3 <- 2 <- 1 <- 0 <- BRAM)
            for (i = 4; i > 0; i = i - 1) begin
                buf_0[i] <= buf_0[i-1];
                buf_1[i] <= buf_1[i-1];
                buf_2[i] <= buf_2[i-1];
                buf_3[i] <= buf_3[i-1];
                buf_4[i] <= buf_4[i-1];
                buf_5[i] <= buf_5[i-1];
                buf_6[i] <= buf_6[i-1];
                buf_7[i] <= buf_7[i-1];
            end
            
            // 제일 앞쪽(0번 인덱스)에는 BRAM에서 새로 읽은 데이터를 채움
            buf_0[0] <= bram_w_0;
            buf_1[0] <= bram_w_1;
            buf_2[0] <= bram_w_2;
            buf_3[0] <= bram_w_3;
            buf_4[0] <= bram_w_4;
            buf_5[0] <= bram_w_5;
            buf_6[0] <= bram_w_6;
            buf_7[0] <= bram_w_7;
        end
    end

endmodule