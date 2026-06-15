`timescale 1ns / 1ps

module fc_module_top #(
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

    // 추가: FC1/FC2는 1, FC3는 0
    input wire relu_en,
    
    input wire [BW_A-1:0] iact_0, iact_1, iact_2, iact_3, 
    input wire [BW_A-1:0] iact_4, iact_5, iact_6, iact_7,

    input wire [BW_W-1:0] w_0, w_1, w_2, w_3,
    input wire [BW_W-1:0] w_4, w_5, w_6, w_7,

    input wire [BW_P-1:0] bias,
    
    output reg [7:0] fc_we,

    output wire [BW_A-1:0] fc_din_0, fc_din_1, fc_din_2, fc_din_3, 
    output wire [BW_A-1:0] fc_din_4, fc_din_5, fc_din_6, fc_din_7
);

    wire [BW_A-1:0] core_out;
    wire core_valid;

    fc_core #(
        .BW_A(BW_A),
        .BW_W(BW_W),
        .BW_P(BW_P),
        .SHIFT_VAL(SHIFT_VAL)
    ) u_core (
        .clk(clk),
        .reset_n(reset_n),

        .start_node(start_node),
        .valid_in(valid_in),
        .end_node(end_node),

        .relu_en(relu_en),

        .iact_0(iact_0),
        .iact_1(iact_1),
        .iact_2(iact_2),
        .iact_3(iact_3),
        .iact_4(iact_4),
        .iact_5(iact_5),
        .iact_6(iact_6),
        .iact_7(iact_7),

        .w_0(w_0),
        .w_1(w_1),
        .w_2(w_2),
        .w_3(w_3),
        .w_4(w_4),
        .w_5(w_5),
        .w_6(w_6),
        .w_7(w_7),

        .bias(bias),

        .fc_out(core_out),
        .valid_out(core_valid)
    );

    // =========================================================
    // Bank steering
    // =========================================================
    reg [2:0] bank_idx;

    // core_out은 모든 bank input으로 복사
    // 실제 저장 bank는 fc_we one-hot으로 결정
    assign fc_din_0 = core_out;
    assign fc_din_1 = core_out;
    assign fc_din_2 = core_out;
    assign fc_din_3 = core_out;
    assign fc_din_4 = core_out;
    assign fc_din_5 = core_out;
    assign fc_din_6 = core_out;
    assign fc_din_7 = core_out;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            bank_idx <= 3'd0;
            fc_we <= 8'd0;
        end else begin
            if (core_valid) begin
                fc_we <= (8'd1 << bank_idx);
                bank_idx <= bank_idx + 3'd1;
            end else begin
                fc_we <= 8'd0;
            end
        end
    end

endmodule