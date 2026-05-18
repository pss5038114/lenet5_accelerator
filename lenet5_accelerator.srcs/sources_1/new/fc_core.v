`timescale 1ns / 1ps

module fc_core #(
    parameter BW_A = 8,
    parameter BW_W = 8,
    parameter BW_P = 32,
    parameter SHIFT_VAL = 4 // 8비트 양자화를 위한 스케일링 비율
)(
    input wire clk,
    input wire reset_n,
    
    // 💡 컨트롤러 제어 신호
    input wire start_node,  // 1: 새로운 FC 노드 연산 시작 (Bias 로드)
    input wire valid_in,    // 1: 입력 데이터가 유효함 (누적 진행)
    input wire end_node,    // 1: 노드 연산 완료 (양자화 후 출력)
    
    // 📥 입력 데이터 (UBRAM 8개, Weight 8개, Bias 1개)
    input wire [BW_A-1:0] iact_0, iact_1, iact_2, iact_3, iact_4, iact_5, iact_6, iact_7,
    input wire [BW_W-1:0] w_0, w_1, w_2, w_3, w_4, w_5, w_6, w_7,
    input wire [BW_P-1:0] bias,
    
    // 📤 출력 데이터 (완성된 1개의 FC 노드 8비트 값)
    output reg [BW_A-1:0] fc_out,
    output reg valid_out
);

    // =========================================================
    // 1단계: 8 병렬 곱셈기 (8-bit * 8-bit = 16-bit)
    // =========================================================
    wire signed [15:0] mul [0:7];
    
    assign mul[0] = $signed(iact_0) * $signed(w_0);
    assign mul[1] = $signed(iact_1) * $signed(w_1);
    assign mul[2] = $signed(iact_2) * $signed(w_2);
    assign mul[3] = $signed(iact_3) * $signed(w_3);
    assign mul[4] = $signed(iact_4) * $signed(w_4);
    assign mul[5] = $signed(iact_5) * $signed(w_5);
    assign mul[6] = $signed(iact_6) * $signed(w_6);
    assign mul[7] = $signed(iact_7) * $signed(w_7);

    // =========================================================
    // 2단계: Adder Tree (피라미드 구조 덧셈)
    // =========================================================
    // Level 1: 8개 -> 4개 (17-bit 확장)
    wire signed [16:0] add_lvl1_0 = mul[0] + mul[1];
    wire signed [16:0] add_lvl1_1 = mul[2] + mul[3];
    wire signed [16:0] add_lvl1_2 = mul[4] + mul[5];
    wire signed [16:0] add_lvl1_3 = mul[6] + mul[7];

    // Level 2: 4개 -> 2개 (18-bit 확장)
    wire signed [17:0] add_lvl2_0 = add_lvl1_0 + add_lvl1_1;
    wire signed [17:0] add_lvl2_1 = add_lvl1_2 + add_lvl1_3;

    // Level 3: 2개 -> 1개 최종 합 (19-bit 확장)
    wire signed [18:0] sum_tree = add_lvl2_0 + add_lvl2_1;

    // =========================================================
    // 3단계: 누적기 (Accumulator)
    // =========================================================
    reg signed [BW_P-1:0] acc_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc_reg <= 0;
        end else if (start_node) begin
            // 노드 시작: 기존 누적값을 버리고 Bias + 현재 사이클 합으로 초기화
            // (만약 start_node일 때 valid_in이 없다면 그냥 bias만 넣도록 설계 가능)
            acc_reg <= $signed(bias) + sum_tree;
        end else if (valid_in) begin
            // 데이터 유효 시 계속 누적
            acc_reg <= acc_reg + sum_tree;
        end
    end

    // =========================================================
    // 4단계: FC 전용 양자화 모듈 (ReLU -> Shift -> Clamp)
    // =========================================================
    wire signed [BW_P-1:0] relu_val = (acc_reg[BW_P-1]) ? 32'd0 : acc_reg; // 음수면 0
    wire signed [BW_P-1:0] shifted_val = relu_val >>> SHIFT_VAL;           // 나누기 2^SHIFT_VAL

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            fc_out <= 0;
            valid_out <= 0;
        end else begin
            if (end_node) begin
                // 노드 연산 완료 시 양자화 수행 및 출력
                valid_out <= 1'b1;
                if (shifted_val > 127) begin
                    fc_out <= 8'sd127; // Saturation (127 클램핑)
                end else begin
                    fc_out <= shifted_val[BW_A-1:0];
                end
            end else begin
                // 평소에는 valid_out을 꺼둠
                valid_out <= 1'b0; 
                fc_out <= 0;
            end
        end
    end

endmodule