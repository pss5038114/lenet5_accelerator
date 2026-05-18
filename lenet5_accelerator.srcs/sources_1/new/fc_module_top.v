`timescale 1ns / 1ps

module fc_module_top #(
    parameter BW_A = 8,
    parameter BW_W = 8,
    parameter BW_P = 32,
    parameter SHIFT_VAL = 4
)(
    input wire clk,
    input wire reset_n,
    
    // 💡 컨트롤러 제어 신호
    input wire start_node,
    input wire valid_in,
    input wire end_node,
    
    // 📥 입력 데이터 (UBRAM, Weight, Bias)
    input wire [BW_A-1:0] iact_0, iact_1, iact_2, iact_3, iact_4, iact_5, iact_6, iact_7,
    input wire [BW_W-1:0] w_0, w_1, w_2, w_3, w_4, w_5, w_6, w_7,
    input wire [BW_P-1:0] bias,
    
    // 📤 라우터(data_router_top)로 나가는 쓰기 신호
    output reg [7:0] fc_we,
    output wire [BW_A-1:0] fc_din_0, fc_din_1, fc_din_2, fc_din_3, 
    output wire [BW_A-1:0] fc_din_4, fc_din_5, fc_din_6, fc_din_7
);

    wire [BW_A-1:0] core_out;
    wire core_valid;

    // 1. FC 코어(곱셈+에더트리+누적+양자화) 인스턴스화
    fc_core #(
        .BW_A(BW_A), .BW_W(BW_W), .BW_P(BW_P), .SHIFT_VAL(SHIFT_VAL)
    ) u_core (
        .clk(clk), .reset_n(reset_n),
        .start_node(start_node), .valid_in(valid_in), .end_node(end_node),
        .iact_0(iact_0), .iact_1(iact_1), .iact_2(iact_2), .iact_3(iact_3),
        .iact_4(iact_4), .iact_5(iact_5), .iact_6(iact_6), .iact_7(iact_7),
        .w_0(w_0), .w_1(w_1), .w_2(w_2), .w_3(w_3),
        .w_4(w_4), .w_5(w_5), .w_6(w_6), .w_7(w_7),
        .bias(bias),
        .fc_out(core_out), .valid_out(core_valid)
    );

    // =========================================================
    // 2. 뱅크 분배 로직 (Bank Steering)
    // =========================================================
    reg [2:0] bank_idx; // 0 ~ 7 카운터

    // 데이터는 8개 포트에 모두 동일하게 복사해서 쏴줍니다. 
    // (어차피 fc_we가 1인 뱅크에만 저장되므로 수학적으로 완벽합니다)
    assign fc_din_0 = core_out; assign fc_din_1 = core_out;
    assign fc_din_2 = core_out; assign fc_din_3 = core_out;
    assign fc_din_4 = core_out; assign fc_din_5 = core_out;
    assign fc_din_6 = core_out; assign fc_din_7 = core_out;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            bank_idx <= 0;
            fc_we <= 8'd0;
        end else begin
            if (core_valid) begin
                // 💡 마법의 한 줄: 1을 bank_idx만큼 왼쪽으로 시프트하여 해당 뱅크의 WE만 켬!
                fc_we <= (8'd1 << bank_idx);
                bank_idx <= bank_idx + 1; // 0~7을 찍고 자연스럽게 0으로 오버플로우(순환)
            end else begin
                fc_we <= 8'd0;
            end
        end
    end

endmodule