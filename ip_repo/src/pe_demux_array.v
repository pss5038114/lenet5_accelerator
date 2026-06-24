`timescale 1ns / 1ps

module pe_demux_array #(
    parameter BW_P = 32,
    parameter NUM_COL = 8
)(
    input wire clk,
    input wire reset_n,
    
    input wire route_ctrl_master, 

    input wire [(NUM_COL*BW_P)-1:0] bottom_out_arr,
    input wire [NUM_COL-1:0] valid_in_arr,
    
    output wire [(NUM_COL*BW_P)-1:0] out_bram_data_arr,
    output wire [NUM_COL-1:0] out_bram_valid_arr,

    output wire [(NUM_COL*BW_P)-1:0] out_quant_data_arr,
    output wire [NUM_COL-1:0] out_quant_valid_arr
);

    // 💡 수정 1: 배열이 아닌 단일 Vector로 선언하여 에러 원천 차단
    reg [NUM_COL-1:0] route_ctrl_shift;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            route_ctrl_shift <= 0;
        end else begin
            // 💡 수정 2: for문 대신 Concatenation({})을 사용하여 Shift 레지스터 구현!
            // 마스터 신호가에 들어가고, 기존 값들은,... 왼쪽으로 밀려납니다.
            route_ctrl_shift <= {route_ctrl_shift[NUM_COL-2:0], route_ctrl_master};
        end
    end

    genvar i;
    generate
        for (i = 0; i < NUM_COL; i = i + 1) begin : DEMUX_GEN
            
            wire [BW_P-1:0] curr_bottom_out = bottom_out_arr[(i*BW_P) +: BW_P];
            wire curr_valid_in = valid_in_arr[i];
            
            wire [BW_P-1:0] curr_bram_data; wire curr_bram_valid;
            wire [BW_P-1:0] curr_quant_data; wire curr_quant_valid;

            pe_out_demux #(.BW_P(BW_P)) demux_inst (
                .bottom_out(curr_bottom_out),
                .valid_in(curr_valid_in),
                
                // Vector의 인덱스 접근은 비바도에서 100% 안전하게 통과됨
                .route_ctrl(route_ctrl_shift[i]), 
                
                .out_bram_data(curr_bram_data),
                .out_bram_valid(curr_bram_valid),
                .out_quant_data(curr_quant_data),
                .out_quant_valid(curr_quant_valid)
            );
            
            assign out_bram_data_arr[(i*BW_P) +: BW_P] = curr_bram_data;
            assign out_bram_valid_arr[i] = curr_bram_valid;
            
            assign out_quant_data_arr[(i*BW_P) +: BW_P] = curr_quant_data;
            assign out_quant_valid_arr[i] = curr_quant_valid;
            
        end
    endgenerate

endmodule