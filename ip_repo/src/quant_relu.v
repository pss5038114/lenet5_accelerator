`timescale 1ns / 1ps

module quant_relu #(
    parameter BW_P = 32,      // 입력 PSum 비트 폭
    parameter BW_A = 8,       // 출력 Activation 비트 폭 (8비트)
    parameter SHIFT_VAL = 4   // 💡 스케일링 비율 (나누기 2^4 = 16) - 상위 모듈에서 조절 가능
)(
    input wire clk,
    input wire reset_n,
    
    // Demux에서 넘어오는 32비트 데이터와 Valid
    input wire signed [BW_P-1:0] psum_in,
    input wire valid_in,
    
    // 다음 단계(Pooling)로 넘어갈 8비트 양자화 데이터와 Valid
    output reg signed [BW_A-1:0] quant_out,
    output reg valid_out
);

    // 💡 1. ReLU: 음수면 0, 양수면 그대로
    wire signed [BW_P-1:0] relu_val;
    assign relu_val = (psum_in[BW_P-1] == 1'b1) ? {BW_P{1'b0}} : psum_in;

    // 💡 2. Scaling (Shift): 산술 우측 시프트를 통해 값의 크기를 축소 (나눗셈 효과)
    wire signed [BW_P-1:0] shifted_val;
    assign shifted_val = relu_val >>> SHIFT_VAL;

    // 1클럭 파이프라인 (데이터 처리 및 Valid 신호 동기화)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            quant_out <= 0;
            valid_out <= 0;
        end else begin
            // Valid 신호는 그대로 1클럭 지연시켜서 패스
            valid_out <= valid_in;
            
            // valid_in이 1일 때만 연산 결과를 레지스터에 저장 (전력 소모 최소화)
            if (valid_in) begin
                // 💡 3. Saturation (Clamping): Signed 8-bit의 최댓값(127)을 넘으면 127로 고정
                if (shifted_val > 127) begin
                    quant_out <= 8'sd127;
                end else begin
                    // 127 이하이면 안전하게 하위 8비트만 잘라서 전송
                    quant_out <= shifted_val[BW_A-1:0];
                end
            end else begin
                quant_out <= 0; // Valid가 0일 때는 쓰레기 값이 나가지 않게 0 출력
            end
        end
    end

endmodule