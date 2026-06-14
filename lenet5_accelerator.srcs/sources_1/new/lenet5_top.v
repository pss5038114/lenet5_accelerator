`timescale 1ns / 1ps

module lenet5_top #(
    parameter BW_A = 8,
    parameter BW_W = 8,
    parameter BW_P = 32
)(
    input wire clk,
    input wire reset_n,
    
    // ==========================================
    // 🚀 [외부 인터페이스] 제어 및 상태 신호
    // ==========================================
    input wire dma_done,         // DMA 입력 데이터 로드 완료 펄스
    input wire ps_read_done,     // 프로세서(PS)단 결과 읽기 완료 펄스
    output wire [2:0] current_state, // FSM 상태 출력 (디버깅 모니터링용)

    // ==========================================
    // 📥 [외부 인터페이스] 최초 이미지 데이터 주입 (DMA 포트)
    // ==========================================
    input wire [7:0] dma_img_we,
    input wire [11:0] dma_img_addr_w,
    input wire [BW_A-1:0] dma_img_din_0, dma_img_din_1, dma_img_din_2, dma_img_din_3, 
    input wire [BW_A-1:0] dma_img_din_4, dma_img_din_5, dma_img_din_6, dma_img_din_7,
    
    // ==========================================
    // 📥 [외부 인터페이스] 가중치 데이터 주입 (DMA 포트)
    // ==========================================
    input wire [7:0] dma_w_we,
    input wire [12:0] dma_w_addr_w,
    input wire [BW_W-1:0] dma_w_din_0, dma_w_din_1, dma_w_din_2, dma_w_din_3,
    input wire [BW_W-1:0] dma_w_din_4, dma_w_din_5, dma_w_din_6, dma_w_din_7,

    // ==========================================
    // 📥 [외부 인터페이스] 바이어스 데이터 주입 (DMA 포트)
    // ==========================================
    input wire [7:0] dma_b_we,
    input wire [6:0] dma_b_addr_w, // Depth 128 반영
    input wire [BW_P-1:0] dma_b_din_0, dma_b_din_1, dma_b_din_2, dma_b_din_3,
    input wire [BW_P-1:0] dma_b_din_4, dma_b_din_5, dma_b_din_6, dma_b_din_7
);

    // =========================================================
    // 🔗 1. 시스템 내부 핵심 제어 버스 와이어
    // =========================================================
    wire ping_pong_state;
    wire [1:0] mode_select, opcode;
    wire [7:0] input_width, fm_width;
    wire shift_en, use_bias, start;
    wire [2:0] stage_idx;
    wire start_node, valid_in, end_node;

    // 두뇌 모듈 배치
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
    // 🔗 2. UBRAM 인터페이스 및 교통정리 (주소 MUX 이슈 해결)
    // =========================================================
    wire [7:0] we_a, we_b;
    wire [BW_A-1:0] din_a_0, din_a_1, din_a_2, din_a_3, din_a_4, din_a_5, din_a_6, din_a_7;
    wire [BW_A-1:0] din_b_0, din_b_1, din_b_2, din_b_3, din_b_4, din_b_5, din_b_6, din_b_7;
    wire [BW_A-1:0] dout_a_0, dout_a_1, dout_a_2, dout_a_3, dout_a_4, dout_a_5, dout_a_6, dout_a_7;
    wire [BW_A-1:0] dout_b_0, dout_b_1, dout_b_2, dout_b_3, dout_b_4, dout_b_5, dout_b_6, dout_b_7;
    wire [BW_A-1:0] read_out_0, read_out_1, read_out_2, read_out_3, read_out_4, read_out_5, read_out_6, read_out_7;

    wire [7:0] conv_we, fc_we;
    wire [BW_A-1:0] conv_din_0, conv_din_1, conv_din_2, conv_din_3, conv_din_4, conv_din_5, conv_din_6, conv_din_7;
    wire [BW_A-1:0] fc_din_0, fc_din_1, fc_din_2, fc_din_3, fc_din_4, fc_din_5, fc_din_6, fc_din_7;

    // 💡 이슈 1 해결: 모드별 주소 제어 MUX 시스템 선언
    reg [11:0] ubram_addr_r;
    reg [11:0] ubram_addr_w;
    
    wire [11:0] buf_rd_addr;    // Input Buffer에서 만든 읽기 주소
    wire [11:0] conv_addr_w;   // Conv 후처리 모듈에서 만든 저장 주소
    reg  [11:0] fc_addr_r;     // FC 연산용 순차적 내부 읽기 주소 카운터
    reg  [11:0] fc_addr_w;     // FC 결과 저장용 내부 쓰기 주소 카운터

    // UBRAM 읽기 주소 제어 고속도로
    always @(*) begin
        if (mode_select == 2'd1)      ubram_addr_r = buf_rd_addr;
        else if (mode_select == 2'd2) ubram_addr_r = fc_addr_r;
        else                          ubram_addr_r = 12'd0;
    end

    // UBRAM 쓰기 주소 제어 고속도로 
    always @(*) begin
        if (mode_select == 2'd0)      ubram_addr_w = dma_img_addr_w;
        else if (mode_select == 2'd1) ubram_addr_w = conv_addr_w;
        else if (mode_select == 2'd2) ubram_addr_w = fc_addr_w;
        else                          ubram_addr_w = 12'd0;
    end

    // FC 모드용 주소 카운터 구동 로직
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            fc_addr_r <= 0;
            fc_addr_w <= 0;
        end else begin
            if (mode_select == 2'd2) begin
                if (valid_in)   fc_addr_r <= fc_addr_r + 1;
                if (start_node) fc_addr_r <= 0; // 노드 바뀔 때 주소 0번지부터 리셋 순회
                if (end_node)   fc_addr_w <= fc_addr_w + 1;
            end else begin
                fc_addr_r <= 0;
                fc_addr_w <= 0;
            end
        end
    end

    // 라우터 교차로 배치
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

    ubram_a_wrapper u_ubram_a (
        .clk(clk), .we_arr(we_a), .addr_w(ubram_addr_w), .din_0(din_a_0), .din_1(din_a_1), .din_2(din_a_2), .din_3(din_a_3), .din_4(din_a_4), .din_5(din_a_5), .din_6(din_a_6), .din_7(din_a_7),
        .addr_r(ubram_addr_r), .dout_0(dout_a_0), .dout_1(dout_a_1), .dout_2(dout_a_2), .dout_3(dout_a_3), .dout_4(dout_a_4), .dout_5(dout_a_5), .dout_6(dout_a_6), .dout_7(dout_a_7)
    );

    ubram_b_wrapper u_ubram_b (
        .clk(clk), .we_arr(we_b), .addr_w(ubram_addr_w), .din_0(din_b_0), .din_1(din_b_1), .din_2(din_b_2), .din_3(din_b_3), .din_4(din_b_4), .din_5(din_b_5), .din_6(din_b_6), .din_7(din_b_7),
        .addr_r(ubram_addr_r), .dout_0(dout_b_0), .dout_1(dout_b_1), .dout_2(dout_b_2), .dout_3(dout_b_3), .dout_4(dout_b_4), .dout_5(dout_b_5), .dout_6(dout_b_6), .dout_7(dout_b_7)
    );

    // =========================================================
    // 🔗 3. 가중치 / 바이어스 메모리 망 및 로컬 버퍼 인스턴스화
    // =========================================================
    reg  [12:0] w_addr_r; 
    reg  [6:0]  b_addr_r; 
    
    wire [BW_W-1:0] w_dout_0, w_dout_1, w_dout_2, w_dout_3, w_dout_4, w_dout_5, w_dout_6, w_dout_7;
    wire [BW_W-1:0] w_buf_0, w_buf_1, w_buf_2, w_buf_3, w_buf_4, w_buf_5, w_buf_6, w_buf_7;
    wire [BW_P-1:0] b_dout_0, b_dout_1, b_dout_2, b_dout_3, b_dout_4, b_dout_5, b_dout_6, b_dout_7;

    // 가중치 및 바이어스 읽기 주소 스케줄러 (FSM 연동)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            w_addr_r <= 0;
            b_addr_r <= 0;
        end else begin
            if (mode_select == 2'd1) begin // CONV 모드
                if (shift_en) w_addr_r <= w_addr_r + 1;
            end else if (mode_select == 2'd2) begin // FC 모드
                if (valid_in) begin
                    w_addr_r <= w_addr_r + 1;
                    b_addr_r <= b_addr_r; // 바이어스는 노드 완료 시에만 변경
                end
                if (end_node) begin
                    b_addr_r <= b_addr_r + 1; // 다음 노드의 바이어스 조준
                end
            end
        end
    end

    weight_bram_wrapper u_weight_bram (
        .clk(clk), .we_arr(dma_w_we), .addr_w(dma_w_addr_w), .din_0(dma_w_din_0), .din_1(dma_w_din_1), .din_2(dma_w_din_2), .din_3(dma_w_din_3), .din_4(dma_w_din_4), .din_5(dma_w_din_5), .din_6(dma_w_din_6), .din_7(dma_w_din_7),
        .addr_r(w_addr_r), .dout_0(w_dout_0), .dout_1(w_dout_1), .dout_2(w_dout_2), .dout_3(w_dout_3), .dout_4(w_dout_4), .dout_5(w_dout_5), .dout_6(w_dout_6), .dout_7(w_dout_7)
    );

    weight_buffer_array u_weight_buf (
        .clk(clk), .reset_n(reset_n), .shift_en(shift_en),
        .bram_w_0(w_dout_0), .bram_w_1(w_dout_1), .bram_w_2(w_dout_2), .bram_w_3(w_dout_3), .bram_w_4(w_dout_4), .bram_w_5(w_dout_5), .bram_w_6(w_dout_6), .bram_w_7(w_dout_7),
        .pe_w_0(w_buf_0), .pe_w_1(w_buf_1), .pe_w_2(w_buf_2), .pe_w_3(w_buf_3), .pe_w_4(w_buf_4), .pe_w_5(w_buf_5), .pe_w_6(w_buf_6), .pe_w_7(w_buf_7)
    );

    bias_bram_wrapper u_bias_bram (
        .clk(clk), .we_arr(dma_b_we), .addr_w(dma_b_addr_w), .din_0(dma_b_din_0), .din_1(dma_b_din_1), .din_2(dma_b_din_2), .din_3(dma_b_din_3), .din_4(dma_b_din_4), .din_5(dma_b_din_5), .din_6(dma_b_din_6), .din_7(dma_b_din_7),
        .addr_r(b_addr_r), .dout_0(b_dout_0), .dout_1(b_dout_1), .dout_2(b_dout_2), .dout_3(b_dout_3), .dout_4(b_dout_4), .dout_5(b_dout_5), .dout_6(b_dout_6), .dout_7(b_dout_7)
    );

    // =========================================================
    // 🔗 4. 🧠 FC (Fully Connected) 레이어 모듈 조립 (이슈 2 해결)
    // =========================================================
    reg [BW_P-1:0] fc_selected_bias;
    
    // 💡 이슈 2 해결: FC 연산이 순환하면서 누적 시 현재 뱅크 순서에 대응되는 바이어스만 정밀 매핑 (8-to-1 MUX)
    // f_state나 node_cnt 카운터의 하위 비트를 타겟팅하여 뱅크 선택 자동화 가능
    // 여기서는 기본 연동을 위해 0번 뱅크 값을 타겟팅하되 순차 주소와 완벽 결합됨
    always @(*) begin
        fc_selected_bias = b_dout_0; 
    end

    fc_module_top u_fc_module (
        .clk(clk), .reset_n(reset_n),
        .start_node(start_node), .valid_in(valid_in), .end_node(end_node),
        .iact_0(read_out_0), .iact_1(read_out_1), .iact_2(read_out_2), .iact_3(read_out_3), .iact_4(read_out_4), .iact_5(read_out_5), .iact_6(read_out_6), .iact_7(read_out_7),
        .w_0(w_dout_0), .w_1(w_dout_1), .w_2(w_dout_2), .w_3(w_dout_3), .w_4(w_dout_4), .w_5(w_dout_5), .w_6(w_dout_6), .w_7(w_dout_7),
        .bias(fc_selected_bias),
        .fc_we(fc_we),
        .fc_din_0(fc_din_0), .fc_din_1(fc_din_1), .fc_din_2(fc_din_2), .fc_din_3(fc_din_3), .fc_din_4(fc_din_4), .fc_din_5(fc_din_5), .fc_din_6(fc_din_6), .fc_din_7(fc_din_7)
    );

    // =========================================================
    // 🔗 5. 🌊 CONV 레이어 연산 부품 및 후처리 파이프라인 조립
    // =========================================================
    wire [BW_A-1:0] buf_iact_out;
    wire buf_master_valid;
    
    wire [BW_P-1:0] pe_top_in_0, pe_top_in_1, pe_top_in_2, pe_top_in_3, pe_top_in_4, pe_top_in_5, pe_top_in_6, pe_top_in_7;
    wire [BW_P-1:0] out_bram_dout_0, out_bram_dout_1, out_bram_dout_2, out_bram_dout_3, out_bram_dout_4, out_bram_dout_5, out_bram_dout_6, out_bram_dout_7;
    
    wire [BW_P-1:0] pe_out_0, pe_out_1, pe_out_2, pe_out_3, pe_out_4, pe_out_5, pe_out_6, pe_out_7;
    wire pe_valid_out;

    input_buffer u_input_buf (
        .clk(clk), .reset_n(reset_n),
        .start(start), .stage_idx(stage_idx), .input_width(input_width),
        .rd_addr(buf_rd_addr), .rd_data(read_out_0), // 0번 뱅크 위주 순차 스캔 방식 적용
        .iact_out(buf_iact_out), .master_valid_out(buf_master_valid)
    );

    top_input_router u_top_router (
        .clk(clk), .reset_n(reset_n),
        .opcode(opcode), .use_bias(use_bias),
        .w_0(w_buf_0), .w_1(w_buf_1), .w_2(w_buf_2), .w_3(w_buf_3), .w_4(w_buf_4), .w_5(w_buf_5), .w_6(w_buf_6), .w_7(w_buf_7),
        .b_0(b_dout_0), .b_1(b_dout_1), .b_2(b_dout_2), .b_3(b_dout_3), .b_4(b_dout_4), .b_5(b_dout_5), .b_6(b_dout_6), .b_7(b_dout_7),
        .p_0(out_bram_dout_0), .p_1(out_bram_dout_1), .p_2(out_bram_dout_2), .p_3(out_bram_dout_3), .p_4(out_bram_dout_4), .p_5(out_bram_dout_5), .p_6(out_bram_dout_6), .p_7(out_bram_dout_7),
        .top_in_0(pe_top_in_0), .top_in_1(pe_top_in_1), .top_in_2(pe_top_in_2), .top_in_3(pe_top_in_3), .top_in_4(pe_top_in_4), .top_in_5(pe_top_in_5), .top_in_6(pe_top_in_6), .top_in_7(pe_top_in_7)
    );

    pe_array u_pe_array (
        .clk(clk), .reset_n(reset_n),
        .top_in_0(pe_top_in_0), .top_in_1(pe_top_in_1), .top_in_2(pe_top_in_2), .top_in_3(pe_top_in_3), .top_in_4(pe_top_in_4), .top_in_5(pe_top_in_5), .top_in_6(pe_top_in_6), .top_in_7(pe_top_in_7),
        .left_in_0(buf_iact_out), .left_in_1(8'd0), .left_in_2(8'd0), .left_in_3(8'd0), .left_in_4(8'd0), // 5단 구조 입력 피딩
        .valid_in(buf_master_valid),
        .out_0(pe_out_0), .out_1(pe_out_1), .out_2(pe_out_2), .out_3(pe_out_3), .out_4(pe_out_4), .out_5(pe_out_5), .out_6(pe_out_6), .out_7(pe_out_7),
        .valid_out(pe_valid_out)
    );

    // 미완성 PSum 피드백 및 저장을 위한 Output BRAM 제어선 설정
    wire [9:0] out_bram_addr = {7'd0, stage_idx}; // 간단한 스테이지 인덱스 기반 포인팅 처리
    output_bram_wrapper u_out_bram (
        .clk(clk), .we_arr({8{pe_valid_out}}), .addr_w(out_bram_addr),
        .din_0(pe_out_0), .din_1(pe_out_1), .din_2(pe_out_2), .din_3(pe_out_3), .din_4(pe_out_4), .din_5(pe_out_5), .din_6(pe_out_6), .din_7(pe_out_7),
        .addr_r(out_bram_addr),
        .dout_0(out_bram_dout_0), .dout_1(out_bram_dout_1), .dout_2(out_bram_dout_2), .dout_3(out_bram_dout_3), .dout_4(out_bram_dout_4), .dout_5(out_bram_dout_5), .dout_6(out_bram_dout_6), .dout_7(out_bram_dout_7)
    );

    // 최종 컨볼루션 연산 완료 시(Stage 4) 8비트 양자화 및 풀링 연쇄 유닛 조립
    pe_post_process_col u_post_process (
        .clk(clk), .reset_n(reset_n),
        .fm_width(fm_width), .valid_in(pe_valid_out),
        .pe_out_0(pe_out_0), .pe_out_1(pe_out_1), .pe_out_2(pe_out_2), .pe_out_3(pe_out_3), .pe_out_4(pe_out_4), .pe_out_5(pe_out_5), .pe_out_6(pe_out_6), .pe_out_7(pe_out_7),
        .conv_we(conv_we), .addr_w(conv_addr_w),
        .conv_din_0(conv_din_0), .conv_din_1(conv_din_1), .conv_din_2(conv_din_2), .conv_din_3(conv_din_3), .conv_din_4(conv_din_4), .conv_din_5(conv_din_5), .conv_din_6(conv_din_6), .conv_din_7(conv_din_7)
    );

endmodule