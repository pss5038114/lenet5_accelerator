`timescale 1ns / 1ps

module pe_post_process_col #(
    parameter BW_P = 32,
    parameter BW_A = 8,
    parameter SHIFT_VAL = 4,
    parameter MAX_FM_WIDTH = 28 // 💡 물리적으로 생성할 최대 라인 버퍼 크기
)(
    input wire clk,
    input wire reset_n,
    
    // 💡 컨트롤러로부터 현재 연산 중인 피처맵의 가로 길이를 받음 (가변)
    input wire [7:0] fm_width, 

    // Demux에서 내려오는 32비트 PSum
    input wire signed [BW_P-1:0] psum_in,
    input wire valid_in,
    
    // 최종적으로 UBRAM에 들어갈 8비트 Pooling 결과
    output wire [BW_A-1:0] pool_out,
    output wire valid_out
);

    // 내부 연결선
    wire [BW_A-1:0] quant_data;
    wire quant_valid;

    // 1. 8비트 양자화 & ReLU 모듈 (이 모듈은 크기와 상관없이 동작하므로 유지)
    quant_relu #(
        .BW_P(BW_P), .BW_A(BW_A), .SHIFT_VAL(SHIFT_VAL)
    ) u_quant (
        .clk(clk),
        .reset_n(reset_n),
        .psum_in(psum_in),
        .valid_in(valid_in),
        .quant_out(quant_data),
        .valid_out(quant_valid)
    );

    // 2. 2x2 Max Pooling 모듈 (범용 버전으로 인스턴스화)
    max_pooling_2x2 #(
        .BW_A(BW_A), 
        .MAX_FM_WIDTH(MAX_FM_WIDTH) // 물리적 최대치 전달
    ) u_pool (
        .clk(clk),
        .reset_n(reset_n),
        .fm_width(fm_width),        // 💡 컨트롤러에서 온 현재 크기 연결
        .quant_in(quant_data),
        .valid_in(quant_valid),
        .pool_out(pool_out),
        .valid_out(valid_out)
    );

endmodule