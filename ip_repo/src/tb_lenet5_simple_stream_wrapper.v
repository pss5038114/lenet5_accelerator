`timescale 1ns / 1ps

module tb_lenet5_simple_stream_wrapper();

    reg clk;
    reg reset_n;

    reg load_begin;
    reg [1:0] load_type;
    reg stream_valid;
    wire stream_ready;
    reg [31:0] stream_data;
    reg stream_last;

    wire load_active;
    wire load_done;
    wire [1:0] active_load_type;

    reg start_pulse;
    reg ps_read_done_pulse;

    wire [2:0] current_state;
    wire busy;
    wire done;

    wire result_valid;
    wire [3:0] predicted_class;

    wire signed [7:0] score_0;
    wire signed [7:0] score_1;
    wire signed [7:0] score_2;
    wire signed [7:0] score_3;
    wire signed [7:0] score_4;
    wire signed [7:0] score_5;
    wire signed [7:0] score_6;
    wire signed [7:0] score_7;
    wire signed [7:0] score_8;
    wire signed [7:0] score_9;

    localparam LOAD_IMAGE  = 2'd0;
    localparam LOAD_WEIGHT = 2'd1;
    localparam LOAD_BIAS   = 2'd2;

    reg [7:0]  mem_image  [0:8191];
    reg [7:0]  mem_weight [0:61559];
    reg [31:0] mem_bias   [0:1735];

    integer i;
    integer max_score;
    integer tb_predicted_class;

    lenet5_simple_stream_wrapper uut (
        .clk(clk),
        .reset_n(reset_n),

        .load_begin(load_begin),
        .load_type(load_type),
        .stream_valid(stream_valid),
        .stream_ready(stream_ready),
        .stream_data(stream_data),
        .stream_last(stream_last),

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

    task send_stream_word;
        input [31:0] word;
        input last;
        begin
            @(negedge clk);
            while (stream_ready !== 1'b1) begin
                @(negedge clk);
            end

            stream_data  = word;
            stream_last  = last;
            stream_valid = 1'b1;

            @(negedge clk);
            stream_valid = 1'b0;
            stream_last  = 1'b0;
            stream_data  = 32'd0;
        end
    endtask

    task begin_load;
        input [1:0] typ;
        begin
            @(negedge clk);
            load_type  = typ;
            load_begin = 1'b1;

            @(negedge clk);
            load_begin = 1'b0;
        end
    endtask

    task load_image_stream;
        begin
            $display("[%0t] [STREAM] Loading image.txt as 32-bit stream...", $time);
            begin_load(LOAD_IMAGE);

            for (i = 0; i < 8192; i = i + 4) begin
                send_stream_word(
                    pack4_u8(mem_image[i], mem_image[i+1], mem_image[i+2], mem_image[i+3]),
                    (i == 8188)
                );
            end

            wait(load_done == 1'b1);
            @(negedge clk);
            $display("[%0t] [STREAM] Image load done.", $time);
        end
    endtask

    task load_weight_stream;
        begin
            $display("[%0t] [STREAM] Loading weight.txt as 32-bit stream...", $time);
            begin_load(LOAD_WEIGHT);

            for (i = 0; i < 61560; i = i + 4) begin
                send_stream_word(
                    pack4_u8(mem_weight[i], mem_weight[i+1], mem_weight[i+2], mem_weight[i+3]),
                    (i == 61556)
                );
            end

            wait(load_done == 1'b1);
            @(negedge clk);
            $display("[%0t] [STREAM] Weight load done.", $time);
        end
    endtask

    task load_bias_stream;
        begin
            $display("[%0t] [STREAM] Loading bias.txt as 32-bit stream...", $time);
            begin_load(LOAD_BIAS);

            for (i = 0; i < 1736; i = i + 1) begin
                send_stream_word(mem_bias[i], (i == 1735));
            end

            wait(load_done == 1'b1);
            @(negedge clk);
            $display("[%0t] [STREAM] Bias load done.", $time);
        end
    endtask

    task pulse_start;
        begin
            @(negedge clk);
            start_pulse = 1'b1;
            @(negedge clk);
            start_pulse = 1'b0;
        end
    endtask

    task pulse_ps_read_done;
        begin
            @(negedge clk);
            ps_read_done_pulse = 1'b1;
            @(negedge clk);
            ps_read_done_pulse = 1'b0;
        end
    endtask

    initial begin
        clk = 0;
        reset_n = 0;

        load_begin = 0;
        load_type = LOAD_IMAGE;
        stream_valid = 0;
        stream_data = 0;
        stream_last = 0;

        start_pulse = 0;
        ps_read_done_pulse = 0;

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
        $display("[%0t] [TB] Simple stream wrapper test start", $time);
        $display("============================================");

        load_image_stream();
        load_weight_stream();
        load_bias_stream();

        $display("============================================");
        $display("[%0t] [TB] All streams loaded. Start inference.", $time);
        $display("============================================");

        pulse_start();

        wait(result_valid == 1'b1);

        $display("============================================");
        $display("[%0t] [NPU] Inference Complete! Scores:", $time);
        $display("   - Class 0 Score: %0d", score_0);
        $display("   - Class 1 Score: %0d", score_1);
        $display("   - Class 2 Score: %0d", score_2);
        $display("   - Class 3 Score: %0d", score_3);
        $display("   - Class 4 Score: %0d", score_4);
        $display("   - Class 5 Score: %0d", score_5);
        $display("   - Class 6 Score: %0d", score_6);
        $display("   - Class 7 Score: %0d", score_7);
        $display("   - Class 8 Score: %0d", score_8);
        $display("   - Class 9 Score: %0d", score_9);

        max_score = -128;
        tb_predicted_class = 0;

        if (score_0 > max_score) begin max_score = score_0; tb_predicted_class = 0; end
        if (score_1 > max_score) begin max_score = score_1; tb_predicted_class = 1; end
        if (score_2 > max_score) begin max_score = score_2; tb_predicted_class = 2; end
        if (score_3 > max_score) begin max_score = score_3; tb_predicted_class = 3; end
        if (score_4 > max_score) begin max_score = score_4; tb_predicted_class = 4; end
        if (score_5 > max_score) begin max_score = score_5; tb_predicted_class = 5; end
        if (score_6 > max_score) begin max_score = score_6; tb_predicted_class = 6; end
        if (score_7 > max_score) begin max_score = score_7; tb_predicted_class = 7; end
        if (score_8 > max_score) begin max_score = score_8; tb_predicted_class = 8; end
        if (score_9 > max_score) begin max_score = score_9; tb_predicted_class = 9; end

        $display("--------------------------------------------");
        $display("[TB ARGMAX]       Winner Class: %0d", tb_predicted_class);
        $display("[TOP RESULT OUT]  Winner Class: %0d", predicted_class);
        $display("============================================");

        if (tb_predicted_class !== predicted_class) begin
            $display("[ERROR] predicted_class mismatch!");
        end else begin
            $display("[OK] predicted_class matches.");
        end

        pulse_ps_read_done();

        wait(current_state == 3'd0);
        $display("[%0t] [TB] Core returned to IDLE.", $time);

        #100;
        $finish;
    end

endmodule
