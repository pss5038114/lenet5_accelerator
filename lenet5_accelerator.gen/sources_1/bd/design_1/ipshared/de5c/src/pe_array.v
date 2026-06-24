`timescale 1ns / 1ps

module pe_array #(
    parameter BW_W = 8,
    parameter BW_A = 8,
    parameter BW_P = 32,
    parameter NUM_ROW = 5,
    parameter NUM_COL = 8
)(
    input wire clk,
    input wire reset_n,
    input wire [1:0] opcode,
    input wire [NUM_COL-1:0] col_en, // 8개 컬럼 제어
    input wire [NUM_ROW-1:0] row_en, // 5개 로우 제어
    
    // 💡 1. 마스터 제어 신호 (오직 Column 0, PE(0,0)로만 들어감)
    input wire [BW_A-1:0] iact_in_master,
    input wire master_valid_in,

    // 💡 2. 각 컬럼별 완전히 독립적인 top_in (Weight / Bias 버퍼와 1:1 연결)
    input wire [BW_P-1:0] top_in_0, top_in_1, top_in_2, top_in_3, 
    input wire [BW_P-1:0] top_in_4, top_in_5, top_in_6, top_in_7,

    // 💡 3. 각 컬럼별 완전히 독립적인 bottom_out (양자화/풀링 모듈과 1:1 연결)
    output wire [BW_P-1:0] bottom_out_0, bottom_out_1, bottom_out_2, bottom_out_3,
    output wire [BW_P-1:0] bottom_out_4, bottom_out_5, bottom_out_6, bottom_out_7,
    
    // 💡 각 컬럼별 독립적인 Valid 출력
    output wire valid_out_0, valid_out_1, valid_out_2, valid_out_3,
    output wire valid_out_4, valid_out_5, valid_out_6, valid_out_7
);

    // 내부 라우팅을 깔끔하게 처리하기 위한 Wire 배열 (합성 시 전부 독립된 전선으로 풀림)
    wire [BW_P-1:0] top_in_arr [0:NUM_COL-1];
    assign top_in_arr[0] = top_in_0; assign top_in_arr[1] = top_in_1;
    assign top_in_arr[2] = top_in_2; assign top_in_arr[3] = top_in_3;
    assign top_in_arr[4] = top_in_4; assign top_in_arr[5] = top_in_5;
    assign top_in_arr[6] = top_in_6; assign top_in_arr[7] = top_in_7;

    wire [BW_P-1:0] bottom_out_arr [0:NUM_COL-1];
    assign bottom_out_0 = bottom_out_arr[0]; assign bottom_out_1 = bottom_out_arr[1];
    assign bottom_out_2 = bottom_out_arr[2]; assign bottom_out_3 = bottom_out_arr[3];
    assign bottom_out_4 = bottom_out_arr[4]; assign bottom_out_5 = bottom_out_arr[5];
    assign bottom_out_6 = bottom_out_arr[6]; assign bottom_out_7 = bottom_out_arr[7];

    wire valid_out_arr [0:NUM_COL-1];
    assign valid_out_0 = valid_out_arr[0]; assign valid_out_1 = valid_out_arr[1];
    assign valid_out_2 = valid_out_arr[2]; assign valid_out_3 = valid_out_arr[3];
    assign valid_out_4 = valid_out_arr[4]; assign valid_out_5 = valid_out_arr[5];
    assign valid_out_6 = valid_out_arr[6]; assign valid_out_7 = valid_out_arr[7];

    // Column 간 가로 연결(Cascade)을 위한 전선 (iact 및 valid_hor)
    wire [BW_A-1:0] iact_cascade [0:NUM_COL];
    wire valid_hor_cascade [0:NUM_COL];

    // Array의 가장 왼쪽 입구에 마스터 신호 장착
    assign iact_cascade[0] = iact_in_master;
    assign valid_hor_cascade[0] = master_valid_in;

    genvar i;
    generate
        for (i = 0; i < NUM_COL; i = i + 1) begin : COL_ARRAY
            // 💡 맨 오른쪽 컬럼(i==7)일 경우 IS_RIGHT_COL = 1 전달 -> 내부 레지스터 최적화!
            localparam RIGHT_COL_FLAG = (i == NUM_COL - 1) ? 1 : 0;
            
            // pe_column에서 수집된 40비트 iact_out
            wire [(NUM_ROW*BW_A)-1:0] col_iact_out_40b;

            pe_column #(
                .BW_W(BW_W), .BW_A(BW_A), .BW_P(BW_P),
                .NUM_PE(NUM_ROW),
                .IS_RIGHT_COL(RIGHT_COL_FLAG)
            ) col_inst (
                .clk(clk),
                .reset_n(reset_n),
                .opcode(opcode),
                .col_en(col_en[i]), // 해당 컬럼 끄고 켜기
                .row_en(row_en),
                
                .iact_in(iact_cascade[i]),
                .iact_out(col_iact_out_40b),
                
                .top_in(top_in_arr[i]),
                .valid_in(valid_hor_cascade[i]), // 💡 왼쪽에서 온 가로 Valid가 현재 Column의 맨 위로 들어감
                
                .bottom_out(bottom_out_arr[i]),
                .valid_out(valid_out_arr[i]),
                
                .valid_hor_out(valid_hor_cascade[i+1]) // 💡 맨 위 PE의 가로 Valid를 다음 Column으로 토스
            );
            
            // 💡 핵심 라우팅: 다음 컬럼으로 넘길 때, PE0에서 나온 하위 8비트만 넘겨줌.
            // 어차피 하나의 컬럼 내 5개 PE는 동일한 픽셀을 브로드캐스트 받으므로, 
            // 1클럭 지연된 iact_out 값도 모두 동일함. 따라서 [7:0]만 뽑아 넘겨도 완벽함!
            if (i < NUM_COL - 1) begin
                assign iact_cascade[i+1] = col_iact_out_40b[BW_A-1:0];
            end
        end
    endgenerate

endmodule