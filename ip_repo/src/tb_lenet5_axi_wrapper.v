`timescale 1ns / 1ps

module tb_lenet5_axi_wrapper();

    reg clk;
    reg reset_n;

    // AXI4-Lite signals
    reg  [7:0]  s_axi_awaddr;
    reg  [2:0]  s_axi_awprot;
    reg         s_axi_awvalid;
    wire        s_axi_awready;

    reg  [31:0] s_axi_wdata;
    reg  [3:0]  s_axi_wstrb;
    reg         s_axi_wvalid;
    wire        s_axi_wready;

    wire [1:0]  s_axi_bresp;
    wire        s_axi_bvalid;
    reg         s_axi_bready;

    reg  [7:0]  s_axi_araddr;
    reg  [2:0]  s_axi_arprot;
    reg         s_axi_arvalid;
    wire        s_axi_arready;

    wire [31:0] s_axi_rdata;
    wire [1:0]  s_axi_rresp;
    wire        s_axi_rvalid;
    reg         s_axi_rready;

    // AXI4-Stream signals
    reg  [31:0] s_axis_tdata;
    reg  [3:0]  s_axis_tkeep;
    reg         s_axis_tvalid;
    wire        s_axis_tready;
    reg         s_axis_tlast;

    wire interrupt;

    // Register map
    localparam [7:0] REG_CONTROL       = 8'h00;
    localparam [7:0] REG_STATUS        = 8'h04;
    localparam [7:0] REG_LOAD_TYPE     = 8'h08;
    localparam [7:0] REG_CURRENT_STATE = 8'h0C;
    localparam [7:0] REG_PREDICTED     = 8'h10;
    localparam [7:0] REG_ACTIVE_LOAD   = 8'h14;

    localparam [7:0] REG_SCORE0        = 8'h20;

    localparam LOAD_IMAGE  = 2'd0;
    localparam LOAD_WEIGHT = 2'd1;
    localparam LOAD_BIAS   = 2'd2;

    localparam CTRL_LOAD_BEGIN   = 32'h0000_0001;
    localparam CTRL_START        = 32'h0000_0002;
    localparam CTRL_PS_READ_DONE = 32'h0000_0004;

    // text file memories
    reg [7:0]  mem_image  [0:8191];   // 1024 * 8
    reg [7:0]  mem_weight [0:61559];  // 7695 * 8
    reg [31:0] mem_bias   [0:1735];   // 217 * 8

    integer i;
    integer poll_count;
    reg [31:0] rd_data;
    reg signed [31:0] scores [0:9];
    reg signed [31:0] max_score;
    integer tb_predicted_class;
    integer axi_predicted_class;

    lenet5_axi_wrapper uut (
        .s_axi_aclk(clk),
        .s_axi_aresetn(reset_n),

        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awprot(s_axi_awprot),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),

        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),

        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),

        .s_axi_araddr(s_axi_araddr),
        .s_axi_arprot(s_axi_arprot),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arready(s_axi_arready),

        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_rready(s_axi_rready),

        .s_axis_tdata(s_axis_tdata),
        .s_axis_tkeep(s_axis_tkeep),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        .s_axis_tlast(s_axis_tlast),

        .interrupt(interrupt)
    );

    always #5 clk = ~clk;

    function [31:0] pack4_u8;
        input [7:0] b0;
        input [7:0] b1;
        input [7:0] b2;
        input [7:0] b3;
        begin
            pack4_u8 = {b3, b2, b1, b0};
        end
    endfunction

    // ------------------------------------------------------------
    // AXI-Lite write task
    //
    // 주의:
    // BVALID를 본 즉시 BREADY를 negedge에서 내려버리면,
    // slave가 posedge에서 (BVALID && BREADY)를 못 보고 BVALID가 stuck될 수 있다.
    // 그래서 BVALID 확인 후 posedge를 한 번 더 지나가게 해서 response handshake를 완료한다.
    // ------------------------------------------------------------
    task axi_write;
        input [7:0] addr;
        input [31:0] data;
        integer aw_done;
        integer w_done;
        begin
            @(negedge clk);
            s_axi_awaddr  = addr;
            s_axi_awprot  = 3'b000;
            s_axi_awvalid = 1'b1;

            s_axi_wdata   = data;
            s_axi_wstrb   = 4'hF;
            s_axi_wvalid  = 1'b1;

            s_axi_bready  = 1'b1;

            aw_done = 0;
            w_done  = 0;

            while (!aw_done || !w_done) begin
                @(posedge clk);
                #1;

                if (!aw_done && s_axi_awready) begin
                    s_axi_awvalid = 1'b0;
                    aw_done = 1;
                end

                if (!w_done && s_axi_wready) begin
                    s_axi_wvalid = 1'b0;
                    w_done = 1;
                end
            end

            while (!s_axi_bvalid) begin
                @(posedge clk);
                #1;
            end

            // slave가 BVALID && BREADY를 posedge에서 볼 수 있게 한 클럭 더 유지
            @(posedge clk);
            #1;

            s_axi_bready  = 1'b0;
            s_axi_awaddr  = 8'd0;
            s_axi_wdata   = 32'd0;
            s_axi_wstrb   = 4'd0;

            @(negedge clk);
        end
    endtask

    // ------------------------------------------------------------
    // AXI-Lite read task
    //
    // RVALID도 마찬가지로 RREADY를 한 클럭 더 유지해서
    // slave가 posedge에서 read response handshake를 완료하게 한다.
    // ------------------------------------------------------------
    task axi_read;
        input [7:0] addr;
        output [31:0] data;
        begin
            @(negedge clk);
            s_axi_araddr  = addr;
            s_axi_arprot  = 3'b000;
            s_axi_arvalid = 1'b1;
            s_axi_rready  = 1'b1;

            while (!s_axi_arready) begin
                @(posedge clk);
                #1;
            end

            s_axi_arvalid = 1'b0;

            while (!s_axi_rvalid) begin
                @(posedge clk);
                #1;
            end

            data = s_axi_rdata;

            // slave가 RVALID && RREADY를 posedge에서 볼 수 있게 한 클럭 더 유지
            @(posedge clk);
            #1;

            s_axi_rready = 1'b0;
            s_axi_araddr = 8'd0;

            @(negedge clk);
        end
    endtask

    // ------------------------------------------------------------
    // AXI-Stream send task
    // ------------------------------------------------------------
    task axis_send_word;
        input [31:0] word;
        input last;
        begin
            @(negedge clk);
            s_axis_tdata  = word;
            s_axis_tkeep  = 4'hF;
            s_axis_tlast  = last;
            s_axis_tvalid = 1'b1;

            while (!s_axis_tready) begin
                @(negedge clk);
            end

            // handshake occurs at the next posedge while tvalid/tready are high
            @(negedge clk);
            s_axis_tvalid = 1'b0;
            s_axis_tlast  = 1'b0;
            s_axis_tdata  = 32'd0;
            s_axis_tkeep  = 4'd0;
        end
    endtask

    task wait_status_bit;
        input integer bit_index;
        input [1023:0] label;
        begin
            poll_count = 0;
            axi_read(REG_STATUS, rd_data);

            while (rd_data[bit_index] !== 1'b1 && poll_count < 100000) begin
                poll_count = poll_count + 1;
                axi_read(REG_STATUS, rd_data);
            end

            if (rd_data[bit_index] !== 1'b1) begin
                $display("[ERROR] Timeout while waiting for %0s. STATUS=0x%08X", label, rd_data);
                $finish;
            end
        end
    endtask

    task begin_load;
        input [1:0] typ;
        begin
            axi_write(REG_LOAD_TYPE, {30'd0, typ});
            axi_write(REG_CONTROL, CTRL_LOAD_BEGIN);
        end
    endtask

    task load_image_axis;
        begin
            $display("[%0t] [AXI] Loading image.txt through AXI-Stream...", $time);
            begin_load(LOAD_IMAGE);

            for (i = 0; i < 8192; i = i + 4) begin
                axis_send_word(
                    pack4_u8(mem_image[i], mem_image[i+1], mem_image[i+2], mem_image[i+3]),
                    (i == 8188)
                );
            end

            wait_status_bit(1, "image load_done");
            $display("[%0t] [AXI] Image load done.", $time);
        end
    endtask

    task load_weight_axis;
        begin
            $display("[%0t] [AXI] Loading weight.txt through AXI-Stream...", $time);
            begin_load(LOAD_WEIGHT);

            for (i = 0; i < 61560; i = i + 4) begin
                axis_send_word(
                    pack4_u8(mem_weight[i], mem_weight[i+1], mem_weight[i+2], mem_weight[i+3]),
                    (i == 61556)
                );
            end

            wait_status_bit(1, "weight load_done");
            $display("[%0t] [AXI] Weight load done.", $time);
        end
    endtask

    task load_bias_axis;
        begin
            $display("[%0t] [AXI] Loading bias.txt through AXI-Stream...", $time);
            begin_load(LOAD_BIAS);

            for (i = 0; i < 1736; i = i + 1) begin
                axis_send_word(mem_bias[i], (i == 1735));
            end

            wait_status_bit(1, "bias load_done");
            $display("[%0t] [AXI] Bias load done.", $time);
        end
    endtask

    initial begin
        clk = 0;
        reset_n = 0;

        s_axi_awaddr  = 0;
        s_axi_awprot  = 0;
        s_axi_awvalid = 0;

        s_axi_wdata   = 0;
        s_axi_wstrb   = 0;
        s_axi_wvalid  = 0;
        s_axi_bready  = 0;

        s_axi_araddr  = 0;
        s_axi_arprot  = 0;
        s_axi_arvalid = 0;
        s_axi_rready  = 0;

        s_axis_tdata  = 0;
        s_axis_tkeep  = 0;
        s_axis_tvalid = 0;
        s_axis_tlast  = 0;

        for (i = 0; i < 8192; i = i + 1) begin
            mem_image[i] = 8'd0;
        end

        for (i = 0; i < 61560; i = i + 1) begin
            mem_weight[i] = 8'd0;
        end

        for (i = 0; i < 1736; i = i + 1) begin
            mem_bias[i] = 32'd0;
        end

        $readmemh("image.txt", mem_image);
        $readmemh("weight.txt", mem_weight);
        $readmemh("bias.txt", mem_bias);

        #100;
        reset_n = 1'b1;
        #50;

        $display("============================================");
        $display("[%0t] [TB] AXI wrapper test start", $time);
        $display("============================================");

        load_image_axis();
        load_weight_axis();
        load_bias_axis();

        $display("============================================");
        $display("[%0t] [TB] All AXI streams loaded. Start inference.", $time);
        $display("============================================");

        axi_write(REG_CONTROL, CTRL_START);

        wait_status_bit(4, "result_valid");

        $display("============================================");
        $display("[%0t] [NPU] Inference Complete! Read scores via AXI-Lite:", $time);

        for (i = 0; i < 10; i = i + 1) begin
            axi_read(REG_SCORE0 + i*4, rd_data);
            scores[i] = $signed(rd_data);
            $display("   - Class %0d Score: %0d", i, scores[i]);
        end

        axi_read(REG_PREDICTED, rd_data);
        axi_predicted_class = rd_data[3:0];

        max_score = -128;
        tb_predicted_class = 0;

        for (i = 0; i < 10; i = i + 1) begin
            if (scores[i] > max_score) begin
                max_score = scores[i];
                tb_predicted_class = i;
            end
        end

        $display("--------------------------------------------");
        $display("[TB ARGMAX]      Winner Class: %0d", tb_predicted_class);
        $display("[AXI REG PRED]   Winner Class: %0d", axi_predicted_class);
        $display("============================================");

        if (tb_predicted_class !== axi_predicted_class) begin
            $display("[ERROR] predicted_class mismatch!");
            $finish;
        end else begin
            $display("[OK] predicted_class matches.");
        end

        axi_write(REG_CONTROL, CTRL_PS_READ_DONE);

        wait_status_bit(6, "core idle");
        $display("[%0t] [TB] Core returned to IDLE.", $time);

        #100;
        $finish;
    end

endmodule
