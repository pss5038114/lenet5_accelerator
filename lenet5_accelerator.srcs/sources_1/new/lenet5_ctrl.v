`timescale 1ns / 1ps

module lenet5_ctrl (
    input wire clk,
    input wire reset_n,
    
    input wire dma_done,      
    input wire ps_read_done,  

    output wire ping_pong_state,
    output wire [1:0] mode_select, 
    output wire [7:0] input_width,
    output wire [7:0] fm_width,
    
    output wire shift_en,
    output wire [1:0] opcode,
    output wire use_bias,
    output wire start,
    output wire [2:0] stage_idx,

    output wire start_node,
    output wire valid_in,
    output wire end_node,
    
    output wire next_batch,

    // Conv2에서 현재 몇 번째 input channel을 읽는지 top에 알려줌
    output wire [2:0] conv_ch_idx,

    // Conv 누적이 최종 pass인지 알려줌
    output wire conv_final_pass,

    output reg [2:0] current_state
);

    parameter IDLE = 3'd0, CONV1 = 3'd1, CONV2 = 3'd2;
    parameter FC1  = 3'd3, FC2   = 3'd4, FC3   = 3'd5, FINISH = 3'd6;

    reg [2:0] next_state;

    wire conv_layer_done;
    wire fc_layer_done;

    wire is_conv = (current_state == CONV1 || current_state == CONV2);
    wire is_fc   = (current_state == FC1 || current_state == FC2 || current_state == FC3);

    assign ping_pong_state = (current_state == CONV2 || current_state == FC2) ? 1'b1 : 1'b0;

    assign mode_select = (current_state == IDLE) ? 2'd0 :
                         (is_conv)              ? 2'd1 :
                         (is_fc)                ? 2'd2 : 2'd0;

    assign input_width = (current_state == CONV1) ? 8'd32 :
                         (current_state == CONV2) ? 8'd14 : 8'd0;

    assign fm_width    = (current_state == CONV1) ? 8'd28 :
                         (current_state == CONV2) ? 8'd10 : 8'd0;

    // =========================================================
    // Main FSM
    // =========================================================
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (dma_done)
                    next_state = CONV1;
            end

            CONV1: begin
                if (conv_layer_done)
                    next_state = CONV2;
            end

            CONV2: begin
                if (conv_layer_done)
                    next_state = FC1;
            end

            FC1: begin
                if (fc_layer_done)
                    next_state = FC2;
            end

            FC2: begin
                if (fc_layer_done)
                    next_state = FC3;
            end

            FC3: begin
                if (fc_layer_done)
                    next_state = FINISH;
            end

            FINISH: begin
                if (ps_read_done)
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // =========================================================
    // CONV Sub-FSM
    //
    // c_state:
    // 0 = 준비
    // 1 = weight preload
    // 2 = input_buffer start pulse
    // 3 = stream/MAC 대기
    // 4 = batch boundary / layer done pulse
    //
    // 중요:
    // 기존 c_state 5 hold 상태를 제거함.
    // conv_layer_done은 c_state 4의 마지막 batch에서만 1클럭 pulse처럼 동작.
    // =========================================================
    reg [2:0]  c_state;
    reg [3:0]  load_cnt;
    reg [15:0] wait_cnt;
    reg [2:0]  stage_cnt;
    reg [2:0]  ch_cnt;
    reg [1:0]  batch_cnt;

    wire [15:0] target_wait  = (current_state == CONV1) ? 16'd950 : 16'd200;
    wire [2:0]  target_ch    = (current_state == CONV1) ? 3'd1   : 3'd6;
    wire [1:0]  target_batch = (current_state == CONV1) ? 2'd1   : 2'd2;

    wire last_stage = (stage_cnt == 3'd4);
    wire last_ch    = (ch_cnt == target_ch - 1);
    wire last_batch = (batch_cnt == target_batch - 1);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            c_state   <= 3'd0;
            load_cnt  <= 4'd0;
            wait_cnt  <= 16'd0;
            stage_cnt <= 3'd0;
            ch_cnt    <= 3'd0;
            batch_cnt <= 2'd0;
        end else if (!is_conv) begin
            c_state   <= 3'd0;
            load_cnt  <= 4'd0;
            wait_cnt  <= 16'd0;
            stage_cnt <= 3'd0;
            ch_cnt    <= 3'd0;
            batch_cnt <= 2'd0;
        end else begin
            case (c_state)
                3'd0: begin
                    c_state <= 3'd1;
                end

                3'd1: begin
                    // 5개 weight preload
                    if (load_cnt == 4'd4) begin
                        load_cnt <= 4'd0;
                        c_state  <= 3'd2;
                    end else begin
                        load_cnt <= load_cnt + 4'd1;
                    end
                end

                3'd2: begin
                    // input_buffer start pulse
                    c_state <= 3'd3;
                end

                3'd3: begin
                    // PE/input_buffer/postprocess 완료를 기다리는 구간
                    if (wait_cnt == target_wait) begin
                        wait_cnt <= 16'd0;

                        if (last_stage) begin
                            stage_cnt <= 3'd0;

                            if (last_ch) begin
                                ch_cnt  <= 3'd0;
                                c_state <= 3'd4;
                            end else begin
                                ch_cnt  <= ch_cnt + 3'd1;
                                c_state <= 3'd1;
                            end
                        end else begin
                            stage_cnt <= stage_cnt + 3'd1;
                            c_state   <= 3'd1;
                        end
                    end else begin
                        wait_cnt <= wait_cnt + 16'd1;
                    end
                end

                3'd4: begin
                    // batch boundary
                    // 여기서 next_batch가 1이 되고 bias 주소가 다음 batch/layer로 넘어감.
                    // 마지막 batch라면 layer done pulse를 내고 c_state를 0으로 되돌림.
                    if (last_batch) begin
                        batch_cnt <= 2'd0;
                        c_state   <= 3'd0;
                    end else begin
                        batch_cnt <= batch_cnt + 2'd1;
                        c_state   <= 3'd1;
                    end
                end

                default: begin
                    c_state   <= 3'd0;
                    load_cnt  <= 4'd0;
                    wait_cnt  <= 16'd0;
                    stage_cnt <= 3'd0;
                    ch_cnt    <= 3'd0;
                    batch_cnt <= 2'd0;
                end
            endcase
        end
    end

    assign shift_en = is_conv && (c_state == 1);

    assign opcode = (c_state == 3'd1) ? 2'd1 :
                    (c_state == 3'd2 || c_state == 3'd3) ? 2'd2 :
                    2'd0;

    assign start = is_conv && (c_state == 3'd2);

    assign stage_idx = stage_cnt;

    // Conv 전체 누적의 첫 pass에서만 bias 사용
    assign use_bias = is_conv && (stage_cnt == 3'd0) && (ch_cnt == 3'd0);

    // batch 종료 시 bias 주소 증가
    // CONV1: conv1 bias → conv2 first bias
    // CONV2 batch0: filter0~7 bias → filter8~15 bias
    // CONV2 batch1: conv2 bias → fc1 bias
    assign next_batch = is_conv && (c_state == 3'd4);

    assign conv_ch_idx = ch_cnt;

    // 마지막 input channel의 마지막 kernel row에서만 post-process 허용
    assign conv_final_pass = is_conv &&
                             (c_state == 3'd3) &&
                             last_stage &&
                             last_ch;

    // 핵심 수정:
    // c_state 4의 마지막 batch 순간에만 conv_layer_done = 1
    // 다음 클럭에는 c_state가 0으로 돌아가므로 Conv2에서 done이 유지되지 않음.
    assign conv_layer_done = is_conv &&
                             (c_state == 3'd4) &&
                             last_batch;

    // =========================================================
    // FC Sub-FSM
    // =========================================================
    reg [1:0] f_state;
    reg [7:0] node_cnt;
    reg [7:0] acc_cnt;

    wire [7:0] target_nodes = (current_state == FC1) ? 8'd120 :
                              (current_state == FC2) ? 8'd84  :
                              (current_state == FC3) ? 8'd10  : 8'd0;

    wire [7:0] target_acc   = (current_state == FC1) ? 8'd50 :
                              (current_state == FC2) ? 8'd15 :
                              (current_state == FC3) ? 8'd11 : 8'd0;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            f_state  <= 2'd0;
            node_cnt <= 8'd0;
            acc_cnt  <= 8'd0;
        end else if (!is_fc) begin
            f_state  <= 2'd0;
            node_cnt <= 8'd0;
            acc_cnt  <= 8'd0;
        end else begin
            case (f_state)
                2'd0: begin
                    f_state <= 2'd1;
                end

                2'd1: begin
                    f_state <= 2'd2;
                end

                2'd2: begin
                    if (acc_cnt == target_acc - 1) begin
                        acc_cnt <= 8'd0;
                        f_state <= 2'd3;
                    end else begin
                        acc_cnt <= acc_cnt + 8'd1;
                    end
                end

                2'd3: begin
                    if (node_cnt == target_nodes - 1) begin
                        node_cnt <= 8'd0;
                        f_state  <= 2'd0;
                    end else begin
                        node_cnt <= node_cnt + 8'd1;
                        f_state  <= 2'd1;
                    end
                end

                default: begin
                    f_state <= 2'd0;
                end
            endcase
        end
    end

    assign start_node = is_fc && (f_state == 2'd1);
    assign valid_in   = is_fc && (f_state == 2'd2);
    assign end_node   = is_fc && (f_state == 2'd3);

    assign fc_layer_done = is_fc &&
                           (f_state == 2'd3) &&
                           (node_cnt == target_nodes - 1);

endmodule