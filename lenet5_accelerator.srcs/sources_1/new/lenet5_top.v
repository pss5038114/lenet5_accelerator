`timescale 1ns / 1ps

module lenet5_top #(
    parameter BW_A = 8,
    parameter BW_W = 8,
    parameter BW_P = 32
)(
    input wire clk,
    input wire reset_n,
    
    // ==========================================
    // 외부 제어 및 상태
    // ==========================================
    input wire dma_done,
    input wire ps_read_done,
    output wire [2:0] current_state,

    // ==========================================
    // Image DMA
    // ==========================================
    input wire [7:0] dma_img_we,
    input wire [11:0] dma_img_addr_w,
    input wire [BW_A-1:0] dma_img_din_0, dma_img_din_1, dma_img_din_2, dma_img_din_3, 
    input wire [BW_A-1:0] dma_img_din_4, dma_img_din_5, dma_img_din_6, dma_img_din_7,
    
    // ==========================================
    // Weight DMA
    // ==========================================
    input wire [7:0] dma_w_we,
    input wire [12:0] dma_w_addr_w,
    input wire [BW_W-1:0] dma_w_din_0, dma_w_din_1, dma_w_din_2, dma_w_din_3,
    input wire [BW_W-1:0] dma_w_din_4, dma_w_din_5, dma_w_din_6, dma_w_din_7,

    // ==========================================
    // Bias DMA
    // 중요: bias.txt는 217 address/bank이므로 8-bit address 필요
    // ==========================================
    input wire [7:0] dma_b_we,
    input wire [7:0] dma_b_addr_w,
    input wire [BW_P-1:0] dma_b_din_0, dma_b_din_1, dma_b_din_2, dma_b_din_3,
    input wire [BW_P-1:0] dma_b_din_4, dma_b_din_5, dma_b_din_6, dma_b_din_7
);

    // =========================================================
    // 1. Controller wires
    // =========================================================
    wire ping_pong_state;
    wire [1:0] mode_select;
    wire [1:0] opcode;
    wire [7:0] input_width;
    wire [7:0] fm_width;

    wire shift_en;
    wire use_bias;
    wire start;
    wire [2:0] stage_idx;

    wire start_node;
    wire valid_in;
    wire end_node;
    wire next_batch;

    // 추가된 Conv 디버깅/제어 신호
    wire [2:0] conv_ch_idx;
    wire conv_final_pass;

    lenet5_ctrl u_ctrl (
        .clk(clk),
        .reset_n(reset_n),

        .dma_done(dma_done),
        .ps_read_done(ps_read_done),

        .ping_pong_state(ping_pong_state),
        .mode_select(mode_select),
        .input_width(input_width),
        .fm_width(fm_width),

        .shift_en(shift_en),
        .opcode(opcode),
        .use_bias(use_bias),
        .start(start),
        .stage_idx(stage_idx),

        .start_node(start_node),
        .valid_in(valid_in),
        .end_node(end_node),

        .next_batch(next_batch),

        // 여기서 새 포트 연결
        .conv_ch_idx(conv_ch_idx),
        .conv_final_pass(conv_final_pass),

        .current_state(current_state)
    );

    // =========================================================
    // 2. UBRAM interface
    // =========================================================
    wire [7:0] we_a;
    wire [7:0] we_b;

    wire [BW_A-1:0] din_a_0, din_a_1, din_a_2, din_a_3;
    wire [BW_A-1:0] din_a_4, din_a_5, din_a_6, din_a_7;

    wire [BW_A-1:0] din_b_0, din_b_1, din_b_2, din_b_3;
    wire [BW_A-1:0] din_b_4, din_b_5, din_b_6, din_b_7;

    wire [BW_A-1:0] dout_a_0, dout_a_1, dout_a_2, dout_a_3;
    wire [BW_A-1:0] dout_a_4, dout_a_5, dout_a_6, dout_a_7;

    wire [BW_A-1:0] dout_b_0, dout_b_1, dout_b_2, dout_b_3;
    wire [BW_A-1:0] dout_b_4, dout_b_5, dout_b_6, dout_b_7;

    wire [BW_A-1:0] read_out_0, read_out_1, read_out_2, read_out_3;
    wire [BW_A-1:0] read_out_4, read_out_5, read_out_6, read_out_7;

    wire [7:0] conv_we;
    wire [7:0] fc_we;

    wire [BW_A-1:0] conv_din_0, conv_din_1, conv_din_2, conv_din_3;
    wire [BW_A-1:0] conv_din_4, conv_din_5, conv_din_6, conv_din_7;

    wire [BW_A-1:0] fc_din_0, fc_din_1, fc_din_2, fc_din_3;
    wire [BW_A-1:0] fc_din_4, fc_din_5, fc_din_6, fc_din_7;

    reg [11:0] ubram_addr_r;
    reg [11:0] ubram_addr_w;

    wire [11:0] buf_rd_addr;
    wire [11:0] conv_addr_w;

    reg [11:0] fc_addr_r;
    reg [11:0] fc_addr_w;
    reg [2:0]  fc_write_phase;

    wire fc_write_fire = (mode_select == 2'd2) && (fc_we != 8'd0);

    // UBRAM read address mux
    always @(*) begin
        if (mode_select == 2'd1)
            ubram_addr_r = buf_rd_addr;
        else if (mode_select == 2'd2)
            ubram_addr_r = fc_addr_r;
        else
            ubram_addr_r = 12'd0;
    end

    // UBRAM write address mux
    always @(*) begin
        if (mode_select == 2'd0)
            ubram_addr_w = dma_img_addr_w;
        else if (mode_select == 2'd1)
            ubram_addr_w = conv_addr_w;
        else if (mode_select == 2'd2)
            ubram_addr_w = fc_addr_w;
        else
            ubram_addr_w = 12'd0;
    end

    // FC address control
    // FC 입력은 각 노드마다 addr 0부터 다시 읽음
    // FC 출력은 8-bank를 다 채운 뒤 addr 증가
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            fc_addr_r      <= 12'd0;
            fc_addr_w      <= 12'd0;
            fc_write_phase <= 3'd0;
        end else begin
            if (mode_select == 2'd2) begin
                if (start_node)
                    fc_addr_r <= 12'd0;
                else if (valid_in)
                    fc_addr_r <= fc_addr_r + 12'd1;

                if (fc_write_fire) begin
                    if (fc_write_phase == 3'd7) begin
                        fc_write_phase <= 3'd0;
                        fc_addr_w      <= fc_addr_w + 12'd1;
                    end else begin
                        fc_write_phase <= fc_write_phase + 3'd1;
                    end
                end
            end else begin
                fc_addr_r      <= 12'd0;
                fc_addr_w      <= 12'd0;
                fc_write_phase <= 3'd0;
            end
        end
    end

    data_router_top u_router (
        .ping_pong_state(ping_pong_state),
        .mode_select(mode_select),

        .dout_a_0(dout_a_0), .dout_a_1(dout_a_1), .dout_a_2(dout_a_2), .dout_a_3(dout_a_3),
        .dout_a_4(dout_a_4), .dout_a_5(dout_a_5), .dout_a_6(dout_a_6), .dout_a_7(dout_a_7),

        .dout_b_0(dout_b_0), .dout_b_1(dout_b_1), .dout_b_2(dout_b_2), .dout_b_3(dout_b_3),
        .dout_b_4(dout_b_4), .dout_b_5(dout_b_5), .dout_b_6(dout_b_6), .dout_b_7(dout_b_7),

        .read_out_0(read_out_0), .read_out_1(read_out_1), .read_out_2(read_out_2), .read_out_3(read_out_3),
        .read_out_4(read_out_4), .read_out_5(read_out_5), .read_out_6(read_out_6), .read_out_7(read_out_7),

        .dma_we(dma_img_we),
        .dma_din_0(dma_img_din_0), .dma_din_1(dma_img_din_1), .dma_din_2(dma_img_din_2), .dma_din_3(dma_img_din_3),
        .dma_din_4(dma_img_din_4), .dma_din_5(dma_img_din_5), .dma_din_6(dma_img_din_6), .dma_din_7(dma_img_din_7),

        .conv_we(conv_we),
        .conv_din_0(conv_din_0), .conv_din_1(conv_din_1), .conv_din_2(conv_din_2), .conv_din_3(conv_din_3),
        .conv_din_4(conv_din_4), .conv_din_5(conv_din_5), .conv_din_6(conv_din_6), .conv_din_7(conv_din_7),

        .fc_we(fc_we),
        .fc_din_0(fc_din_0), .fc_din_1(fc_din_1), .fc_din_2(fc_din_2), .fc_din_3(fc_din_3),
        .fc_din_4(fc_din_4), .fc_din_5(fc_din_5), .fc_din_6(fc_din_6), .fc_din_7(fc_din_7),

        .we_a(we_a),
        .we_b(we_b),

        .din_a_0(din_a_0), .din_a_1(din_a_1), .din_a_2(din_a_2), .din_a_3(din_a_3),
        .din_a_4(din_a_4), .din_a_5(din_a_5), .din_a_6(din_a_6), .din_a_7(din_a_7),

        .din_b_0(din_b_0), .din_b_1(din_b_1), .din_b_2(din_b_2), .din_b_3(din_b_3),
        .din_b_4(din_b_4), .din_b_5(din_b_5), .din_b_6(din_b_6), .din_b_7(din_b_7)
    );

    // Read/write collision avoidance
    wire [11:0] safe_ubram_a_addr_r =
        (mode_select == 2'd0) ? ~dma_img_addr_w :
        (ping_pong_state == 1'b0) ? ubram_addr_r : ~ubram_addr_w;

    wire [11:0] safe_ubram_b_addr_r =
        (mode_select == 2'd0) ? 12'hFFF :
        (ping_pong_state == 1'b1) ? ubram_addr_r : ~ubram_addr_w;

    ubram_a_wrapper u_ubram_a (
        .clk(clk),
        .we_arr(we_a),
        .addr_w(ubram_addr_w),
        .din_0(din_a_0), .din_1(din_a_1), .din_2(din_a_2), .din_3(din_a_3),
        .din_4(din_a_4), .din_5(din_a_5), .din_6(din_a_6), .din_7(din_a_7),
        .addr_r(safe_ubram_a_addr_r),
        .dout_0(dout_a_0), .dout_1(dout_a_1), .dout_2(dout_a_2), .dout_3(dout_a_3),
        .dout_4(dout_a_4), .dout_5(dout_a_5), .dout_6(dout_a_6), .dout_7(dout_a_7)
    );

    ubram_b_wrapper u_ubram_b (
        .clk(clk),
        .we_arr(we_b),
        .addr_w(ubram_addr_w),
        .din_0(din_b_0), .din_1(din_b_1), .din_2(din_b_2), .din_3(din_b_3),
        .din_4(din_b_4), .din_5(din_b_5), .din_6(din_b_6), .din_7(din_b_7),
        .addr_r(safe_ubram_b_addr_r),
        .dout_0(dout_b_0), .dout_1(dout_b_1), .dout_2(dout_b_2), .dout_3(dout_b_3),
        .dout_4(dout_b_4), .dout_5(dout_b_5), .dout_6(dout_b_6), .dout_7(dout_b_7)
    );

    // =========================================================
    // 3. Weight / Bias BRAM
    // =========================================================
    reg [12:0] w_addr_r;
    reg [7:0]  b_addr_r;

    wire [BW_W-1:0] w_dout_0, w_dout_1, w_dout_2, w_dout_3;
    wire [BW_W-1:0] w_dout_4, w_dout_5, w_dout_6, w_dout_7;

    wire [BW_W-1:0] w_buf_0, w_buf_1, w_buf_2, w_buf_3;
    wire [BW_W-1:0] w_buf_4, w_buf_5, w_buf_6, w_buf_7;

    wire [BW_P-1:0] b_dout_0, b_dout_1, b_dout_2, b_dout_3;
    wire [BW_P-1:0] b_dout_4, b_dout_5, b_dout_6, b_dout_7;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            w_addr_r <= 13'd0;
            b_addr_r <= 8'd0;
        end else begin
            if (mode_select == 2'd1) begin
                if (shift_en)
                    w_addr_r <= w_addr_r + 13'd1;

                if (next_batch)
                    b_addr_r <= b_addr_r + 8'd1;
            end else if (mode_select == 2'd2) begin
                if (valid_in)
                    w_addr_r <= w_addr_r + 13'd1;

                if (end_node)
                    b_addr_r <= b_addr_r + 8'd1;
            end
        end
    end

    wire [12:0] safe_w_addr_r =
        (mode_select == 2'd0) ? ~dma_w_addr_w : w_addr_r;

    wire [7:0] safe_b_addr_r =
        (mode_select == 2'd0) ? ~dma_b_addr_w : b_addr_r;

    weight_bram_wrapper u_weight_bram (
        .clk(clk),
        .we_arr(dma_w_we),
        .addr_w(dma_w_addr_w),
        .din_0(dma_w_din_0), .din_1(dma_w_din_1), .din_2(dma_w_din_2), .din_3(dma_w_din_3),
        .din_4(dma_w_din_4), .din_5(dma_w_din_5), .din_6(dma_w_din_6), .din_7(dma_w_din_7),
        .addr_r(safe_w_addr_r),
        .dout_0(w_dout_0), .dout_1(w_dout_1), .dout_2(w_dout_2), .dout_3(w_dout_3),
        .dout_4(w_dout_4), .dout_5(w_dout_5), .dout_6(w_dout_6), .dout_7(w_dout_7)
    );

    weight_buffer_array u_weight_buf (
        .clk(clk),
        .reset_n(reset_n),
        .shift_en(shift_en),
        .bram_w_0(w_dout_0), .bram_w_1(w_dout_1), .bram_w_2(w_dout_2), .bram_w_3(w_dout_3),
        .bram_w_4(w_dout_4), .bram_w_5(w_dout_5), .bram_w_6(w_dout_6), .bram_w_7(w_dout_7),
        .pe_w_0(w_buf_0), .pe_w_1(w_buf_1), .pe_w_2(w_buf_2), .pe_w_3(w_buf_3),
        .pe_w_4(w_buf_4), .pe_w_5(w_buf_5), .pe_w_6(w_buf_6), .pe_w_7(w_buf_7)
    );

    bias_bram_wrapper u_bias_bram (
        .clk(clk),
        .we_arr(dma_b_we),
        .addr_w(dma_b_addr_w),
        .din_0(dma_b_din_0), .din_1(dma_b_din_1), .din_2(dma_b_din_2), .din_3(dma_b_din_3),
        .din_4(dma_b_din_4), .din_5(dma_b_din_5), .din_6(dma_b_din_6), .din_7(dma_b_din_7),
        .addr_r(safe_b_addr_r),
        .dout_0(b_dout_0), .dout_1(b_dout_1), .dout_2(b_dout_2), .dout_3(b_dout_3),
        .dout_4(b_dout_4), .dout_5(b_dout_5), .dout_6(b_dout_6), .dout_7(b_dout_7)
    );

    // =========================================================
    // 4. FC module
    // =========================================================
    reg [BW_P-1:0] fc_selected_bias;

    always @(*) begin
        fc_selected_bias = b_dout_0;
    end

    fc_module_top u_fc_module (
        .clk(clk),
        .reset_n(reset_n),
    
        .start_node(start_node),
        .valid_in(valid_in),
        .end_node(end_node),
    
        // FC1, FC2에서는 ReLU 적용
        // FC3(current_state == 3'd5)에서는 ReLU 미적용
        .relu_en(current_state != 3'd5),
    
        .iact_0(read_out_0), .iact_1(read_out_1), .iact_2(read_out_2), .iact_3(read_out_3),
        .iact_4(read_out_4), .iact_5(read_out_5), .iact_6(read_out_6), .iact_7(read_out_7),
    
        .w_0(w_dout_0), .w_1(w_dout_1), .w_2(w_dout_2), .w_3(w_dout_3),
        .w_4(w_dout_4), .w_5(w_dout_5), .w_6(w_dout_6), .w_7(w_dout_7),
    
        .bias(fc_selected_bias),
    
        .fc_we(fc_we),
    
        .fc_din_0(fc_din_0), .fc_din_1(fc_din_1), .fc_din_2(fc_din_2), .fc_din_3(fc_din_3),
        .fc_din_4(fc_din_4), .fc_din_5(fc_din_5), .fc_din_6(fc_din_6), .fc_din_7(fc_din_7)
    );

    // =========================================================
    // 5. CONV path
    // =========================================================
    wire [BW_A-1:0] buf_iact_out;
    wire buf_master_valid;

    wire [BW_P-1:0] pe_top_in_0, pe_top_in_1, pe_top_in_2, pe_top_in_3;
    wire [BW_P-1:0] pe_top_in_4, pe_top_in_5, pe_top_in_6, pe_top_in_7;

    wire [BW_P-1:0] out_bram_dout_0, out_bram_dout_1, out_bram_dout_2, out_bram_dout_3;
    wire [BW_P-1:0] out_bram_dout_4, out_bram_dout_5, out_bram_dout_6, out_bram_dout_7;

    wire [BW_P-1:0] pe_out_0, pe_out_1, pe_out_2, pe_out_3;
    wire [BW_P-1:0] pe_out_4, pe_out_5, pe_out_6, pe_out_7;

    wire pe_valid_0, pe_valid_1, pe_valid_2, pe_valid_3;
    wire pe_valid_4, pe_valid_5, pe_valid_6, pe_valid_7;

    reg [9:0] out_bram_addr_r;
    reg [9:0] out_bram_addr_w;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            out_bram_addr_r <= 10'd0;
        end else if (mode_select == 2'd1) begin
            if (start)
                out_bram_addr_r <= 10'd0;
            else if (buf_master_valid)
                out_bram_addr_r <= out_bram_addr_r + 10'd1;
        end else begin
            out_bram_addr_r <= 10'd0;
        end
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            out_bram_addr_w <= 10'd0;
        end else if (mode_select == 2'd1) begin
            if (start)
                out_bram_addr_w <= 10'd0;
            else if (pe_valid_0)
                out_bram_addr_w <= out_bram_addr_w + 10'd1;
        end else begin
            out_bram_addr_w <= 10'd0;
        end
    end

    // Conv2 input channel bank mux
    // CONV1: image는 bank0만 사용
    // CONV2: Conv1 output feature maps가 bank0~5에 있으므로 ch_cnt에 따라 선택
    wire [BW_A-1:0] conv_rd_data;

    assign conv_rd_data =
        (current_state == 3'd2) ?
            ((conv_ch_idx == 3'd0) ? read_out_0 :
             (conv_ch_idx == 3'd1) ? read_out_1 :
             (conv_ch_idx == 3'd2) ? read_out_2 :
             (conv_ch_idx == 3'd3) ? read_out_3 :
             (conv_ch_idx == 3'd4) ? read_out_4 :
             (conv_ch_idx == 3'd5) ? read_out_5 :
                                      8'd0) :
            read_out_0;

    input_buffer u_input_buf (
        .clk(clk),
        .reset_n(reset_n),
        .start(start),
        .stage_idx(stage_idx),
        .input_width(input_width),
        .rd_addr(buf_rd_addr),
        .rd_data(conv_rd_data),
        .iact_out(buf_iact_out),
        .master_valid_out(buf_master_valid)
    );

    top_input_router u_top_router (
        .opcode(opcode),
        .use_bias(use_bias),
    
        // 중요:
        // weight_buffer_array를 우회하고 BRAM 출력 w_dout을 바로 사용
        .w_0(w_dout_0), .w_1(w_dout_1), .w_2(w_dout_2), .w_3(w_dout_3),
        .w_4(w_dout_4), .w_5(w_dout_5), .w_6(w_dout_6), .w_7(w_dout_7),
    
        .b_0(b_dout_0), .b_1(b_dout_1), .b_2(b_dout_2), .b_3(b_dout_3),
        .b_4(b_dout_4), .b_5(b_dout_5), .b_6(b_dout_6), .b_7(b_dout_7),
    
        .p_0(out_bram_dout_0), .p_1(out_bram_dout_1), .p_2(out_bram_dout_2), .p_3(out_bram_dout_3),
        .p_4(out_bram_dout_4), .p_5(out_bram_dout_5), .p_6(out_bram_dout_6), .p_7(out_bram_dout_7),
    
        .top_in_0(pe_top_in_0), .top_in_1(pe_top_in_1), .top_in_2(pe_top_in_2), .top_in_3(pe_top_in_3),
        .top_in_4(pe_top_in_4), .top_in_5(pe_top_in_5), .top_in_6(pe_top_in_6), .top_in_7(pe_top_in_7)
    );

    pe_array #(
        .BW_W(BW_W),
        .BW_A(BW_A),
        .BW_P(BW_P),
        .NUM_ROW(5),
        .NUM_COL(8)
    ) u_pe_array (
        .clk(clk),
        .reset_n(reset_n),
        .opcode(opcode),

        .col_en(8'hFF),
        .row_en(5'h1F),

        .iact_in_master(buf_iact_out),
        .master_valid_in(buf_master_valid),

        .top_in_0(pe_top_in_0), .top_in_1(pe_top_in_1), .top_in_2(pe_top_in_2), .top_in_3(pe_top_in_3),
        .top_in_4(pe_top_in_4), .top_in_5(pe_top_in_5), .top_in_6(pe_top_in_6), .top_in_7(pe_top_in_7),

        .bottom_out_0(pe_out_0), .bottom_out_1(pe_out_1), .bottom_out_2(pe_out_2), .bottom_out_3(pe_out_3),
        .bottom_out_4(pe_out_4), .bottom_out_5(pe_out_5), .bottom_out_6(pe_out_6), .bottom_out_7(pe_out_7),

        .valid_out_0(pe_valid_0), .valid_out_1(pe_valid_1), .valid_out_2(pe_valid_2), .valid_out_3(pe_valid_3),
        .valid_out_4(pe_valid_4), .valid_out_5(pe_valid_5), .valid_out_6(pe_valid_6), .valid_out_7(pe_valid_7)
    );

    output_bram_wrapper u_out_bram (
        .clk(clk),
        .we_arr({8{pe_valid_0}}),
        .addr_w(out_bram_addr_w),

        .din_0(pe_out_0), .din_1(pe_out_1), .din_2(pe_out_2), .din_3(pe_out_3),
        .din_4(pe_out_4), .din_5(pe_out_5), .din_6(pe_out_6), .din_7(pe_out_7),

        .addr_r(out_bram_addr_r),

        .dout_0(out_bram_dout_0), .dout_1(out_bram_dout_1), .dout_2(out_bram_dout_2), .dout_3(out_bram_dout_3),
        .dout_4(out_bram_dout_4), .dout_5(out_bram_dout_5), .dout_6(out_bram_dout_6), .dout_7(out_bram_dout_7)
    );

    // post-process는 마지막 누적 pass에서만 작동
    wire [7:0] pool_valid_arr;

    pe_post_process_col u_pp_0 (
        .clk(clk), .reset_n(reset_n), .fm_width(fm_width),
        .psum_in(pe_out_0), .valid_in(pe_valid_0 && conv_final_pass),
        .pool_out(conv_din_0), .valid_out(pool_valid_arr[0])
    );

    pe_post_process_col u_pp_1 (
        .clk(clk), .reset_n(reset_n), .fm_width(fm_width),
        .psum_in(pe_out_1), .valid_in(pe_valid_1 && conv_final_pass),
        .pool_out(conv_din_1), .valid_out(pool_valid_arr[1])
    );

    pe_post_process_col u_pp_2 (
        .clk(clk), .reset_n(reset_n), .fm_width(fm_width),
        .psum_in(pe_out_2), .valid_in(pe_valid_2 && conv_final_pass),
        .pool_out(conv_din_2), .valid_out(pool_valid_arr[2])
    );

    pe_post_process_col u_pp_3 (
        .clk(clk), .reset_n(reset_n), .fm_width(fm_width),
        .psum_in(pe_out_3), .valid_in(pe_valid_3 && conv_final_pass),
        .pool_out(conv_din_3), .valid_out(pool_valid_arr[3])
    );

    pe_post_process_col u_pp_4 (
        .clk(clk), .reset_n(reset_n), .fm_width(fm_width),
        .psum_in(pe_out_4), .valid_in(pe_valid_4 && conv_final_pass),
        .pool_out(conv_din_4), .valid_out(pool_valid_arr[4])
    );

    pe_post_process_col u_pp_5 (
        .clk(clk), .reset_n(reset_n), .fm_width(fm_width),
        .psum_in(pe_out_5), .valid_in(pe_valid_5 && conv_final_pass),
        .pool_out(conv_din_5), .valid_out(pool_valid_arr[5])
    );

    pe_post_process_col u_pp_6 (
        .clk(clk), .reset_n(reset_n), .fm_width(fm_width),
        .psum_in(pe_out_6), .valid_in(pe_valid_6 && conv_final_pass),
        .pool_out(conv_din_6), .valid_out(pool_valid_arr[6])
    );

    pe_post_process_col u_pp_7 (
        .clk(clk), .reset_n(reset_n), .fm_width(fm_width),
        .psum_in(pe_out_7), .valid_in(pe_valid_7 && conv_final_pass),
        .pool_out(conv_din_7), .valid_out(pool_valid_arr[7])
    );

    // Conv writeback address
    // Conv1 -> Conv2로 넘어갈 때 mode_select는 계속 CONV이므로 current_state 변화로도 reset
    reg [11:0] conv_addr_w_reg;
    reg [2:0] prev_current_state;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            prev_current_state <= 3'd0;
        else
            prev_current_state <= current_state;
    end

    wire conv_layer_changed = (current_state != prev_current_state);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            conv_addr_w_reg <= 12'd0;
        end else if (mode_select != 2'd1) begin
            conv_addr_w_reg <= 12'd0;
        end else if (conv_layer_changed) begin
            conv_addr_w_reg <= 12'd0;
        end else if (pool_valid_arr[0]) begin
            conv_addr_w_reg <= conv_addr_w_reg + 12'd1;
        end
    end

    assign conv_addr_w = conv_addr_w_reg;
    assign conv_we = {8{pool_valid_arr[0]}};

endmodule