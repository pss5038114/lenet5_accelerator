`timescale 1ns / 1ps

module tb_lenet5_top();

    // ==========================================
    // 1. 클럭 및 리셋
    // ==========================================
    reg clk;
    reg reset_n;
    
    // ==========================================
    // 2. 외부 인터페이스 제어 신호
    // ==========================================
    reg dma_done;
    reg ps_read_done;
    wire [2:0] current_state;

    // DMA 주입용 레지스터
    reg [7:0] dma_img_we;
    reg [11:0] dma_img_addr_w;
    reg [7:0] dma_img_din_0, dma_img_din_1, dma_img_din_2, dma_img_din_3;
    reg [7:0] dma_img_din_4, dma_img_din_5, dma_img_din_6, dma_img_din_7;
    
    reg [7:0] dma_w_we;
    reg [12:0] dma_w_addr_w;
    reg [7:0] dma_w_din_0, dma_w_din_1, dma_w_din_2, dma_w_din_3;
    reg [7:0] dma_w_din_4, dma_w_din_5, dma_w_din_6, dma_w_din_7;

    reg [7:0] dma_b_we;
    reg [6:0] dma_b_addr_w;
    reg [31:0] dma_b_din_0, dma_b_din_1, dma_b_din_2, dma_b_din_3;
    reg [31:0] dma_b_din_4, dma_b_din_5, dma_b_din_6, dma_b_din_7;

    // ==========================================
    // 3. 파일 데이터를 담을 거대한 가상 메모리
    // ==========================================
    // 8개씩 묶어서 넣기 위해 크기를 8의 배수로 넉넉히 잡습니다.
    reg [7:0] mem_image [0:1023];
    reg [7:0] mem_weight [0:61471]; // 61470개 + 여유 패딩
    reg [31:0] mem_bias [0:239];    // 236개 + 여유 패딩

    // ==========================================
    // 4. 최상위 모듈 (DUT) 인스턴스화
    // ==========================================
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
        .dma_b_din_4(dma_b_din_4), .dma_b_din_5(dma_b_din_5), .dma_b_din_6(dma_b_din_6), .dma_b_din_7(dma_b_din_7)
    );

    // ==========================================
    // 5. 클럭 생성 및 최종 출력 캡처 (Snooping)
    // ==========================================
    always #5 clk = ~clk; // 100MHz

    reg [7:0] final_scores [0:9];
    integer out_idx = 0;

    // FC3 상태(5)에서 FC 모듈이 쓰기(fc_we)를 할 때마다 출력값을 낚아챕니다.
    always @(posedge clk) begin
        if (current_state == 3'd5 && uut.fc_we[0] == 1'b1) begin
            final_scores[out_idx] = uut.fc_din_0;
            out_idx = out_idx + 1;
        end
    end

    // ==========================================
    // 6. 메인 시뮬레이션 시나리오
    // ==========================================
    integer i;
    integer max_score;
    integer predicted_class;

    initial begin
        // 초기화
        clk = 0; reset_n = 0;
        dma_done = 0; ps_read_done = 0;
        dma_img_we = 0; dma_w_we = 0; dma_b_we = 0;
        
        // 메모리 쓰레기값 방지 초기화
        for (i=0; i<61472; i=i+1) mem_weight[i] = 8'd0;
        for (i=0; i<240; i=i+1) mem_bias[i] = 32'd0;

        // 💡 주의: 파일 경로! 
        // Vivado 실행 위치에 따라 파일을 못 찾을 수 있으므로, 
        // 못 찾으면 "C:/Users/CLAW/Desktop/lenet_test/python_model/image.txt" 처럼 절대 경로로 바꿔주세요!
        $readmemh("image.txt", mem_image);
        $readmemh("weight.txt", mem_weight);
        $readmemh("bias.txt", mem_bias);

        #100 reset_n = 1; #50;
        
        // --- DMA 데이터 로드 시작 ---
        $display("============================================");
        $display("[%0t] 1. 이미지 로드 시작...", $time);
        for (i = 0; i < 1024; i = i + 8) begin
            @(negedge clk);
            dma_img_we = 8'hFF; dma_img_addr_w = i / 8;
            dma_img_din_0 = mem_image[i];   dma_img_din_1 = mem_image[i+1];
            dma_img_din_2 = mem_image[i+2]; dma_img_din_3 = mem_image[i+3];
            dma_img_din_4 = mem_image[i+4]; dma_img_din_5 = mem_image[i+5];
            dma_img_din_6 = mem_image[i+6]; dma_img_din_7 = mem_image[i+7];
        end
        @(negedge clk) dma_img_we = 0;
        
        $display("[%0t] 2. 가중치 로드 시작...", $time);
        for (i = 0; i < 61472; i = i + 8) begin
            @(negedge clk);
            dma_w_we = 8'hFF; dma_w_addr_w = i / 8;
            dma_w_din_0 = mem_weight[i];   dma_w_din_1 = mem_weight[i+1];
            dma_w_din_2 = mem_weight[i+2]; dma_w_din_3 = mem_weight[i+3];
            dma_w_din_4 = mem_weight[i+4]; dma_w_din_5 = mem_weight[i+5];
            dma_w_din_6 = mem_weight[i+6]; dma_w_din_7 = mem_weight[i+7];
        end
        @(negedge clk) dma_w_we = 0;

        $display("[%0t] 3. 바이어스 로드 시작...", $time);
        for (i = 0; i < 240; i = i + 8) begin
            @(negedge clk);
            dma_b_we = 8'hFF; dma_b_addr_w = i / 8;
            dma_b_din_0 = mem_bias[i];   dma_b_din_1 = mem_bias[i+1];
            dma_b_din_2 = mem_bias[i+2]; dma_b_din_3 = mem_bias[i+3];
            dma_b_din_4 = mem_bias[i+4]; dma_b_din_5 = mem_bias[i+5];
            dma_b_din_6 = mem_bias[i+6]; dma_b_din_7 = mem_bias[i+7];
        end
        @(negedge clk) dma_b_we = 0;
        
        // --- DMA 로드 완료 및 NPU 구동 시작 ---
        $display("[%0t] 🚀 데이터 주입 완료! NPU 추론 엔진 가동!", $time);
        $display("============================================");
        #50 dma_done = 1; #10 dma_done = 0;

        // 칩이 모든 연산을 마치고 FINISH(6) 상태가 될 때까지 무한 대기
        wait(current_state == 3'd6);
        
        // --- 최종 결과 채점 (Argmax) ---
        $display("============================================");
        $display("[%0t] 🏁 추론 연산 종료! 결과 분석 중...", $time);
        
        max_score = -128; // 8비트 부호있는 정수 최소값
        predicted_class = 0;
        
        for (i = 0; i < 10; i = i + 1) begin
            $display("   - Class %0d Score: %0d", i, $signed(final_scores[i]));
            if ($signed(final_scores[i]) > max_score) begin
                max_score = $signed(final_scores[i]);
                predicted_class = i;
            end
        end
        
        $display("============================================");
        $display("🎯 [하드웨어 NPU 최종 예측] : 정답은 '%0d' 입니다!!!", predicted_class);
        $display("============================================");
        
        #100 $finish;
    end
endmodule