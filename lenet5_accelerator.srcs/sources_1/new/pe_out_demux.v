`timescale 1ns / 1ps

module pe_out_demux #(
    parameter BW_P = 32
)(
    // PE Column에서 내려오는 입력
    input wire [BW_P-1:0] bottom_out,
    input wire valid_in,
    
    // 컨트롤러 신호 (0: Output BRAM으로, 1: Quant/Pool 모듈로)
    input wire route_ctrl, 

    // Path 0: Output BRAM으로 가는 길
    output wire [BW_P-1:0] out_bram_data,
    output wire out_bram_valid,
    
    // Path 1: 8비트 양자화 & 풀링 모듈로 가는 길
    output wire [BW_P-1:0] out_quant_data,
    output wire out_quant_valid
);

    // 💡 route_ctrl == 0 일 때만 BRAM 쪽으로 데이터와 Valid 전송 (아니면 0으로 차단)
    assign out_bram_data  = (route_ctrl == 1'b0) ? bottom_out : {BW_P{1'b0}};
    assign out_bram_valid = (route_ctrl == 1'b0) ? valid_in : 1'b0;

    // 💡 route_ctrl == 1 일 때만 양자화 모듈 쪽으로 데이터와 Valid 전송
    assign out_quant_data  = (route_ctrl == 1'b1) ? bottom_out : {BW_P{1'b0}};
    assign out_quant_valid = (route_ctrl == 1'b1) ? valid_in : 1'b0;

endmodule