`timescale 1ns / 1ps

module tb_lenet5_top();

    reg clk;
    reg reset_n;
    reg dma_done;
    reg ps_read_done;
    wire [2:0] current_state;

    reg [7:0] dma_img_we;
    reg [11:0] dma_img_addr_w;
    reg [7:0] dma_img_din_0, dma_img_din_1, dma_img_din_2, dma_img_din_3;
    reg [7:0] dma_img_din_4, dma_img_din_5, dma_img_din_6, dma_img_din_7;
    
    reg [7:0] dma_w_we;
    reg [12:0] dma_w_addr_w;
    reg [7:0] dma_w_din_0, dma_w_din_1, dma_w_din_2, dma_w_din_3;
    reg [7:0] dma_w_din_4, dma_w_din_5, dma_w_din_6, dma_w_din_7;

    reg [7:0] dma_b_we;
    reg [7:0] dma_b_addr_w;
    reg [31:0] dma_b_din_0, dma_b_din_1, dma_b_din_2, dma_b_din_3;
    reg [31:0] dma_b_din_4, dma_b_din_5, dma_b_din_6, dma_b_din_7;

    // 💡 [수정 후] 8배 뻥튀기된 배열 사이즈 반영!
    reg [7:0] mem_image [0:8191];     // 1024 * 8
    reg [7:0] mem_weight [0:61559];   // 7695 * 8
    reg [31:0] mem_bias [0:1735];     // 217 * 8  
    
    wire hw_result_valid;
    wire [3:0] hw_predicted_class;

    wire signed [7:0] hw_score_0;
    wire signed [7:0] hw_score_1;
    wire signed [7:0] hw_score_2;
    wire signed [7:0] hw_score_3;
    wire signed [7:0] hw_score_4;
    wire signed [7:0] hw_score_5;
    wire signed [7:0] hw_score_6;
    wire signed [7:0] hw_score_7;
    wire signed [7:0] hw_score_8;
    wire signed [7:0] hw_score_9;

    lenet5_top uut (
        .clk(clk), .reset_n(reset_n),
        .dma_done(dma_done), .ps_read_done(ps_read_done), .current_state(current_state),
        
        .dma_img_we(dma_img_we), .dma_img_addr_w(dma_img_addr_w),
        .dma_img_din_0(dma_img_din_0), .dma_img_din_1(dma_img_din_1), .dma_img_din_2(dma_img_din_2), .dma_img_din_3(dma_img_din_3),
        .dma_img_din_4(dma_img_din_4), .dma_img_din_5(dma_img_din_5), .dma_img_din_6(dma_img_din_6), .dma_img_din_7(dma_img_din_7),
        
        .dma_w_we(dma_w_we), .dma_w_addr_w(dma_w_addr_w),
        .dma_w_din_0(dma_w_din_0), .dma_w_din_1(dma_w_din_1), .dma_w_din_2(dma_w_din_2), .dma_w_din_3(dma_w_din_3),
        .dma_w_din_4(dma_w_din_4), .dma_w_din_5(dma_w_din_5), .dma_w_din_6(dma_w_din_6), .dma_w_din_7(dma_w_din_7),
        
        .dma_b_we(dma_b_we), .dma_b_addr_w(dma_b_addr_w),
        .dma_b_din_0(dma_b_din_0), .dma_b_din_1(dma_b_din_1), .dma_b_din_2(dma_b_din_2), .dma_b_din_3(dma_b_din_3),
        .dma_b_din_4(dma_b_din_4), .dma_b_din_5(dma_b_din_5), .dma_b_din_6(dma_b_din_6), .dma_b_din_7(dma_b_din_7),

        .result_valid(hw_result_valid),
        .predicted_class(hw_predicted_class),

        .score_0(hw_score_0),
        .score_1(hw_score_1),
        .score_2(hw_score_2),
        .score_3(hw_score_3),
        .score_4(hw_score_4),
        .score_5(hw_score_5),
        .score_6(hw_score_6),
        .score_7(hw_score_7),
        .score_8(hw_score_8),
        .score_9(hw_score_9)
    );

    always #5 clk = ~clk; 

    reg [7:0] final_scores [0:9];
    integer out_idx = 0;

    always @(posedge clk) begin
        // fc_we가 0이 아닐 때(어느 뱅크든 쓰기 발생 시) 캡처!
        if (current_state == 3'd5 && uut.fc_we != 8'h00) begin
            if (out_idx < 10) begin
                final_scores[out_idx] = uut.fc_din_0;
                out_idx = out_idx + 1;
            end
        end
    end

    integer i;
    integer max_score;
    integer predicted_class;

    initial begin
        clk = 0; reset_n = 0;
        dma_done = 0; ps_read_done = 0;
        dma_img_we = 0; dma_w_we = 0; dma_b_we = 0;
        
        // 초기화 루프 업데이트
        for (i=0; i<61560; i=i+1) mem_weight[i] = 8'd0;
        for (i=0; i<1736; i=i+1) mem_bias[i] = 32'd0;

        $readmemh("image.txt", mem_image);
        $readmemh("weight.txt", mem_weight);
        $readmemh("bias.txt", mem_bias);

        #100 reset_n = 1; #50;
        
        $display("============================================");
        // DMA 로딩 루프 업데이트
        $display("[%0t] [DMA] Loading Input Image...", $time);
        for (i = 0; i < 8192; i = i + 8) begin // 1024 -> 8192
            @(negedge clk);
            dma_img_we = 8'hFF; dma_img_addr_w = i / 8;
            dma_img_din_0 = mem_image[i];   dma_img_din_1 = mem_image[i+1];
            dma_img_din_2 = mem_image[i+2]; dma_img_din_3 = mem_image[i+3];
            dma_img_din_4 = mem_image[i+4]; dma_img_din_5 = mem_image[i+5];
            dma_img_din_6 = mem_image[i+6]; dma_img_din_7 = mem_image[i+7];
        end
        @(negedge clk) dma_img_we = 0;
        
        $display("[%0t] [DMA] Loading Network Weights...", $time);
        for (i = 0; i < 61560; i = i + 8) begin // 61472 -> 61560
            @(negedge clk);
            dma_w_we = 8'hFF; dma_w_addr_w = i / 8;
            dma_w_din_0 = mem_weight[i];   dma_w_din_1 = mem_weight[i+1];
            dma_w_din_2 = mem_weight[i+2]; dma_w_din_3 = mem_weight[i+3];
            dma_w_din_4 = mem_weight[i+4]; dma_w_din_5 = mem_weight[i+5];
            dma_w_din_6 = mem_weight[i+6]; dma_w_din_7 = mem_weight[i+7];
        end
        @(negedge clk) dma_w_we = 0;

        $display("[%0t] [DMA] Loading Network Biases...", $time);
        for (i = 0; i < 1736; i = i + 8) begin // 240 -> 1736
            @(negedge clk);
            dma_b_we = 8'hFF; dma_b_addr_w = i / 8;
            dma_b_din_0 = mem_bias[i];   dma_b_din_1 = mem_bias[i+1];
            dma_b_din_2 = mem_bias[i+2]; dma_b_din_3 = mem_bias[i+3];
            dma_b_din_4 = mem_bias[i+4]; dma_b_din_5 = mem_bias[i+5];
            dma_b_din_6 = mem_bias[i+6]; dma_b_din_7 = mem_bias[i+7];
        end
        @(negedge clk) dma_b_we = 0;
        
        $display("[%0t] [DMA] Data Ingestion Done. NPU Inference Triggered!", $time);
        $display("============================================");
        #50 dma_done = 1; #10 dma_done = 0;

        wait(hw_result_valid == 1'b1);

        $display("============================================");
        $display("[%0t] [NPU] Inference Complete! Evaluating Scores...", $time);

        $display("----- Old TB capture -----");
        max_score = -128;
        predicted_class = 0;

        for (i = 0; i < 10; i = i + 1) begin
            $display("   - Class %0d Score: %0d", i, $signed(final_scores[i]));
            if ($signed(final_scores[i]) > max_score) begin
                max_score = $signed(final_scores[i]);
                predicted_class = i;
            end
        end

        $display("----- New top-level result output -----");
        $display("   - result_valid    : %0d", hw_result_valid);
        $display("   - predicted_class : %0d", hw_predicted_class);
        $display("   - Class 0 Score   : %0d", hw_score_0);
        $display("   - Class 1 Score   : %0d", hw_score_1);
        $display("   - Class 2 Score   : %0d", hw_score_2);
        $display("   - Class 3 Score   : %0d", hw_score_3);
        $display("   - Class 4 Score   : %0d", hw_score_4);
        $display("   - Class 5 Score   : %0d", hw_score_5);
        $display("   - Class 6 Score   : %0d", hw_score_6);
        $display("   - Class 7 Score   : %0d", hw_score_7);
        $display("   - Class 8 Score   : %0d", hw_score_8);
        $display("   - Class 9 Score   : %0d", hw_score_9);

        $display("============================================");
        $display("🎯 [OLD TB PREDICTION]       : Winner Class is '%0d'", predicted_class);
        $display("🎯 [TOP RESULT PREDICTION]   : Winner Class is '%0d'", hw_predicted_class);
        $display("============================================");
        
        #100 $finish;
    end
endmodule