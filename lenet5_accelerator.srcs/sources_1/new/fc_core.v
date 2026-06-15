`timescale 1ns / 1ps

module fc_core #(
    parameter BW_A = 8,
    parameter BW_W = 8,
    parameter BW_P = 32,
    parameter SHIFT_VAL = 4
)(
    input wire clk,
    input wire reset_n,
    
    input wire start_node,
    input wire valid_in,
    input wire end_node,

    // 1이면 ReLU 적용, 0이면 ReLU 미적용
    // FC1, FC2: 1
    // FC3: 0
    input wire relu_en,
    
    input wire [BW_A-1:0] iact_0, iact_1, iact_2, iact_3,
    input wire [BW_A-1:0] iact_4, iact_5, iact_6, iact_7,

    input wire [BW_W-1:0] w_0, w_1, w_2, w_3,
    input wire [BW_W-1:0] w_4, w_5, w_6, w_7,

    input wire [BW_P-1:0] bias,
    
    output reg [BW_A-1:0] fc_out,
    output reg valid_out
);

    // =========================================================
    // 1. 8 parallel multipliers
    // =========================================================
    wire signed [15:0] mul [0:7];
    
    assign mul[0] = $signed(iact_0) * $signed(w_0);
    assign mul[1] = $signed(iact_1) * $signed(w_1);
    assign mul[2] = $signed(iact_2) * $signed(w_2);
    assign mul[3] = $signed(iact_3) * $signed(w_3);
    assign mul[4] = $signed(iact_4) * $signed(w_4);
    assign mul[5] = $signed(iact_5) * $signed(w_5);
    assign mul[6] = $signed(iact_6) * $signed(w_6);
    assign mul[7] = $signed(iact_7) * $signed(w_7);

    // =========================================================
    // 2. Adder tree
    // =========================================================
    wire signed [16:0] add_lvl1_0 = mul[0] + mul[1];
    wire signed [16:0] add_lvl1_1 = mul[2] + mul[3];
    wire signed [16:0] add_lvl1_2 = mul[4] + mul[5];
    wire signed [16:0] add_lvl1_3 = mul[6] + mul[7];

    wire signed [17:0] add_lvl2_0 = add_lvl1_0 + add_lvl1_1;
    wire signed [17:0] add_lvl2_1 = add_lvl1_2 + add_lvl1_3;

    wire signed [18:0] sum_tree = add_lvl2_0 + add_lvl2_1;

    // =========================================================
    // 3. Accumulator
    // =========================================================
    reg signed [BW_P-1:0] acc_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc_reg <= 0;
        end else if (start_node) begin
            // node 시작 시 bias만 로드
            // 첫 유효 데이터는 valid_in에서 누적
            acc_reg <= $signed(bias);
        end else if (valid_in) begin
            acc_reg <= acc_reg + sum_tree;
        end
    end

    // =========================================================
    // 4. Activation / Quantization / Clamp
    // =========================================================

    // relu_en = 1이면 음수 제거
    // relu_en = 0이면 FC3이므로 음수 유지
    wire signed [BW_P-1:0] act_val =
        (relu_en && acc_reg[BW_P-1]) ? {BW_P{1'b0}} : acc_reg;

    wire signed [BW_P-1:0] shifted_val =
        act_val >>> SHIFT_VAL;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            fc_out <= 0;
            valid_out <= 0;
        end else begin
            if (end_node) begin
                valid_out <= 1'b1;

                if (relu_en) begin
                    // FC1, FC2:
                    // ReLU 이후이므로 출력 범위는 0~127
                    if (shifted_val > 32'sd127)
                        fc_out <= 8'sd127;
                    else if (shifted_val < 32'sd0)
                        fc_out <= 8'sd0;
                    else
                        fc_out <= shifted_val[BW_A-1:0];
                end else begin
                    // FC3:
                    // ReLU 없음. signed 8-bit 범위 -128~127로 clamp
                    if (shifted_val > 32'sd127)
                        fc_out <= 8'sd127;
                    else if (shifted_val < -32'sd128)
                        fc_out <= -8'sd128;
                    else
                        fc_out <= shifted_val[BW_A-1:0];
                end
            end else begin
                valid_out <= 1'b0;

                // fc_we가 한 박자 늦게 들어올 수 있으므로 출력값 유지
                fc_out <= fc_out;
            end
        end
    end

endmodule