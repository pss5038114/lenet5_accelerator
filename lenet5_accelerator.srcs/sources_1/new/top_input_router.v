`timescale 1ns / 1ps

module top_input_router #(
    parameter BW_W = 8,
    parameter BW_P = 32
)(
    input wire clk,
    input wire reset_n,

    // 💡 컨트롤러 제어 신호
    input wire [1:0] opcode,    // 0: IDLE, 1: PRELOAD, 2: CALC
    input wire use_bias,        // 1: Stage 1 (Bias 사용), 0: Stage 2~5 (PSum 사용)

    // Weight Buffer에서 오는 8비트 데이터 (Opcode 1일 때 통과)
    input wire [BW_W-1:0] w_0, w_1, w_2, w_3, w_4, w_5, w_6, w_7,

    // Bias BRAM (Port B)에서 오는 32비트 데이터
    input wire [BW_P-1:0] b_0, b_1, b_2, b_3, b_4, b_5, b_6, b_7,

    // Output BRAM (Port B)에서 오는 32비트 데이터 (PSum 피드백)
    input wire [BW_P-1:0] p_0, p_1, p_2, p_3, p_4, p_5, p_6, p_7,

    // PE Array의 top_in_master로 들어갈 최종 32비트 데이터
    output reg [BW_P-1:0] top_in_0, top_in_1, top_in_2, top_in_3,
    output reg [BW_P-1:0] top_in_4, top_in_5, top_in_6, top_in_7
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            top_in_0 <= 0; top_in_1 <= 0; top_in_2 <= 0; top_in_3 <= 0;
            top_in_4 <= 0; top_in_5 <= 0; top_in_6 <= 0; top_in_7 <= 0;
        end else begin
            if (opcode == 2'd1) begin
                // 💡 [PRELOAD 모드] 
                // Weight는 8비트이므로 상위 24비트를 0으로 채워(Zero-padding) 32비트로 만듦
                top_in_0 <= {24'd0, w_0};
                top_in_1 <= {24'd0, w_1};
                top_in_2 <= {24'd0, w_2};
                top_in_3 <= {24'd0, w_3};
                top_in_4 <= {24'd0, w_4};
                top_in_5 <= {24'd0, w_5};
                top_in_6 <= {24'd0, w_6};
                top_in_7 <= {24'd0, w_7};
            end 
            else if (opcode == 2'd2) begin
                // 💡 [CALC 모드] 
                // Stage에 따라 MUX를 통해 Bias BRAM 또는 Output BRAM 값을 선택
                top_in_0 <= use_bias ? b_0 : p_0;
                top_in_1 <= use_bias ? b_1 : p_1;
                top_in_2 <= use_bias ? b_2 : p_2;
                top_in_3 <= use_bias ? b_3 : p_3;
                top_in_4 <= use_bias ? b_4 : p_4;
                top_in_5 <= use_bias ? b_5 : p_5;
                top_in_6 <= use_bias ? b_6 : p_6;
                top_in_7 <= use_bias ? b_7 : p_7;
            end 
            else begin
                // [IDLE 모드]
                top_in_0 <= 0; top_in_1 <= 0; top_in_2 <= 0; top_in_3 <= 0;
                top_in_4 <= 0; top_in_5 <= 0; top_in_6 <= 0; top_in_7 <= 0;
            end
        end
    end

endmodule