`timescale 1ns / 1ps

module lenet5_top #(
    parameter BW_A = 8,
    parameter BW_W = 8,
    parameter BW_P = 32
)(
    input wire clk,
    input wire reset_n,
    
    // ==========================================
    // 🚀 [외부 인터페이스] PS / DMA 제어 신호
    // ==========================================
    input wire dma_done,       // 이미지/가중치 로드 완료 펄스
    input wire ps_read_done,   // PS단에서 최종 결과 읽기 완료 펄스
    output wire [2:0] current_state, // 현재 동작 상태 (디버깅용)

    // ==========================================
    // 📥 [외부 인터페이스] DMA 데이터 주입 포트
    // ==========================================
    // 1. Initial Image (UBRAM A에 저장할 32x32 입력)
    input wire [7:0] dma_img_we,
    input wire [BW_A-1:0] dma_img_din_0, dma_img_din_1, dma_img_din_2, dma_img_din_3, 
    input wire [BW_A-1:0] dma_img_din_4, dma_img_din_5, dma_img_din_6, dma_img_din_7,
    
    // 2. Weights (Weight BRAM에 저장)
    input wire [7:0] dma_w_we,
    input wire [12:0] dma_w_addr,
    input wire [BW_W-1:0] dma_w_din_0, dma_w_din_1, dma_w_din_2, dma_w_din_3,
    input wire [BW_W-1:0] dma_w_din_4, dma_w_din_5, dma_w_din_6, dma_w_din_7,

    // 3. Bias (Bias BRAM에 저장)
    input wire [7:0] dma_b_we,
    input wire [6:0] dma_b_addr, // Depth 128로 늘린 주소폭 반영
    input wire [BW_P-1:0] dma_b_din_0, dma_b_din_1, dma_b_din_2, dma_b_din_3,
    input wire [BW_P-1:0] dma_b_din_4, dma_b_din_5, dma_b_din_6, dma_b_din_7
);

    // =========================================================
    // 🔗 1. 내부 제어 와이어 (FSM -> 하위 모듈)
    // =========================================================
    wire ping_pong_state;
    wire [1:0] mode_select, opcode;
    wire [7:0] input_width, fm_width;
    wire shift_en, use_bias, start;
    wire [2:0] stage_idx;
    wire start_node, valid_in, end_node;

    lenet5_ctrl u_ctrl (
        .clk(clk), .reset_n(reset_n),
        .dma_done(dma_done), .ps_read_done(ps_read_done),
        .ping_pong_state(ping_pong_state), .mode_select(mode_select),
        .input_width(input_width), .fm_width(fm_width),
        .shift_en(shift_en), .opcode(opcode), .use_bias(use_bias),
        .start(start), .stage_idx(stage_idx),
        .start_node(start_node), .valid_in(valid_in), .end_node(end_node),
        .current_state(current_state)
    );

    // =========================================================
    // 🔗 2. BRAM & 데이터 라우터 와이어링
    // =========================================================
    wire [7:0] we_a, we_b;
    wire [BW_A-1:0] din_a_0, din_a_1, din_a_2, din_a_3, din_a_4, din_a_5, din_a_6, din_a_7;
    wire [BW_A-1:0] din_b_0, din_b_1, din_b_2, din_b_3, din_b_4, din_b_5, din_b_6, din_b_7;
    
    wire [BW_A-1:0] dout_a_0, dout_a_1, dout_a_2, dout_a_3, dout_a_4, dout_a_5, dout_a_6, dout_a_7;
    wire [BW_A-1:0] dout_b_0, dout_b_1, dout_b_2, dout_b_3, dout_b_4, dout_b_5, dout_b_6, dout_b_7;
    wire [BW_A-1:0] read_out_0, read_out_1, read_out_2, read_out_3, read_out_4, read_out_5, read_out_6, read_out_7;

    // 모듈별 출력 와이어 (라우터 입력용)
    wire [7:0] conv_we, fc_we;
    wire [BW_A-1:0] conv_din_0, conv_din_1, conv_din_2, conv_din_3, conv_din_4, conv_din_5, conv_din_6, conv_din_7;
    wire [BW_A-1:0] fc_din_0, fc_din_1, fc_din_2, fc_din_3, fc_din_4, fc_din_5, fc_din_6, fc_din_7;

    data_router_top u_router (
        .ping_pong_state(ping_pong_state), .mode_select(mode_select),
        .dout_a_0(dout_a_0), .dout_a_1(dout_a_1), .dout_a_2(dout_a_2), .dout_a_3(dout_a_3), .dout_a_4(dout_a_4), .dout_a_5(dout_a_5), .dout_a_6(dout_a_6), .dout_a_7(dout_a_7),
        .dout_b_0(dout_b_0), .dout_b_1(dout_b_1), .dout_b_2(dout_b_2), .dout_b_3(dout_b_3), .dout_b_4(dout_b_4), .dout_b_5(dout_b_5), .dout_b_6(dout_b_6), .dout_b_7(dout_b_7),
        .read_out_0(read_out_0), .read_out_1(read_out_1), .read_out_2(read_out_2), .read_out_3(read_out_3), .read_out_4(read_out_4), .read_out_5(read_out_5), .read_out_6(read_out_6), .read_out_7(read_out_7),
        
        .dma_we(dma_img_we), .dma_din_0(dma_img_din_0), .dma_din_1(dma_img_din_1), .dma_din_2(dma_img_din_2), .dma_din_3(dma_img_din_3), .dma_din_4(dma_img_din_4), .dma_din_5(dma_img_din_5), .dma_din_6(dma_img_din_6), .dma_din_7(dma_img_din_7),
        .conv_we(conv_we), .conv_din_0(conv_din_0), .conv_din_1(conv_din_1), .conv_din_2(conv_din_2), .conv_din_3(conv_din_3), .conv_din_4(conv_din_4), .conv_din_5(conv_din_5), .conv_din_6(conv_din_6), .conv_din_7(conv_din_7),
        .fc_we(fc_we), .fc_din_0(fc_din_0), .fc_din_1(fc_din_1), .fc_din_2(fc_din_2), .fc_din_3(fc_din_3), .fc_din_4(fc_din_4), .fc_din_5(fc_din_5), .fc_din_6(fc_din_6), .fc_din_7(fc_din_7),
        
        .we_a(we_a), .we_b(we_b),
        .din_a_0(din_a_0), .din_a_1(din_a_1), .din_a_2(din_a_2), .din_a_3(din_a_3), .din_a_4(din_a_4), .din_a_5(din_a_5), .din_a_6(din_a_6), .din_a_7(din_a_7),
        .din_b_0(din_b_0), .din_b_1(din_b_1), .din_b_2(din_b_2), .din_b_3(din_b_3), .din_b_4(din_b_4), .din_b_5(din_b_5), .din_b_6(din_b_6), .din_b_7(din_b_7)
    );

    // UBRAM 주소 카운터 (Conv와 FC가 공유하거나 라우팅 필요)
    wire [11:0] ubram_addr; // 임시: Input Buffer 또는 FC 모듈이 제공하는 주소로 연결 필요
    
    ubram_a_wrapper u_ubram_a (
        .clk(clk), .we_arr(we_a), .addr_w(ubram_addr), // 주의: 쓰기 주소 추가 연결 필요
        .din_0(din_a_0), .din_1(din_a_1), .din_2(din_a_2), .din_3(din_a_3), .din_4(din_a_4), .din_5(din_a_5), .din_6(din_a_6), .din_7(din_a_7),
        .addr_r(ubram_addr), // 주의: 읽기 주소 추가 연결 필요
        .dout_0(dout_a_0), .dout_1(dout_a_1), .dout_2(dout_a_2), .dout_3(dout_a_3), .dout_4(dout_a_4), .dout_5(dout_a_5), .dout_6(dout_a_6), .dout_7(dout_a_7)
    );

    ubram_b_wrapper u_ubram_b (
        .clk(clk), .we_arr(we_b), .addr_w(ubram_addr), 
        .din_0(din_b_0), .din_1(din_b_1), .din_2(din_b_2), .din_3(din_b_3), .din_4(din_b_4), .din_5(din_b_5), .din_6(din_b_6), .din_7(din_b_7),
        .addr_r(ubram_addr), 
        .dout_0(dout_b_0), .dout_1(dout_b_1), .dout_2(dout_b_2), .dout_3(dout_b_3), .dout_4(dout_b_4), .dout_5(dout_b_5), .dout_6(dout_b_6), .dout_7(dout_b_7)
    );

    // =========================================================
    // 🔗 3. 가중치 / 바이어스 BRAM 및 로컬 버퍼
    // =========================================================
    wire [12:0] w_addr_r; // FSM 카운터에서 제공
    wire [6:0]  b_addr_r; // FSM 카운터에서 제공
    
    wire [BW_W-1:0] w_dout_0, w_dout_1, w_dout_2, w_dout_3, w_dout_4, w_dout_5, w_dout_6, w_dout_7;
    wire [BW_W-1:0] w_buf_0, w_buf_1, w_buf_2, w_buf_3, w_buf_4, w_buf_5, w_buf_6, w_buf_7;
    
    wire [BW_P-1:0] b_dout_0, b_dout_1, b_dout_2, b_dout_3, b_dout_4, b_dout_5, b_dout_6, b_dout_7;

    weight_bram_wrapper u_weight_bram (
        .clk(clk), .we_arr(dma_w_we), .addr_w(dma_w_addr),
        .din_0(dma_w_din_0), .din_1(dma_w_din_1), .din_2(dma_w_din_2), .din_3(dma_w_din_3), .din_4(dma_w_din_4), .din_5(dma_w_din_5), .din_6(dma_w_din_6), .din_7(dma_w_din_7),
        .addr_r(w_addr_r),
        .dout_0(w_dout_0), .dout_1(w_dout_1), .dout_2(w_dout_2), .dout_3(w_dout_3), .dout_4(w_dout_4), .dout_5(w_dout_5), .dout_6(w_dout_6), .dout_7(w_dout_7)
    );

    weight_buffer_array u_weight_buf (
        .clk(clk), .reset_n(reset_n), .shift_en(shift_en),
        .bram_w_0(w_dout_0), .bram_w_1(w_dout_1), .bram_w_2(w_dout_2), .bram_w_3(w_dout_3), .bram_w_4(w_dout_4), .bram_w_5(w_dout_5), .bram_w_6(w_dout_6), .bram_w_7(w_dout_7),
        .pe_w_0(w_buf_0), .pe_w_1(w_buf_1), .pe_w_2(w_buf_2), .pe_w_3(w_buf_3), .pe_w_4(w_buf_4), .pe_w_5(w_buf_5), .pe_w_6(w_buf_6), .pe_w_7(w_buf_7)
    );

    bias_bram_wrapper u_bias_bram (
        .clk(clk), .we_arr(dma_b_we), .addr_w(dma_b_addr),
        .din_0(dma_b_din_0), .din_1(dma_b_din_1), .din_2(dma_b_din_2), .din_3(dma_b_din_3), .din_4(dma_b_din_4), .din_5(dma_b_din_5), .din_6(dma_b_din_6), .din_7(dma_b_din_7),
        .addr_r(b_addr_r),
        .dout_0(b_dout_0), .dout_1(b_dout_1), .dout_2(b_dout_2), .dout_3(b_dout_3), .dout_4(b_dout_4), .dout_5(b_dout_5), .dout_6(b_dout_6), .dout_7(b_dout_7)
    );

    // =========================================================
    // 🔗 4. FC 모듈 (Fully Connected)
    // =========================================================
    fc_module_top u_fc_module (
        .clk(clk), .reset_n(reset_n),
        .start_node(start_node), .valid_in(valid_in), .end_node(end_node),
        .iact_0(read_out_0), .iact_1(read_out_1), .iact_2(read_out_2), .iact_3(read_out_3), .iact_4(read_out_4), .iact_5(read_out_5), .iact_6(read_out_6), .iact_7(read_out_7),
        .w_0(w_dout_0), .w_1(w_dout_1), .w_2(w_dout_2), .w_3(w_dout_3), .w_4(w_dout_4), .w_5(w_dout_5), .w_6(w_dout_6), .w_7(w_dout_7),
        .bias(b_dout_0), // 💡 주의: 현재는 Bank 0의 Bias만 연결. FC 노드에 따라 MUX 선택 로직 필요할 수 있음
        .fc_we(fc_we),
        .fc_din_0(fc_din_0), .fc_din_1(fc_din_1), .fc_din_2(fc_din_2), .fc_din_3(fc_din_3), .fc_din_4(fc_din_4), .fc_din_5(fc_din_5), .fc_din_6(fc_din_6), .fc_din_7(fc_din_7)
    );

    // 💡 [아키텍트 메모]: 
    // PE Array, Input Buffer, Top Input Router, Output BRAM, Post Process(Quant/Pool) 모듈들은
    // 배선이 너무 길어지고 세부 모듈의 정확한 포트 이름 확인이 필요하여 여기에 스케치만 남깁니다.
    // 이 선행 배선 구조가 맞다면, 나머지 PE Array 측 포트들도 완벽하게 끼워 넣을 수 있습니다.

endmodule