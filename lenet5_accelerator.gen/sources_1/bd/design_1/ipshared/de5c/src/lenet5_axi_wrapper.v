`timescale 1ns / 1ps

// ============================================================
// lenet5_axi_wrapper
// ------------------------------------------------------------
// AXI-Lite + AXI-Stream wrapper for lenet5_simple_stream_wrapper.
//
// Interfaces:
//   - AXI4-Lite slave:
//       control/status/register readout
//   - AXI4-Stream slave:
//       32-bit stream input from AXI DMA MM2S
//
// Register map, byte address:
//   0x00 CONTROL       W: bit0 load_begin pulse
//                         bit1 start_pulse
//                         bit2 ps_read_done_pulse
//   0x04 STATUS        R: bit0 load_active
//                         bit1 load_done
//                         bit2 busy
//                         bit3 done
//                         bit4 result_valid
//                         bit5 s_axis_tready
//                         bit6 idle
//                         bit7 finish
//   0x08 LOAD_TYPE     R/W: 0=image, 1=weight, 2=bias
//   0x0C CURRENT_STATE R
//   0x10 PREDICTED    R
//   0x14 ACTIVE_LOAD   R
//   0x20 SCORE0        R, signed 8-bit sign-extended to 32-bit
//   0x24 SCORE1
//   ...
//   0x44 SCORE9
//
// AXI-Stream packing is the same as lenet5_simple_stream_wrapper:
//   image/weight: 32-bit word 2개 -> 8-bit lane 8개 -> 1 BRAM address
//   bias        : 32-bit word 8개 -> 32-bit lane 8개 -> 1 BRAM address
// ============================================================

module lenet5_axi_wrapper #(
    parameter BW_A = 8,
    parameter BW_W = 8,
    parameter BW_P = 32,
    parameter C_S_AXI_DATA_WIDTH = 32,
    parameter C_S_AXI_ADDR_WIDTH = 8,
    parameter C_S_AXIS_TDATA_WIDTH = 32
)(
    // --------------------------------------------------------
    // Shared AXI clock/reset
    // --------------------------------------------------------
    input  wire s_axi_aclk,
    input  wire s_axi_aresetn,

    // --------------------------------------------------------
    // AXI4-Lite slave write address channel
    // --------------------------------------------------------
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] s_axi_awaddr,
    input  wire [2:0]                    s_axi_awprot,
    input  wire                          s_axi_awvalid,
    output reg                           s_axi_awready,

    // --------------------------------------------------------
    // AXI4-Lite slave write data channel
    // --------------------------------------------------------
    input  wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_wdata,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb,
    input  wire                              s_axi_wvalid,
    output reg                               s_axi_wready,

    // --------------------------------------------------------
    // AXI4-Lite slave write response channel
    // --------------------------------------------------------
    output reg  [1:0] s_axi_bresp,
    output reg        s_axi_bvalid,
    input  wire       s_axi_bready,

    // --------------------------------------------------------
    // AXI4-Lite slave read address channel
    // --------------------------------------------------------
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] s_axi_araddr,
    input  wire [2:0]                    s_axi_arprot,
    input  wire                          s_axi_arvalid,
    output reg                           s_axi_arready,

    // --------------------------------------------------------
    // AXI4-Lite slave read data channel
    // --------------------------------------------------------
    output reg  [C_S_AXI_DATA_WIDTH-1:0] s_axi_rdata,
    output reg  [1:0]                    s_axi_rresp,
    output reg                           s_axi_rvalid,
    input  wire                          s_axi_rready,

    // --------------------------------------------------------
    // AXI4-Stream slave input
    // --------------------------------------------------------
    input  wire [C_S_AXIS_TDATA_WIDTH-1:0]     s_axis_tdata,
    input  wire [(C_S_AXIS_TDATA_WIDTH/8)-1:0] s_axis_tkeep,
    input  wire                                s_axis_tvalid,
    output wire                                s_axis_tready,
    input  wire                                s_axis_tlast,

    // Optional interrupt to PS. It is high while result_valid is high.
    output wire interrupt
);

    localparam [7:0] REG_CONTROL       = 8'h00;
    localparam [7:0] REG_STATUS        = 8'h04;
    localparam [7:0] REG_LOAD_TYPE     = 8'h08;
    localparam [7:0] REG_CURRENT_STATE = 8'h0C;
    localparam [7:0] REG_PREDICTED     = 8'h10;
    localparam [7:0] REG_ACTIVE_LOAD   = 8'h14;

    localparam [7:0] REG_SCORE0        = 8'h20;
    localparam [7:0] REG_SCORE1        = 8'h24;
    localparam [7:0] REG_SCORE2        = 8'h28;
    localparam [7:0] REG_SCORE3        = 8'h2C;
    localparam [7:0] REG_SCORE4        = 8'h30;
    localparam [7:0] REG_SCORE5        = 8'h34;
    localparam [7:0] REG_SCORE6        = 8'h38;
    localparam [7:0] REG_SCORE7        = 8'h3C;
    localparam [7:0] REG_SCORE8        = 8'h40;
    localparam [7:0] REG_SCORE9        = 8'h44;

    localparam LOAD_IMAGE  = 2'd0;
    localparam LOAD_WEIGHT = 2'd1;
    localparam LOAD_BIAS   = 2'd2;

    wire clk     = s_axi_aclk;
    wire reset_n = s_axi_aresetn;

    // ========================================================
    // AXI-Lite register / pulse signals
    // ========================================================
    reg [1:0] load_type_reg;

    reg load_begin_pulse;
    reg start_pulse;
    reg ps_read_done_pulse;

    reg [C_S_AXI_ADDR_WIDTH-1:0] awaddr_reg;
    reg [C_S_AXI_DATA_WIDTH-1:0] wdata_reg;
    reg [(C_S_AXI_DATA_WIDTH/8)-1:0] wstrb_reg;

    reg aw_captured;
    reg w_captured;

    // ========================================================
    // Core/simple-stream wrapper status wires
    // ========================================================
    wire load_active;
    wire load_done;
    wire [1:0] active_load_type;

    wire [2:0] current_state;
    wire busy;
    wire done;

    wire result_valid;
    wire [3:0] predicted_class;

    wire signed [BW_A-1:0] score_0;
    wire signed [BW_A-1:0] score_1;
    wire signed [BW_A-1:0] score_2;
    wire signed [BW_A-1:0] score_3;
    wire signed [BW_A-1:0] score_4;
    wire signed [BW_A-1:0] score_5;
    wire signed [BW_A-1:0] score_6;
    wire signed [BW_A-1:0] score_7;
    wire signed [BW_A-1:0] score_8;
    wire signed [BW_A-1:0] score_9;

    wire core_idle   = (current_state == 3'd0);
    wire core_finish = (current_state == 3'd6);

    assign interrupt = result_valid;

    // AXI DMA usually drives tkeep all 1 for normal full-word transfers.
    // This design ignores tkeep because the stream format is fixed 32-bit words.
    wire axis_word_valid = s_axis_tvalid;

    // ========================================================
    // Helpers
    // ========================================================
    function [31:0] sign_extend_8;
        input [7:0] v;
        begin
            sign_extend_8 = {{24{v[7]}}, v};
        end
    endfunction

    function [31:0] read_reg_mux;
        input [7:0] addr;
        begin
            case (addr)
                REG_CONTROL: begin
                    read_reg_mux = 32'd0;
                end

                REG_STATUS: begin
                    read_reg_mux = {
                        24'd0,
                        core_finish,      // bit7
                        core_idle,        // bit6
                        s_axis_tready,    // bit5
                        result_valid,     // bit4
                        done,             // bit3
                        busy,             // bit2
                        load_done,        // bit1
                        load_active       // bit0
                    };
                end

                REG_LOAD_TYPE: begin
                    read_reg_mux = {30'd0, load_type_reg};
                end

                REG_CURRENT_STATE: begin
                    read_reg_mux = {29'd0, current_state};
                end

                REG_PREDICTED: begin
                    read_reg_mux = {28'd0, predicted_class};
                end

                REG_ACTIVE_LOAD: begin
                    read_reg_mux = {30'd0, active_load_type};
                end

                REG_SCORE0: read_reg_mux = sign_extend_8(score_0);
                REG_SCORE1: read_reg_mux = sign_extend_8(score_1);
                REG_SCORE2: read_reg_mux = sign_extend_8(score_2);
                REG_SCORE3: read_reg_mux = sign_extend_8(score_3);
                REG_SCORE4: read_reg_mux = sign_extend_8(score_4);
                REG_SCORE5: read_reg_mux = sign_extend_8(score_5);
                REG_SCORE6: read_reg_mux = sign_extend_8(score_6);
                REG_SCORE7: read_reg_mux = sign_extend_8(score_7);
                REG_SCORE8: read_reg_mux = sign_extend_8(score_8);
                REG_SCORE9: read_reg_mux = sign_extend_8(score_9);

                default: begin
                    read_reg_mux = 32'd0;
                end
            endcase
        end
    endfunction

    // ========================================================
    // AXI-Lite write channel
    //
    // Supports independent arrival of AW and W.
    // One outstanding write response at a time.
    // ========================================================
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b0;
            s_axi_bresp   <= 2'b00;
            s_axi_bvalid  <= 1'b0;

            awaddr_reg    <= {C_S_AXI_ADDR_WIDTH{1'b0}};
            wdata_reg     <= {C_S_AXI_DATA_WIDTH{1'b0}};
            wstrb_reg     <= {(C_S_AXI_DATA_WIDTH/8){1'b0}};

            aw_captured   <= 1'b0;
            w_captured    <= 1'b0;

            load_type_reg <= LOAD_IMAGE;

            load_begin_pulse    <= 1'b0;
            start_pulse         <= 1'b0;
            ps_read_done_pulse  <= 1'b0;
        end else begin
            // default one-clock pulses
            load_begin_pulse    <= 1'b0;
            start_pulse         <= 1'b0;
            ps_read_done_pulse  <= 1'b0;

            // default ready low; pulse high only when accepting
            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b0;

            if (!aw_captured && !s_axi_bvalid && s_axi_awvalid) begin
                s_axi_awready <= 1'b1;
                awaddr_reg    <= s_axi_awaddr;
                aw_captured   <= 1'b1;
            end

            if (!w_captured && !s_axi_bvalid && s_axi_wvalid) begin
                s_axi_wready <= 1'b1;
                wdata_reg    <= s_axi_wdata;
                wstrb_reg    <= s_axi_wstrb;
                w_captured   <= 1'b1;
            end

            if (aw_captured && w_captured && !s_axi_bvalid) begin
                aw_captured <= 1'b0;
                w_captured  <= 1'b0;

                s_axi_bvalid <= 1'b1;
                s_axi_bresp  <= 2'b00; // OKAY

                case (awaddr_reg[7:0])
                    REG_CONTROL: begin
                        // write-one-to-pulse
                        load_begin_pulse   <= wdata_reg[0];
                        start_pulse        <= wdata_reg[1];
                        ps_read_done_pulse <= wdata_reg[2];
                    end

                    REG_LOAD_TYPE: begin
                        if (wstrb_reg[0]) begin
                            load_type_reg <= wdata_reg[1:0];
                        end
                    end

                    default: begin
                        // read-only or reserved register: ignore write
                    end
                endcase
            end

            if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 1'b0;
            end
        end
    end

    // ========================================================
    // AXI-Lite read channel
    // ========================================================
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            s_axi_arready <= 1'b0;
            s_axi_rdata   <= {C_S_AXI_DATA_WIDTH{1'b0}};
            s_axi_rresp   <= 2'b00;
            s_axi_rvalid  <= 1'b0;
        end else begin
            s_axi_arready <= 1'b0;

            if (!s_axi_rvalid && s_axi_arvalid) begin
                s_axi_arready <= 1'b1;
                s_axi_rdata   <= read_reg_mux(s_axi_araddr[7:0]);
                s_axi_rresp   <= 2'b00; // OKAY
                s_axi_rvalid  <= 1'b1;
            end else if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 1'b0;
            end
        end
    end

    // ========================================================
    // Simple stream wrapper instance
    // ========================================================
    lenet5_simple_stream_wrapper #(
        .BW_A(BW_A),
        .BW_W(BW_W),
        .BW_P(BW_P)
    ) u_stream_wrapper (
        .clk(clk),
        .reset_n(reset_n),

        .load_begin(load_begin_pulse),
        .load_type(load_type_reg),
        .stream_valid(axis_word_valid),
        .stream_ready(s_axis_tready),
        .stream_data(s_axis_tdata),
        .stream_last(s_axis_tlast),

        .load_active(load_active),
        .load_done(load_done),
        .active_load_type(active_load_type),

        .start_pulse(start_pulse),
        .ps_read_done_pulse(ps_read_done_pulse),

        .current_state(current_state),
        .busy(busy),
        .done(done),

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
