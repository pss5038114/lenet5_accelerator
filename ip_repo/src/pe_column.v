`timescale 1ns / 1ps

module pe_column #(
    parameter BW_W = 8,
    parameter BW_A = 8,
    parameter BW_P = 32,
    parameter NUM_PE = 5,       
    parameter IS_RIGHT_COL = 0  
)(
    input wire clk,
    input wire reset_n,
    input wire [1:0] opcode,
    input wire col_en,
    input wire [NUM_PE-1:0] row_en,
    
    // 💡 변경: 40비트가 아닌 단일 8비트 입력을 받아 5개 PE에 동시 분배 (Broadcast)
    input wire [BW_A-1:0] iact_in, 
    
    // 출력은 오른쪽 PE들로 전달해야 하므로 각 행별로 8비트씩 총 40비트 유지
    output wire [(NUM_PE*BW_A)-1:0] iact_out,
    
    // 위에서 내려오는 PSum (32비트) 및 가중치 (하위 8비트 사용)
    input wire [BW_P-1:0] top_in,
    input wire valid_in,
    
    output wire [BW_P-1:0] bottom_out,
    output wire valid_out,
    output wire valid_hor_out
);

    wire [BW_P-1:0] psum_cascade [0:NUM_PE];
    wire valid_cascade [0:NUM_PE];
    
    assign psum_cascade[0] = top_in;
    assign valid_cascade[0] = valid_in;
    assign bottom_out = psum_cascade[NUM_PE];
    assign valid_out  = valid_cascade[NUM_PE];

    genvar i;
    generate
        for (i = 0; i < NUM_PE; i = i + 1) begin : PE_ARRAY
            localparam TOP_ROW_FLAG = (i == 0) ? 1 : 0;
            wire [BW_A-1:0] curr_iact_out;
            wire curr_valid_hor;

            pe #(
                .BW_W(BW_W), .BW_A(BW_A), .BW_P(BW_P),
                .IS_TOP_ROW(TOP_ROW_FLAG),
                .IS_RIGHT_COL(IS_RIGHT_COL)
            ) pe_inst (
                .clk(clk),
                .reset_n(reset_n),
                .opcode(opcode),
                .col_en(col_en),
                .row_en(row_en[i]),
                
                // 💡 핵심: 5개 PE 모두 동일한 iact_in 선에 다이렉트 연결
                .iact_in(iact_in), 
                
                .top_in(psum_cascade[i]),
                .valid_in(valid_cascade[i]),
                
                .iact_out(curr_iact_out),
                .bottom_out(psum_cascade[i+1]),
                .valid_out(valid_cascade[i+1]),
                .valid_hor_out(curr_valid_hor)
            );
            
            assign iact_out[(i*BW_A) +: BW_A] = curr_iact_out;
            
            if (i == 0) begin
                assign valid_hor_out = curr_valid_hor;
            end
        end
    endgenerate

endmodule