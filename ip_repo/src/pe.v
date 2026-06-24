`timescale 1ns / 1ps

module pe #(
    parameter BW_W = 8, parameter BW_A = 8, parameter BW_P = 32,
    parameter IS_TOP_ROW = 0,   // 1이면 Valid 신호를 오른쪽으로도 전파
    parameter IS_RIGHT_COL = 0  // 1이면 iact_out 레지스터 최적화 (선택 사항)
)(
    input wire clk,
    input wire reset_n,
    input wire [1:0] opcode,
    input wire col_en, row_en,   // 💡 행/열 단위 제어 신호
    input wire signed [BW_A-1:0] iact_in, 
    input wire signed [BW_P-1:0] top_in, 
    input wire valid_in,         // 위에서 내려오는 Valid

    output reg signed [BW_A-1:0] iact_out, 
    output wire signed [BW_P-1:0] bottom_out, 
    output wire valid_out,       // 아래로 내려가는 Valid
    output reg valid_hor_out     // 💡 오른쪽으로 전달되는 Valid (Skew 생성용)
);

    wire en = col_en & row_en;   // 💡 최종 작동 신호
    reg signed [BW_W-1:0] weight_reg;
    reg signed [BW_P-1:0] product_reg;  
    reg signed [BW_P-1:0] psum_in_reg;  
    reg valid_stage1; 

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            weight_reg <= 0; product_reg <= 0; psum_in_reg <= 0;
            iact_out <= 0; valid_stage1 <= 0; valid_hor_out <= 0;
        end else if (en) begin
            case (opcode)
                2'b01: begin // LOAD
                    weight_reg <= top_in[BW_W-1:0];
                    valid_stage1 <= 0;
                    valid_hor_out <= 0;
                end
                2'b10: begin // MAC
                    if (!IS_RIGHT_COL) iact_out <= iact_in;
                    product_reg <= weight_reg * iact_in;
                    psum_in_reg <= top_in;
                    valid_stage1 <= valid_in;
                    // 💡 맨 윗줄인 경우에만 Valid를 옆으로 1클럭 지연시켜 전달
                    if (IS_TOP_ROW) valid_hor_out <= valid_in; 
                end
                default: begin
                    valid_stage1 <= 0;
                    valid_hor_out <= 0;
                end
            endcase
        end
    end

    // 💡 LOAD 모드일 때 top_in이 아닌 'weight_reg'를 내보내어 1클럭 지연(Shift) 유발
    assign bottom_out = (opcode == 2'b01) ? {{(BW_P-BW_W){weight_reg[BW_W-1]}}, weight_reg} : (product_reg + psum_in_reg);
    assign valid_out  = (opcode == 2'b01) ? 1'b0 : valid_stage1;

endmodule