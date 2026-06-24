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
    // FC MAC Pipeline
    //
    // valid_in 기준 latency:
    //   +0 cycle: mul_reg capture
    //   +1 cycle: add1_reg capture
    //   +2 cycle: add2_reg capture
    //   +3 cycle: sum_tree_reg capture
    //   +4 cycle: acc_reg update
    //
    // 따라서 controller는 마지막 valid_in 이후 4 cycle을 기다린 뒤
    // end_node를 발생시켜야 한다.
    // =========================================================

    reg signed [15:0] mul_reg_0, mul_reg_1, mul_reg_2, mul_reg_3;
    reg signed [15:0] mul_reg_4, mul_reg_5, mul_reg_6, mul_reg_7;

    reg signed [16:0] add1_reg_0, add1_reg_1, add1_reg_2, add1_reg_3;

    reg signed [17:0] add2_reg_0, add2_reg_1;

    reg signed [18:0] sum_tree_reg;

    reg mul_valid;
    reg add1_valid;
    reg add2_valid;
    reg sum_valid;

    reg signed [BW_P-1:0] acc_reg;

    wire signed [BW_P-1:0] sum_tree_ext =
        {{(BW_P-19){sum_tree_reg[18]}}, sum_tree_reg};

    // =========================================================
    // 1. Pipelined MAC accumulation
    // =========================================================
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            mul_reg_0 <= 0; mul_reg_1 <= 0; mul_reg_2 <= 0; mul_reg_3 <= 0;
            mul_reg_4 <= 0; mul_reg_5 <= 0; mul_reg_6 <= 0; mul_reg_7 <= 0;

            add1_reg_0 <= 0; add1_reg_1 <= 0; add1_reg_2 <= 0; add1_reg_3 <= 0;
            add2_reg_0 <= 0; add2_reg_1 <= 0;
            sum_tree_reg <= 0;

            mul_valid  <= 1'b0;
            add1_valid <= 1'b0;
            add2_valid <= 1'b0;
            sum_valid  <= 1'b0;

            acc_reg <= 0;
        end else if (start_node) begin
            // node 시작 시 bias만 로드하고 pipeline valid를 비움
            acc_reg <= $signed(bias);

            mul_valid  <= 1'b0;
            add1_valid <= 1'b0;
            add2_valid <= 1'b0;
            sum_valid  <= 1'b0;
        end else begin
            // -------------------------
            // Stage 0: 8 multipliers
            // -------------------------
            mul_valid <= valid_in;

            if (valid_in) begin
                mul_reg_0 <= $signed(iact_0) * $signed(w_0);
                mul_reg_1 <= $signed(iact_1) * $signed(w_1);
                mul_reg_2 <= $signed(iact_2) * $signed(w_2);
                mul_reg_3 <= $signed(iact_3) * $signed(w_3);
                mul_reg_4 <= $signed(iact_4) * $signed(w_4);
                mul_reg_5 <= $signed(iact_5) * $signed(w_5);
                mul_reg_6 <= $signed(iact_6) * $signed(w_6);
                mul_reg_7 <= $signed(iact_7) * $signed(w_7);
            end

            // -------------------------
            // Stage 1: adder tree level 1
            // -------------------------
            add1_valid <= mul_valid;

            if (mul_valid) begin
                add1_reg_0 <= mul_reg_0 + mul_reg_1;
                add1_reg_1 <= mul_reg_2 + mul_reg_3;
                add1_reg_2 <= mul_reg_4 + mul_reg_5;
                add1_reg_3 <= mul_reg_6 + mul_reg_7;
            end

            // -------------------------
            // Stage 2: adder tree level 2
            // -------------------------
            add2_valid <= add1_valid;

            if (add1_valid) begin
                add2_reg_0 <= add1_reg_0 + add1_reg_1;
                add2_reg_1 <= add1_reg_2 + add1_reg_3;
            end

            // -------------------------
            // Stage 3: adder tree level 3
            // -------------------------
            sum_valid <= add2_valid;

            if (add2_valid) begin
                sum_tree_reg <= add2_reg_0 + add2_reg_1;
            end

            // -------------------------
            // Stage 4: accumulator
            // -------------------------
            if (sum_valid) begin
                acc_reg <= acc_reg + sum_tree_ext;
            end
        end
    end

    // =========================================================
    // 2. Activation / Quantization / Clamp
    // =========================================================

    wire signed [BW_P-1:0] act_val =
        (relu_en && acc_reg[BW_P-1]) ? {BW_P{1'b0}} : acc_reg;

    wire signed [BW_P-1:0] shifted_val =
        act_val >>> SHIFT_VAL;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            fc_out <= 0;
            valid_out <= 1'b0;
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
                fc_out <= fc_out;
            end
        end
    end

endmodule