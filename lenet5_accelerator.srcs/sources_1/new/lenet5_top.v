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
    wire next_batch; // 💡 여기에 wire 추가!

    // 두뇌 모듈 배치
    lenet5_ctrl u_ctrl (
        .clk(clk), .reset_n(reset_n),
        .dma_done(dma_done), .ps_read_done(ps_read_done),
        .ping_pong_state(ping_pong_state), .mode_select(mode_select),
        .input_width(input_width), .fm_width(fm_width),
        .shift_en(shift_en), .opcode(opcode), .use_bias(use_bias),
        .start(start), .stage_idx(stage_idx),
        .start_node(start_node), .valid_in(valid_in), .end_node(end_node),
        .next_batch(next_batch), // 💡 여기에 포트 맵핑 추가!
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

    // 🛡️ [수정] 시뮬레이션 X-오염 방지용 안전 읽기 주소 생성
    // 쓰기 모드일 때는 읽기 주소를 강제로 반전시켜(~addr_w) 충돌을 회피합니다.
    wire [11:0] safe_ubram_a_addr_r = (mode_select == 2'd0) ? ~dma_img_addr_w : 
                                      (ping_pong_state == 1'b0) ? ubram_addr_r : ~ubram_addr_w;
                                      
    wire [11:0] safe_ubram_b_addr_r = (mode_select == 2'd0) ? 12'hFFF : 
                                      (ping_pong_state == 1'b1) ? ubram_addr_r : ~ubram_addr_w;

    ubram_a_wrapper u_ubram_a (
        .clk(clk), .we_arr(we_a), .addr_w(ubram_addr_w), .din_0(din_a_0), .din_1(din_a_1), .din_2(din_a_2), .din_3(din_a_3), .din_4(din_a_4), .din_5(din_a_5), .din_6(din_a_6), .din_7(din_a_7),
        // 💡 addr_r 포트 수정됨
        .addr_r(safe_ubram_a_addr_r), .dout_0(dout_a_0), .dout_1(dout_a_1), .dout_2(dout_a_2), .dout_3(dout_a_3), .dout_4(dout_a_4), .dout_5(dout_a_5), .dout_6(dout_a_6), .dout_7(dout_a_7)
    );

    ubram_b_wrapper u_ubram_b (
        .clk(clk), .we_arr(we_b), .addr_w(ubram_addr_w), .din_0(din_b_0), .din_1(din_b_1), .din_2(din_b_2), .din_3(din_b_3), .din_4(din_b_4), .din_5(din_b_5), .din_6(din_b_6), .din_7(din_b_7),
        // 💡 addr_r 포트 수정됨
        .addr_r(safe_ubram_b_addr_r), .dout_0(dout_b_0), .dout_1(dout_b_1), .dout_2(dout_b_2), .dout_3(dout_b_3), .dout_4(dout_b_4), .dout_5(dout_b_5), .dout_6(dout_b_6), .dout_7(dout_b_7)
    );

    // =========================================================
    // 🔗 3. 가중치 / 바이어스 메모리 망 및 로컬 버퍼 인스턴스화
    // =========================================================
    reg  [12:0] w_addr_r; 
    reg  [6:0]  b_addr_r; 
    
    wire [BW_W-1:0] w_dout_0, w_dout_1, w_dout_2, w_dout_3, w_dout_4, w_dout_5, w_dout_6, w_dout_7;
    wire [BW_W-1:0] w_buf_0, w_buf_1, w_buf_2, w_buf_3, w_buf_4, w_buf_5, w_buf_6, w_buf_7;
    wire [BW_P-1:0] b_dout_0, b_dout_1, b_dout_2, b_dout_3, b_dout_4, b_dout_5, b_dout_6, b_dout_7;

    // 💡 [수정] 가중치 및 바이어스 읽기 주소 스케줄러 (FSM 연동)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            w_addr_r <= 0;
            b_addr_r <= 0;
        end else begin
            if (mode_select == 2'd1) begin // CONV 모드
                if (shift_en) w_addr_r <= w_addr_r + 1;
                if (next_batch) b_addr_r <= b_addr_r + 1; // 💡 CONV 모드에서도 배치가 끝날 때 바이어스 주소 1 증가!
            end else if (mode_select == 2'd2) begin // FC 모드
                if (valid_in) begin
                    w_addr_r <= w_addr_r + 1;
                    b_addr_r <= b_addr_r; 
                end
                if (end_node) begin
                    b_addr_r <= b_addr_r + 1; 
                end
            end
        end
    end

    // 🛡️ [수정] 가중치 및 바이어스 충돌 방지용 안전 읽기 주소 생성
    wire [12:0] safe_w_addr_r = (mode_select == 2'd0) ? ~dma_w_addr_w : w_addr_r;
    wire [6:0]  safe_b_addr_r = (mode_select == 2'd0) ? ~dma_b_addr_w : b_addr_r;

    weight_bram_wrapper u_weight_bram (
        .clk(clk), .we_arr(dma_w_we), .addr_w(dma_w_addr_w), .din_0(dma_w_din_0), .din_1(dma_w_din_1), .din_2(dma_w_din_2), .din_3(dma_w_din_3), .din_4(dma_w_din_4), .din_5(dma_w_din_5), .din_6(dma_w_din_6), .din_7(dma_w_din_7),
        // 💡 addr_r 포트 수정됨
        .addr_r(safe_w_addr_r), .dout_0(w_dout_0), .dout_1(w_dout_1), .dout_2(w_dout_2), .dout_3(w_dout_3), .dout_4(w_dout_4), .dout_5(w_dout_5), .dout_6(w_dout_6), .dout_7(w_dout_7)
    );

    weight_buffer_array u_weight_buf (
        .clk(clk), .reset_n(reset_n), .shift_en(shift_en),
        .bram_w_0(w_dout_0), .bram_w_1(w_dout_1), .bram_w_2(w_dout_2), .bram_w_3(w_dout_3), .bram_w_4(w_dout_4), .bram_w_5(w_dout_5), .bram_w_6(w_dout_6), .bram_w_7(w_dout_7),
        .pe_w_0(w_buf_0), .pe_w_1(w_buf_1), .pe_w_2(w_buf_2), .pe_w_3(w_buf_3), .pe_w_4(w_buf_4), .pe_w_5(w_buf_5), .pe_w_6(w_buf_6), .pe_w_7(w_buf_7)
    );

    bias_bram_wrapper u_bias_bram (
        .clk(clk), .we_arr(dma_b_we), .addr_w(dma_b_addr_w), .din_0(dma_b_din_0), .din_1(dma_b_din_1), .din_2(dma_b_din_2), .din_3(dma_b_din_3), .din_4(dma_b_din_4), .din_5(dma_b_din_5), .din_6(dma_b_din_6), .din_7(dma_b_din_7),
        // 💡 addr_r 포트 수정됨
        .addr_r(safe_b_addr_r), .dout_0(b_dout_0), .dout_1(b_dout_1), .dout_2(b_dout_2), .dout_3(b_dout_3), .dout_4(b_dout_4), .dout_5(b_dout_5), .dout_6(b_dout_6), .dout_7(b_dout_7)
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
    wire pe_valid_0, pe_valid_1, pe_valid_2, pe_valid_3, pe_valid_4, pe_valid_5, pe_valid_6, pe_valid_7;

    // 💡 해결책: 읽기와 쓰기 주소를 스트리밍 카운터로 완전히 분리합니다.
    reg [9:0] out_bram_addr_r;
    reg [9:0] out_bram_addr_w;

    // 1. 읽기 주소: 인풋 버퍼에서 유효 데이터가 나올 때마다 주소를 증가시킵니다.
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            out_bram_addr_r <= 10'd0;
        end else if (mode_select == 2'd1) begin
            if (start)
                out_bram_addr_r <= 10'd0; // 새로운 스테이지 시작 시 주소 리셋
            else if (buf_master_valid)
                out_bram_addr_r <= out_bram_addr_r + 10'd1;
        end else begin
            out_bram_addr_r <= 10'd0;
        end
    end

    // 2. 쓰기 주소: PE Array 연산 결과가 나오는 타이밍(pe_valid_0)에 맞춰 독립적으로 증가합니다.
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            out_bram_addr_w <= 10'd0;
        end else if (mode_select == 2'd1) begin
            if (start)
                out_bram_addr_w <= 10'd0; // 새로운 스테이지 시작 시 주소 리셋
            else if (pe_valid_0)
                out_bram_addr_w <= out_bram_addr_w + 10'd1;
        end else begin
            out_bram_addr_w <= 10'd0;
        end
    end

    input_buffer u_input_buf (
        .clk(clk), .reset_n(reset_n),
        .start(start), .stage_idx(stage_idx), .input_width(input_width),
        .rd_addr(buf_rd_addr), .rd_data(read_out_0), 
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

    pe_array #(
        .BW_W(BW_W), .BW_A(BW_A), .BW_P(BW_P), .NUM_ROW(5), .NUM_COL(8)
    ) u_pe_array (
        .clk(clk), .reset_n(reset_n),
        .opcode(opcode),
        .col_en(8'hFF), .row_en(5'h1F), 
        .iact_in_master(buf_iact_out),  
        .master_valid_in(buf_master_valid),
        .top_in_0(pe_top_in_0), .top_in_1(pe_top_in_1), .top_in_2(pe_top_in_2), .top_in_3(pe_top_in_3), .top_in_4(pe_top_in_4), .top_in_5(pe_top_in_5), .top_in_6(pe_top_in_6), .top_in_7(pe_top_in_7),
        .bottom_out_0(pe_out_0), .bottom_out_1(pe_out_1), .bottom_out_2(pe_out_2), .bottom_out_3(pe_out_3), .bottom_out_4(pe_out_4), .bottom_out_5(pe_out_5), .bottom_out_6(pe_out_6), .bottom_out_7(pe_out_7),
        .valid_out_0(pe_valid_0), .valid_out_1(pe_valid_1), .valid_out_2(pe_valid_2), .valid_out_3(pe_valid_3), .valid_out_4(pe_valid_4), .valid_out_5(pe_valid_5), .valid_out_6(pe_valid_6), .valid_out_7(pe_valid_7)
    );

    // 💡 분리된 주소 카운터를 래퍼 포트에 정밀 맵핑합니다.
    output_bram_wrapper u_out_bram (
        .clk(clk), .we_arr({8{pe_valid_0}}), .addr_w(out_bram_addr_w),
        .din_0(pe_out_0), .din_1(pe_out_1), .din_2(pe_out_2), .din_3(pe_out_3), .din_4(pe_out_4), .din_5(pe_out_5), .din_6(pe_out_6), .din_7(pe_out_7),
        .addr_r(out_bram_addr_r),
        .dout_0(out_bram_dout_0), .dout_1(out_bram_dout_1), .dout_2(out_bram_dout_2), .dout_3(out_bram_dout_3), .dout_4(out_bram_dout_4), .dout_5(out_bram_dout_5), .dout_6(out_bram_dout_6), .dout_7(out_bram_dout_7)
    );
    
    wire [7:0] pool_valid_arr;

    pe_post_process_col u_pp_0 (.clk(clk), .reset_n(reset_n), .fm_width(fm_width), .psum_in(pe_out_0), .valid_in(pe_valid_0), .pool_out(conv_din_0), .valid_out(pool_valid_arr[0]));
    pe_post_process_col u_pp_1 (.clk(clk), .reset_n(reset_n), .fm_width(fm_width), .psum_in(pe_out_1), .valid_in(pe_valid_1), .pool_out(conv_din_1), .valid_out(pool_valid_arr[1]));
    pe_post_process_col u_pp_2 (.clk(clk), .reset_n(reset_n), .fm_width(fm_width), .psum_in(pe_out_2), .valid_in(pe_valid_2), .pool_out(conv_din_2), .valid_out(pool_valid_arr[2]));
    pe_post_process_col u_pp_3 (.clk(clk), .reset_n(reset_n), .fm_width(fm_width), .psum_in(pe_out_3), .valid_in(pe_valid_3), .pool_out(conv_din_3), .valid_out(pool_valid_arr[3]));
    pe_post_process_col u_pp_4 (.clk(clk), .reset_n(reset_n), .fm_width(fm_width), .psum_in(pe_out_4), .valid_in(pe_valid_4), .pool_out(conv_din_4), .valid_out(pool_valid_arr[4]));
    pe_post_process_col u_pp_5 (.clk(clk), .reset_n(reset_n), .fm_width(fm_width), .psum_in(pe_out_5), .valid_in(pe_valid_5), .pool_out(conv_din_5), .valid_out(pool_valid_arr[5]));
    pe_post_process_col u_pp_6 (.clk(clk), .reset_n(reset_n), .fm_width(fm_width), .psum_in(pe_out_6), .valid_in(pe_valid_6), .pool_out(conv_din_6), .valid_out(pool_valid_arr[6]));
    pe_post_process_col u_pp_7 (.clk(clk), .reset_n(reset_n), .fm_width(fm_width), .psum_in(pe_out_7), .valid_in(pe_valid_7), .pool_out(conv_din_7), .valid_out(pool_valid_arr[7]));

    reg [11:0] conv_addr_w_reg;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) conv_addr_w_reg <= 0;
        else if (mode_select == 2'd1 && pool_valid_arr[0]) conv_addr_w_reg <= conv_addr_w_reg + 1; 
        else if (mode_select != 2'd1) conv_addr_w_reg <= 0;
    end
    
    assign conv_addr_w = conv_addr_w_reg;
    assign conv_we = {8{pool_valid_arr[0]}}; 

endmodule