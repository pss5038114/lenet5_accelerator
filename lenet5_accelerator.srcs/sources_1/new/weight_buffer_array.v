`timescale 1ns / 1ps

module weight_buffer_array #(
    parameter BW_W = 8
)(
    input wire clk,
    input wire reset_n,

    // BRAM에서 weight를 buffer에 저장하는 구간
    // lenet5_ctrl.v의 c_state == CAPTURE 상태에서 1
    input wire shift_en,

    // buffer에 저장된 weight를 PE로 내보내는 구간
    // opcode == LOAD 상태에서 1
    input wire load_en,

    // Weight BRAM output
    input wire [BW_W-1:0] bram_w_0, bram_w_1, bram_w_2, bram_w_3,
    input wire [BW_W-1:0] bram_w_4, bram_w_5, bram_w_6, bram_w_7,

    // PE Array top_input_router로 나가는 weight
    output wire [BW_W-1:0] pe_w_0, pe_w_1, pe_w_2, pe_w_3,
    output wire [BW_W-1:0] pe_w_4, pe_w_5, pe_w_6, pe_w_7
);

    // =========================================================
    // 5-tap register buffer per column
    //
    // buf_x[0] = 첫 번째 tap
    // buf_x[1] = 두 번째 tap
    // ...
    // buf_x[4] = 다섯 번째 tap
    //
    // PE LOAD 때는 역순으로 출력:
    // buf[4] -> buf[3] -> buf[2] -> buf[1] -> buf[0]
    // =========================================================
    reg [BW_W-1:0] buf_0 [0:4];
    reg [BW_W-1:0] buf_1 [0:4];
    reg [BW_W-1:0] buf_2 [0:4];
    reg [BW_W-1:0] buf_3 [0:4];
    reg [BW_W-1:0] buf_4 [0:4];
    reg [BW_W-1:0] buf_5 [0:4];
    reg [BW_W-1:0] buf_6 [0:4];
    reg [BW_W-1:0] buf_7 [0:4];

    reg [2:0] cap_idx;
    reg [2:0] load_idx;

    integer i;

    // load_idx:
    // 0 -> buf[4]
    // 1 -> buf[3]
    // 2 -> buf[2]
    // 3 -> buf[1]
    // 4 -> buf[0]
    wire [2:0] reverse_idx = 3'd4 - load_idx;

    assign pe_w_0 = load_en ? buf_0[reverse_idx] : {BW_W{1'b0}};
    assign pe_w_1 = load_en ? buf_1[reverse_idx] : {BW_W{1'b0}};
    assign pe_w_2 = load_en ? buf_2[reverse_idx] : {BW_W{1'b0}};
    assign pe_w_3 = load_en ? buf_3[reverse_idx] : {BW_W{1'b0}};
    assign pe_w_4 = load_en ? buf_4[reverse_idx] : {BW_W{1'b0}};
    assign pe_w_5 = load_en ? buf_5[reverse_idx] : {BW_W{1'b0}};
    assign pe_w_6 = load_en ? buf_6[reverse_idx] : {BW_W{1'b0}};
    assign pe_w_7 = load_en ? buf_7[reverse_idx] : {BW_W{1'b0}};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            cap_idx  <= 3'd0;
            load_idx <= 3'd0;

            for (i = 0; i < 5; i = i + 1) begin
                buf_0[i] <= 0;
                buf_1[i] <= 0;
                buf_2[i] <= 0;
                buf_3[i] <= 0;
                buf_4[i] <= 0;
                buf_5[i] <= 0;
                buf_6[i] <= 0;
                buf_7[i] <= 0;
            end
        end else begin
            // -----------------------------------------------------
            // 1. Capture BRAM weights into buffer in forward order
            // -----------------------------------------------------
            if (shift_en) begin
                case (cap_idx)
                    3'd0: begin
                        buf_0[0] <= bram_w_0;
                        buf_1[0] <= bram_w_1;
                        buf_2[0] <= bram_w_2;
                        buf_3[0] <= bram_w_3;
                        buf_4[0] <= bram_w_4;
                        buf_5[0] <= bram_w_5;
                        buf_6[0] <= bram_w_6;
                        buf_7[0] <= bram_w_7;
                    end

                    3'd1: begin
                        buf_0[1] <= bram_w_0;
                        buf_1[1] <= bram_w_1;
                        buf_2[1] <= bram_w_2;
                        buf_3[1] <= bram_w_3;
                        buf_4[1] <= bram_w_4;
                        buf_5[1] <= bram_w_5;
                        buf_6[1] <= bram_w_6;
                        buf_7[1] <= bram_w_7;
                    end

                    3'd2: begin
                        buf_0[2] <= bram_w_0;
                        buf_1[2] <= bram_w_1;
                        buf_2[2] <= bram_w_2;
                        buf_3[2] <= bram_w_3;
                        buf_4[2] <= bram_w_4;
                        buf_5[2] <= bram_w_5;
                        buf_6[2] <= bram_w_6;
                        buf_7[2] <= bram_w_7;
                    end

                    3'd3: begin
                        buf_0[3] <= bram_w_0;
                        buf_1[3] <= bram_w_1;
                        buf_2[3] <= bram_w_2;
                        buf_3[3] <= bram_w_3;
                        buf_4[3] <= bram_w_4;
                        buf_5[3] <= bram_w_5;
                        buf_6[3] <= bram_w_6;
                        buf_7[3] <= bram_w_7;
                    end

                    3'd4: begin
                        buf_0[4] <= bram_w_0;
                        buf_1[4] <= bram_w_1;
                        buf_2[4] <= bram_w_2;
                        buf_3[4] <= bram_w_3;
                        buf_4[4] <= bram_w_4;
                        buf_5[4] <= bram_w_5;
                        buf_6[4] <= bram_w_6;
                        buf_7[4] <= bram_w_7;
                    end

                    default: begin
                    end
                endcase

                if (cap_idx == 3'd4)
                    cap_idx <= 3'd0;
                else
                    cap_idx <= cap_idx + 3'd1;
            end else begin
                cap_idx <= 3'd0;
            end

            // -----------------------------------------------------
            // 2. During PE LOAD, output buffer in reverse order
            // -----------------------------------------------------
            if (load_en) begin
                if (load_idx == 3'd4)
                    load_idx <= 3'd0;
                else
                    load_idx <= load_idx + 3'd1;
            end else begin
                load_idx <= 3'd0;
            end
        end
    end

endmodule