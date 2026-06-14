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

    // 추가: Conv2에서 현재 몇 번째 input channel을 읽는지 top에 알려줌
    output wire [2:0] conv_ch_idx,

    // 추가: Conv 누적이 최종 pass인지 알려줌
    // 이 신호가 1일 때만 post-process/ReLU/pooling/writeback 허용
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
    assign mode_select = (current_state == IDLE) ? 2'd0 : (is_conv) ? 2'd1 : 2'd2;
    assign input_width = (current_state == CONV1) ? 8'd32 : 
                         (current_state == CONV2) ? 8'd14 : 8'd0;
    assign fm_width    = (current_state == CONV1) ? 8'd28 : 
                         (current_state == CONV2) ? 8'd10 : 8'd0;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) current_state <= IDLE;
        else          current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE:   if (dma_done)        next_state = CONV1;
            CONV1:  if (conv_layer_done) next_state = CONV2;
            CONV2:  if (conv_layer_done) next_state = FC1;
            FC1:    if (fc_layer_done)   next_state = FC2;
            FC2:    if (fc_layer_done)   next_state = FC3;
            FC3:    if (fc_layer_done)   next_state = FINISH;
            FINISH: if (ps_read_done)    next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // =========================================================
    // CONV Sub-FSM
    // =========================================================
    reg [2:0] c_state;
    reg [3:0] load_cnt;
    reg [15:0] wait_cnt;
    reg [2:0] stage_cnt;
    reg [2:0] ch_cnt;
    reg [1:0] batch_cnt; 
    
    wire [15:0] target_wait  = (current_state == CONV1) ? 16'd950 : 16'd200; 
    wire [2:0]  target_ch    = (current_state == CONV1) ? 3'd1 : 3'd6;
    wire [1:0]  target_batch = (current_state == CONV1) ? 2'd1 : 2'd2;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            c_state   <= 0;
            load_cnt  <= 0;
            wait_cnt  <= 0;
            stage_cnt <= 0;
            ch_cnt    <= 0;
            batch_cnt <= 0;
        end else if (!is_conv) begin
            c_state   <= 0;
            load_cnt  <= 0;
            wait_cnt  <= 0;
            stage_cnt <= 0;
            ch_cnt    <= 0;
            batch_cnt <= 0;
        end else begin
            case (c_state)
                0: begin
                    c_state <= 1;
                end

                1: begin 
                    // 5개 weight preload
                    if (load_cnt == 4'd5) begin
                        load_cnt <= 0;
                        c_state  <= 2;
                    end else begin
                        load_cnt <= load_cnt + 1;
                    end
                end

                2: begin
                    // start pulse
                    c_state <= 3;
                end

                3: begin 
                    if (wait_cnt == target_wait) begin
                        wait_cnt <= 0;

                        if (stage_cnt == 3'd4) begin
                            stage_cnt <= 0;

                            if (ch_cnt == target_ch - 1) begin
                                ch_cnt  <= 0;
                                c_state <= 4;
                            end else begin
                                ch_cnt  <= ch_cnt + 1;
                                c_state <= 1;
                            end
                        end else begin 
                            stage_cnt <= stage_cnt + 1;
                            c_state   <= 1;
                        end
                    end else begin
                        wait_cnt <= wait_cnt + 1;
                    end
                end

                4: begin 
                    if (batch_cnt == target_batch - 1) begin
                        batch_cnt <= 0;
                        c_state   <= 5;
                    end else begin
                        batch_cnt <= batch_cnt + 1;
                        c_state   <= 1;
                    end
                end

                5: begin
                    c_state <= 5;
                end

                default: begin
                    c_state <= 0;
                end
            endcase
        end
    end

    assign shift_en   = (c_state == 1 && load_cnt < 4'd5); 
    assign opcode     = (c_state == 1) ? 2'd1 :
                        (c_state == 2 || c_state == 3) ? 2'd2 : 2'd0;
    assign start      = (c_state == 2);
    assign stage_idx  = stage_cnt;

    // bias는 전체 누적의 첫 pass에서만 사용
    assign use_bias   = (stage_cnt == 3'd0 && ch_cnt == 3'd0);

    // batch가 끝날 때 Conv bias 주소 증가
    assign next_batch = (is_conv && c_state == 4);

    assign conv_layer_done = (c_state == 5);

    // top에서 Conv2 입력 bank 선택에 사용
    assign conv_ch_idx = ch_cnt;

    // post-process는 마지막 stage, 마지막 channel에서만 허용
    assign conv_final_pass = is_conv &&
                             (c_state == 3) &&
                             (stage_cnt == 3'd4) &&
                             (ch_cnt == target_ch - 1);

    // =========================================================
    // FC Sub-FSM
    // =========================================================
    reg [1:0] f_state;
    reg [7:0] node_cnt;  
    reg [7:0] acc_cnt;   
    
    wire [7:0] target_nodes = (current_state == FC1) ? 8'd120 :
                              (current_state == FC2) ? 8'd84  : 8'd10;

    wire [7:0] target_acc   = (current_state == FC1) ? 8'd50 :
                              (current_state == FC2) ? 8'd15 : 8'd11;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            f_state  <= 0;
            node_cnt <= 0;
            acc_cnt  <= 0;
        end else if (!is_fc) begin
            f_state  <= 0;
            node_cnt <= 0;
            acc_cnt  <= 0;
        end else begin
            case (f_state)
                0: begin
                    f_state <= 1;
                end

                1: begin
                    f_state <= 2;
                end

                2: begin         
                    if (acc_cnt == target_acc - 1) begin
                        acc_cnt <= 0;
                        f_state <= 3;
                    end else begin
                        acc_cnt <= acc_cnt + 1;
                    end
                end

                3: begin         
                    if (node_cnt == target_nodes - 1) begin
                        node_cnt <= 0;
                        f_state  <= 0;
                    end else begin
                        node_cnt <= node_cnt + 1;
                        f_state  <= 1;
                    end
                end

                default: begin
                    f_state <= 0;
                end
            endcase
        end
    end

    assign start_node = (f_state == 1);
    assign valid_in   = (f_state == 2);
    assign end_node   = (f_state == 3);

    assign fc_layer_done = (f_state == 3 && node_cnt == target_nodes - 1);

endmodule