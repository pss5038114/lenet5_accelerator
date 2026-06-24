`timescale 1ns / 1ps

// ============================================================
// lenet5_simple_stream_wrapper
// ------------------------------------------------------------
// AXI를 붙이기 전 단계의 "simple stream" wrapper.
//
// load_type:
//   2'd0 = image
//   2'd1 = weight
//   2'd2 = bias
//
// Stream packing rule:
//   image/weight: 32-bit word 2개 -> 8-bit lane 8개 -> 1 BRAM address
//   bias        : 32-bit word 8개 -> 32-bit lane 8개 -> 1 BRAM address
// ============================================================

module lenet5_simple_stream_wrapper #(
    parameter BW_A = 8,
    parameter BW_W = 8,
    parameter BW_P = 32
)(
    input  wire clk,
    input  wire reset_n,

    input  wire        load_begin,
    input  wire [1:0]  load_type,
    input  wire        stream_valid,
    output wire        stream_ready,
    input  wire [31:0] stream_data,
    input  wire        stream_last,

    output reg         load_active,
    output reg         load_done,
    output reg  [1:0]  active_load_type,

    input  wire        start_pulse,
    input  wire        ps_read_done_pulse,

    output wire [2:0]  current_state,
    output wire        busy,
    output wire        done,

    output wire        result_valid,
    output wire [3:0]  predicted_class,

    output wire signed [BW_A-1:0] score_0,
    output wire signed [BW_A-1:0] score_1,
    output wire signed [BW_A-1:0] score_2,
    output wire signed [BW_A-1:0] score_3,
    output wire signed [BW_A-1:0] score_4,
    output wire signed [BW_A-1:0] score_5,
    output wire signed [BW_A-1:0] score_6,
    output wire signed [BW_A-1:0] score_7,
    output wire signed [BW_A-1:0] score_8,
    output wire signed [BW_A-1:0] score_9
);

    localparam LOAD_IMAGE  = 2'd0;
    localparam LOAD_WEIGHT = 2'd1;
    localparam LOAD_BIAS   = 2'd2;

    // ========================================================
    // Internal DMA-style ports to lenet5_top
    // ========================================================
    reg [7:0]  dma_img_we;
    reg [11:0] dma_img_addr_w;
    reg [BW_A-1:0] dma_img_din_0, dma_img_din_1, dma_img_din_2, dma_img_din_3;
    reg [BW_A-1:0] dma_img_din_4, dma_img_din_5, dma_img_din_6, dma_img_din_7;

    reg [7:0]  dma_w_we;
    reg [12:0] dma_w_addr_w;
    reg [BW_W-1:0] dma_w_din_0, dma_w_din_1, dma_w_din_2, dma_w_din_3;
    reg [BW_W-1:0] dma_w_din_4, dma_w_din_5, dma_w_din_6, dma_w_din_7;

    reg [7:0] dma_b_we;
    reg [7:0] dma_b_addr_w;
    reg [BW_P-1:0] dma_b_din_0, dma_b_din_1, dma_b_din_2, dma_b_din_3;
    reg [BW_P-1:0] dma_b_din_4, dma_b_din_5, dma_b_din_6, dma_b_din_7;

    reg core_dma_done;
    reg core_ps_read_done;

    reg [11:0] img_addr_cnt;
    reg [12:0] w_addr_cnt;
    reg [7:0]  b_addr_cnt;

    // image/weight: 0~1, bias: 0~7
    reg [2:0] pack_phase;

    // After a full address has been packed, write on the next cycle.
    reg write_pending;
    reg finish_after_write;

    assign stream_ready = load_active && !write_pending;
    assign busy = (current_state != 3'd0) && (current_state != 3'd6);
    assign done = result_valid;

    // ========================================================
    // Stream loader
    // ========================================================
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            dma_img_we     <= 8'd0;
            dma_img_addr_w <= 12'd0;
            dma_img_din_0  <= 0; dma_img_din_1 <= 0; dma_img_din_2 <= 0; dma_img_din_3 <= 0;
            dma_img_din_4  <= 0; dma_img_din_5 <= 0; dma_img_din_6 <= 0; dma_img_din_7 <= 0;

            dma_w_we       <= 8'd0;
            dma_w_addr_w   <= 13'd0;
            dma_w_din_0    <= 0; dma_w_din_1 <= 0; dma_w_din_2 <= 0; dma_w_din_3 <= 0;
            dma_w_din_4    <= 0; dma_w_din_5 <= 0; dma_w_din_6 <= 0; dma_w_din_7 <= 0;

            dma_b_we       <= 8'd0;
            dma_b_addr_w   <= 8'd0;
            dma_b_din_0    <= 0; dma_b_din_1 <= 0; dma_b_din_2 <= 0; dma_b_din_3 <= 0;
            dma_b_din_4    <= 0; dma_b_din_5 <= 0; dma_b_din_6 <= 0; dma_b_din_7 <= 0;

            core_dma_done     <= 1'b0;
            core_ps_read_done <= 1'b0;

            img_addr_cnt <= 12'd0;
            w_addr_cnt   <= 13'd0;
            b_addr_cnt   <= 8'd0;

            pack_phase        <= 3'd0;
            write_pending     <= 1'b0;
            finish_after_write <= 1'b0;

            load_active      <= 1'b0;
            load_done        <= 1'b0;
            active_load_type <= LOAD_IMAGE;
        end else begin
            // default one-cycle pulses
            dma_img_we <= 8'd0;
            dma_w_we   <= 8'd0;
            dma_b_we   <= 8'd0;

            core_dma_done     <= 1'b0;
            core_ps_read_done <= 1'b0;

            if (start_pulse) begin
                core_dma_done <= 1'b1;
            end

            if (ps_read_done_pulse) begin
                core_ps_read_done <= 1'b1;
            end

            // ----------------------------------------------------
            // Start a new load transaction
            // ----------------------------------------------------
            if (load_begin) begin
                active_load_type  <= load_type;
                load_active       <= 1'b1;
                load_done         <= 1'b0;
                pack_phase        <= 3'd0;
                write_pending     <= 1'b0;
                finish_after_write <= 1'b0;

                case (load_type)
                    LOAD_IMAGE: begin
                        img_addr_cnt   <= 12'd0;
                        dma_img_addr_w <= 12'd0;
                        dma_img_din_0  <= 0; dma_img_din_1 <= 0; dma_img_din_2 <= 0; dma_img_din_3 <= 0;
                        dma_img_din_4  <= 0; dma_img_din_5 <= 0; dma_img_din_6 <= 0; dma_img_din_7 <= 0;
                    end

                    LOAD_WEIGHT: begin
                        w_addr_cnt   <= 13'd0;
                        dma_w_addr_w <= 13'd0;
                        dma_w_din_0  <= 0; dma_w_din_1 <= 0; dma_w_din_2 <= 0; dma_w_din_3 <= 0;
                        dma_w_din_4  <= 0; dma_w_din_5 <= 0; dma_w_din_6 <= 0; dma_w_din_7 <= 0;
                    end

                    LOAD_BIAS: begin
                        b_addr_cnt   <= 8'd0;
                        dma_b_addr_w <= 8'd0;
                        dma_b_din_0  <= 0; dma_b_din_1 <= 0; dma_b_din_2 <= 0; dma_b_din_3 <= 0;
                        dma_b_din_4  <= 0; dma_b_din_5 <= 0; dma_b_din_6 <= 0; dma_b_din_7 <= 0;
                    end

                    default: begin
                        load_active <= 1'b0;
                    end
                endcase
            end

            // ----------------------------------------------------
            // Execute scheduled write to lenet5_top DMA ports.
            // The child BRAM sees this pulse on the next clock edge.
            // ----------------------------------------------------
            else if (write_pending) begin
                case (active_load_type)
                    LOAD_IMAGE: begin
                        dma_img_we     <= 8'hFF;
                        dma_img_addr_w <= img_addr_cnt;
                        img_addr_cnt   <= img_addr_cnt + 12'd1;
                    end

                    LOAD_WEIGHT: begin
                        dma_w_we     <= 8'hFF;
                        dma_w_addr_w <= w_addr_cnt;
                        w_addr_cnt   <= w_addr_cnt + 13'd1;
                    end

                    LOAD_BIAS: begin
                        dma_b_we     <= 8'hFF;
                        dma_b_addr_w <= b_addr_cnt;
                        b_addr_cnt   <= b_addr_cnt + 8'd1;
                    end

                    default: begin
                    end
                endcase

                write_pending <= 1'b0;
                pack_phase    <= 3'd0;

                if (finish_after_write) begin
                    load_active        <= 1'b0;
                    load_done          <= 1'b1;
                    finish_after_write <= 1'b0;
                end
            end

            // ----------------------------------------------------
            // Accept one 32-bit stream word
            // ----------------------------------------------------
            else if (stream_valid && stream_ready) begin
                case (active_load_type)
                    LOAD_IMAGE: begin
                        if (pack_phase == 3'd0) begin
                            dma_img_din_0 <= stream_data[7:0];
                            dma_img_din_1 <= stream_data[15:8];
                            dma_img_din_2 <= stream_data[23:16];
                            dma_img_din_3 <= stream_data[31:24];

                            if (stream_last) begin
                                dma_img_din_4 <= 0;
                                dma_img_din_5 <= 0;
                                dma_img_din_6 <= 0;
                                dma_img_din_7 <= 0;
                                write_pending <= 1'b1;
                                finish_after_write <= 1'b1;
                            end else begin
                                pack_phase <= 3'd1;
                            end
                        end else begin
                            dma_img_din_4 <= stream_data[7:0];
                            dma_img_din_5 <= stream_data[15:8];
                            dma_img_din_6 <= stream_data[23:16];
                            dma_img_din_7 <= stream_data[31:24];
                            write_pending <= 1'b1;
                            finish_after_write <= stream_last;
                        end
                    end

                    LOAD_WEIGHT: begin
                        if (pack_phase == 3'd0) begin
                            dma_w_din_0 <= stream_data[7:0];
                            dma_w_din_1 <= stream_data[15:8];
                            dma_w_din_2 <= stream_data[23:16];
                            dma_w_din_3 <= stream_data[31:24];

                            if (stream_last) begin
                                dma_w_din_4 <= 0;
                                dma_w_din_5 <= 0;
                                dma_w_din_6 <= 0;
                                dma_w_din_7 <= 0;
                                write_pending <= 1'b1;
                                finish_after_write <= 1'b1;
                            end else begin
                                pack_phase <= 3'd1;
                            end
                        end else begin
                            dma_w_din_4 <= stream_data[7:0];
                            dma_w_din_5 <= stream_data[15:8];
                            dma_w_din_6 <= stream_data[23:16];
                            dma_w_din_7 <= stream_data[31:24];
                            write_pending <= 1'b1;
                            finish_after_write <= stream_last;
                        end
                    end

                    LOAD_BIAS: begin
                        case (pack_phase)
                            3'd0: dma_b_din_0 <= stream_data;
                            3'd1: dma_b_din_1 <= stream_data;
                            3'd2: dma_b_din_2 <= stream_data;
                            3'd3: dma_b_din_3 <= stream_data;
                            3'd4: dma_b_din_4 <= stream_data;
                            3'd5: dma_b_din_5 <= stream_data;
                            3'd6: dma_b_din_6 <= stream_data;
                            3'd7: dma_b_din_7 <= stream_data;
                            default: ;
                        endcase

                        if (stream_last || pack_phase == 3'd7) begin
                            write_pending <= 1'b1;
                            finish_after_write <= stream_last;
                        end else begin
                            pack_phase <= pack_phase + 3'd1;
                        end
                    end

                    default: begin
                    end
                endcase
            end
        end
    end

    // ========================================================
    // Core instance
    // ========================================================
    lenet5_top #(
        .BW_A(BW_A),
        .BW_W(BW_W),
        .BW_P(BW_P)
    ) u_core (
        .clk(clk),
        .reset_n(reset_n),

        .dma_done(core_dma_done),
        .ps_read_done(core_ps_read_done),
        .current_state(current_state),

        .dma_img_we(dma_img_we),
        .dma_img_addr_w(dma_img_addr_w),
        .dma_img_din_0(dma_img_din_0),
        .dma_img_din_1(dma_img_din_1),
        .dma_img_din_2(dma_img_din_2),
        .dma_img_din_3(dma_img_din_3),
        .dma_img_din_4(dma_img_din_4),
        .dma_img_din_5(dma_img_din_5),
        .dma_img_din_6(dma_img_din_6),
        .dma_img_din_7(dma_img_din_7),

        .dma_w_we(dma_w_we),
        .dma_w_addr_w(dma_w_addr_w),
        .dma_w_din_0(dma_w_din_0),
        .dma_w_din_1(dma_w_din_1),
        .dma_w_din_2(dma_w_din_2),
        .dma_w_din_3(dma_w_din_3),
        .dma_w_din_4(dma_w_din_4),
        .dma_w_din_5(dma_w_din_5),
        .dma_w_din_6(dma_w_din_6),
        .dma_w_din_7(dma_w_din_7),

        .dma_b_we(dma_b_we),
        .dma_b_addr_w(dma_b_addr_w),
        .dma_b_din_0(dma_b_din_0),
        .dma_b_din_1(dma_b_din_1),
        .dma_b_din_2(dma_b_din_2),
        .dma_b_din_3(dma_b_din_3),
        .dma_b_din_4(dma_b_din_4),
        .dma_b_din_5(dma_b_din_5),
        .dma_b_din_6(dma_b_din_6),
        .dma_b_din_7(dma_b_din_7),

        .result_valid(result_valid),
        .predicted_class(predicted_class),
        .score_0(score_0),
        .score_1(score_1),
        .score_2(score_2),
        .score_3(score_3),
        .score_4(score_4),
        .score_5(score_5),
        .score_6(score_6),
        .score_7(score_7),
        .score_8(score_8),
        .score_9(score_9)
    );

endmodule
