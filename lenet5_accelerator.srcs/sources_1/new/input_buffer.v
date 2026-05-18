`timescale 1ns / 1ps

module input_buffer #(
    parameter BW_A = 8,
    parameter ADDR_WIDTH = 12
)(
    input wire clk,
    input wire reset_n,
    
    // 💡 컨트롤러에서 받는 범용 제어 신호
    input wire start,             // 연산 시작 펄스 (1클럭)
    input wire [2:0] stage_idx,   // 현재 연산 중인 Stage (0 ~ 4)
    input wire [7:0] input_width, // 💡 승현 님의 K 값 (예: 32 또는 14)
    
    // UBRAM 인터페이스 (읽기 전용)
    output wire [ADDR_WIDTH-1:0] rd_addr,
    input wire [BW_A-1:0] rd_data, 
    
    // PE Array 인터페이스
    output reg [BW_A-1:0] iact_out,
    output reg master_valid_out
);

    reg running;
    reg [7:0] col_cnt;   // K columns 카운터
    reg [7:0] row_cnt;   // (K-4) rows 카운터
    reg [ADDR_WIDTH-1:0] current_addr;
    
    // BRAM 지연시간(1클럭) 보정을 위한 파이프라인 레지스터
    reg valid_pipe;      

    // 💡 승현 님의 공식: 유효 픽셀 구간 (K - 4)
    wire [7:0] valid_width = input_width - 4; 

    // 주소 출력 (BRAM으로 바로 연결)
    assign rd_addr = current_addr;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            running <= 0;
            col_cnt <= 0;
            row_cnt <= 0;
            current_addr <= 0;
            valid_pipe <= 0;
            iact_out <= 0;
            master_valid_out <= 0;
        end else begin
            
            // ====================================================
            // 1. 출력 동기화 (BRAM Latency 보정)
            // ====================================================
            // current_addr가 나간 후 1클럭 뒤에 rd_data가 도착함
            iact_out <= rd_data;
            master_valid_out <= valid_pipe;

            // ====================================================
            // 2. 파이프라인 상태 제어
            // ====================================================
            if (running) begin
                // 현재 픽셀이 (K-4) 구간 안에 있으면 Valid 1, 아니면 0 (Skip)
                valid_pipe <= (col_cnt < valid_width);
            end else begin
                valid_pipe <= 0;
            end

            // ====================================================
            // 3. FSM 및 카운터 제어 (승현 님의 K 로직 반영)
            // ====================================================
            if (start) begin
                running <= 1;
                col_cnt <= 0;
                row_cnt <= 0;
                // 💡 시작 주소: Stage 번호 * K (베릴로그 합성기가 작은 곱셈은 자동 최적화)
                current_addr <= stage_idx * input_width;
            end 
            else if (running) begin
                current_addr <= current_addr + 1; // 1바이트씩 순차적으로 쭉 읽음!

                if (col_cnt == input_width - 1) begin
                    col_cnt <= 0; // K columns 끝, 줄바꿈!
                    
                    if (row_cnt == valid_width - 1) begin
                        // 💡 (K-4) rows 만큼 모두 읽었으면 Stage 종료!
                        running <= 0; 
                    end else begin
                        row_cnt <= row_cnt + 1;
                    end
                end else begin
                    col_cnt <= col_cnt + 1;
                end
            end
        end
    end

endmodule