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
    
    input wire [BW_A-1:0] iact_0, iact_1, iact_2, iact_3,
    input wire [BW_A-1:0] iact_4, iact_5, iact_6, iact_7,

    input wire [BW_W-1:0] w_0, w_1, w_2, w_3,
    input wire [BW_W-1:0] w_4, w_5, w_6, w_7,

    input wire [BW_P-1:0] bias,
    
    output reg [BW_A-1:0] fc_out,
    output reg valid_out
);

    wire signed [15:0] mul [0:7];
    
    assign mul[0] = $signed(iact_0) * $signed(w_0);
    assign mul[1] = $signed(iact_1) * $signed(w_1);
    assign mul[2] = $signed(iact_2) * $signed(w_2);
    assign mul[3] = $signed(iact_3) * $signed(w_3);
    assign mul[4] = $signed(iact_4) * $signed(w_4);
    assign mul[5] = $signed(iact_5) * $signed(w_5);
    assign mul[6] = $signed(iact_6) * $signed(w_6);
    assign mul[7] = $signed(iact_7) * $signed(w_7);

    wire signed [16:0] add_lvl1_0 = mul[0] + mul[1];
    wire signed [16:0] add_lvl1_1 = mul[2] + mul[3];
    wire signed [16:0] add_lvl1_2 = mul[4] + mul[5];
    wire signed [16:0] add_lvl1_3 = mul[6] + mul[7];

    wire signed [17:0] add_lvl2_0 = add_lvl1_0 + add_lvl1_1;
    wire signed [17:0] add_lvl2_1 = add_lvl1_2 + add_lvl1_3;

    wire signed [18:0] sum_tree = add_lvl2_0 + add_lvl2_1;

    reg signed [BW_P-1:0] acc_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc_reg <= 0;
        end else if (start_node) begin
            // 수정: node 시작 시에는 bias만 로드
            acc_reg <= $signed(bias);
        end else if (valid_in) begin
            acc_reg <= acc_reg + sum_tree;
        end
    end

    wire signed [BW_P-1:0] relu_val =
        (acc_reg[BW_P-1]) ? 32'd0 : acc_reg;

    wire signed [BW_P-1:0] shifted_val =
        relu_val >>> SHIFT_VAL;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            fc_out <= 0;
            valid_out <= 0;
        end else begin
            if (end_node) begin
                valid_out <= 1'b1;

                if (shifted_val > 127)
                    fc_out <= 8'sd127;
                else
                    fc_out <= shifted_val[BW_A-1:0];
            end else begin
                valid_out <= 1'b0;

                // 중요: fc_we가 한 박자 늦게 켜질 수 있으므로 결과를 0으로 지우지 않음
                fc_out <= fc_out;
            end
        end
    end

endmodule