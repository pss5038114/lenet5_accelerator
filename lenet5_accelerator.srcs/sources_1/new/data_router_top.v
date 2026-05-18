`timescale 1ns / 1ps

module data_router_top #(
    parameter BW_A = 8
)(
    // 💡 1. 컨트롤러 제어 신호
    input wire ping_pong_state, // 0: UBRAM A 읽기 / B 쓰기, 1: UBRAM B 읽기 / A 쓰기
    input wire [1:0] mode_select, // 0: DMA(최초 로드), 1: CONV 모드, 2: FC 모드

    // ==========================================
    // 📥 [입력] UBRAM 포트 B에서 나오는 데이터 (읽기)
    // ==========================================
    input wire [BW_A-1:0] dout_a_0, dout_a_1, dout_a_2, dout_a_3, dout_a_4, dout_a_5, dout_a_6, dout_a_7,
    input wire [BW_A-1:0] dout_b_0, dout_b_1, dout_b_2, dout_b_3, dout_b_4, dout_b_5, dout_b_6, dout_b_7,

    // ==========================================
    // 📤 [출력] 연산기로 뿌려줄 데이터 (Broadcast)
    // ==========================================
    // Input Buffer (Conv 모드용) 및 FC 모듈이 동시에 이 선을 공유해서 읽어갑니다.
    output wire [BW_A-1:0] read_out_0, read_out_1, read_out_2, read_out_3, 
    output wire [BW_A-1:0] read_out_4, read_out_5, read_out_6, read_out_7,

    // ==========================================
    // 📥 [입력] 연산기/DMA에서 들어오는 데이터 (쓰기)
    // ==========================================
    // 1) DMA (최초 인풋 이미지 로드)
    input wire [7:0] dma_we,
    input wire [BW_A-1:0] dma_din_0, dma_din_1, dma_din_2, dma_din_3, dma_din_4, dma_din_5, dma_din_6, dma_din_7,
    
    // 2) CONV (PE -> 양자화/풀링 완료 데이터)
    input wire [7:0] conv_we,
    input wire [BW_A-1:0] conv_din_0, conv_din_1, conv_din_2, conv_din_3, conv_din_4, conv_din_5, conv_din_6, conv_din_7,

    // 3) FC (FC -> 양자화 완료 데이터)
    input wire [7:0] fc_we,
    input wire [BW_A-1:0] fc_din_0, fc_din_1, fc_din_2, fc_din_3, fc_din_4, fc_din_5, fc_din_6, fc_din_7,

    // ==========================================
    // 📤 [출력] UBRAM 포트 A로 들어갈 데이터 (쓰기)
    // ==========================================
    output wire [7:0] we_a, we_b,
    output wire [BW_A-1:0] din_a_0, din_a_1, din_a_2, din_a_3, din_a_4, din_a_5, din_a_6, din_a_7,
    output wire [BW_A-1:0] din_b_0, din_b_1, din_b_2, din_b_3, din_b_4, din_b_5, din_b_6, din_b_7
);

    // =========================================================
    // 📖 [읽기 경로] 2-to-1 MUX & Broadcast
    // =========================================================
    // ping_pong_state가 0이면 A 출력, 1이면 B 출력
    assign read_out_0 = (ping_pong_state == 1'b0) ? dout_a_0 : dout_b_0;
    assign read_out_1 = (ping_pong_state == 1'b0) ? dout_a_1 : dout_b_1;
    assign read_out_2 = (ping_pong_state == 1'b0) ? dout_a_2 : dout_b_2;
    assign read_out_3 = (ping_pong_state == 1'b0) ? dout_a_3 : dout_b_3;
    assign read_out_4 = (ping_pong_state == 1'b0) ? dout_a_4 : dout_b_4;
    assign read_out_5 = (ping_pong_state == 1'b0) ? dout_a_5 : dout_b_5;
    assign read_out_6 = (ping_pong_state == 1'b0) ? dout_a_6 : dout_b_6;
    assign read_out_7 = (ping_pong_state == 1'b0) ? dout_a_7 : dout_b_7;
    // 💡 이 read_out 선들을 Input Buffer의 rd_data와 FC Module의 iact_in에 동시에 연결하면 됩니다.

    // =========================================================
    // ✍️ [쓰기 경로] 3-to-1 MUX (어떤 데이터를 쓸 것인가?)
    // =========================================================
    wire [7:0] current_we;
    wire [BW_A-1:0] current_din_0, current_din_1, current_din_2, current_din_3;
    wire [BW_A-1:0] current_din_4, current_din_5, current_din_6, current_din_7;

    // 모드에 따라 현재 쓰려는 데이터 소스 선택
    assign current_we = (mode_select == 2'd0) ? dma_we :
                        (mode_select == 2'd1) ? conv_we : fc_we;

    assign current_din_0 = (mode_select == 2'd0) ? dma_din_0 : (mode_select == 2'd1) ? conv_din_0 : fc_din_0;
    assign current_din_1 = (mode_select == 2'd0) ? dma_din_1 : (mode_select == 2'd1) ? conv_din_1 : fc_din_1;
    assign current_din_2 = (mode_select == 2'd0) ? dma_din_2 : (mode_select == 2'd1) ? conv_din_2 : fc_din_2;
    assign current_din_3 = (mode_select == 2'd0) ? dma_din_3 : (mode_select == 2'd1) ? conv_din_3 : fc_din_3;
    assign current_din_4 = (mode_select == 2'd0) ? dma_din_4 : (mode_select == 2'd1) ? conv_din_4 : fc_din_4;
    assign current_din_5 = (mode_select == 2'd0) ? dma_din_5 : (mode_select == 2'd1) ? conv_din_5 : fc_din_5;
    assign current_din_6 = (mode_select == 2'd0) ? dma_din_6 : (mode_select == 2'd1) ? conv_din_6 : fc_din_6;
    assign current_din_7 = (mode_select == 2'd0) ? dma_din_7 : (mode_select == 2'd1) ? conv_din_7 : fc_din_7;

    // =========================================================
    // 🎯 [타겟 설정] Demux 로직 (A에 쓸 것인가, B에 쓸 것인가?)
    // =========================================================
    // 데이터 자체는 A와 B 모두에게 항상 쏴줍니다. (어차피 WE가 0이면 저장 안 됨)
    assign din_a_0 = current_din_0; assign din_b_0 = current_din_0;
    assign din_a_1 = current_din_1; assign din_b_1 = current_din_1;
    assign din_a_2 = current_din_2; assign din_b_2 = current_din_2;
    assign din_a_3 = current_din_3; assign din_b_3 = current_din_3;
    assign din_a_4 = current_din_4; assign din_b_4 = current_din_4;
    assign din_a_5 = current_din_5; assign din_b_5 = current_din_5;
    assign din_a_6 = current_din_6; assign din_b_6 = current_din_6;
    assign din_a_7 = current_din_7; assign din_b_7 = current_din_7;

    // 💡 핵심: Write Enable(we) 신호로 타겟을 결정합니다.
    // 1) DMA 모드(0): 무조건 A에 씁니다.
    // 2) CONV/FC 모드(1, 2): ping_pong_state의 '반대' 쪽에 씁니다.
    assign we_a = (mode_select == 2'd0) ? current_we : 
                  (ping_pong_state == 1'b1) ? current_we : 8'd0; // B가 읽기면 A에 쓰기

    assign we_b = (mode_select == 2'd0) ? 8'd0 :       // DMA는 B에 절대 안 씀
                  (ping_pong_state == 1'b0) ? current_we : 8'd0; // A가 읽기면 B에 쓰기

endmodule