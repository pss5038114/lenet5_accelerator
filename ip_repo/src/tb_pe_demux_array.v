`timescale 1ns / 1ps

module tb_pe_demux_array();
    parameter BW_P = 32;
    parameter NUM_COL = 8;

    reg clk;
    reg reset_n;
    reg route_ctrl_master;

    reg [(NUM_COL*BW_P)-1:0] bottom_out_arr;
    reg [NUM_COL-1:0] valid_in_arr;

    wire [(NUM_COL*BW_P)-1:0] out_bram_data_arr;
    wire [NUM_COL-1:0] out_bram_valid_arr;
    wire [(NUM_COL*BW_P)-1:0] out_quant_data_arr;
    wire [NUM_COL-1:0] out_quant_valid_arr;

    pe_demux_array #(.BW_P(BW_P), .NUM_COL(NUM_COL)) uut (
        .clk(clk),
        .reset_n(reset_n),
        .route_ctrl_master(route_ctrl_master),
        .bottom_out_arr(bottom_out_arr),
        .valid_in_arr(valid_in_arr),
        .out_bram_data_arr(out_bram_data_arr),
        .out_bram_valid_arr(out_bram_valid_arr),
        .out_quant_data_arr(out_quant_data_arr),
        .out_quant_valid_arr(out_quant_valid_arr)
    );

    always #5 clk = ~clk;

    integer k;
    reg [(NUM_COL*BW_P)-1:0] temp_data;

    initial begin
        clk = 0; reset_n = 0; route_ctrl_master = 0;
        bottom_out_arr = 0;
        valid_in_arr = 0;
        
        #25 reset_n = 1;
        #20;

        // =========================================================
        // 🌊 대각선(Wavefront) 파도타기 완벽 모사! (타이밍 동기화 버전)
        // =========================================================
        for (k = 0; k < NUM_COL; k = k + 1) begin
            
            // 💡 수정 1: 하강 엣지가 아닌 '상승 엣지(posedge)' 직후로 기준 변경
            @(posedge clk);
            
            // 💡 수정 3: 컨트롤러 신호는 한 번 1이 되면 다시 내리지 않고 쭉 유지!
            if (k == 0) begin
                route_ctrl_master = 1'b1;
            end
            
            // Valid 신호 파도타기
            valid_in_arr = (1 << k);
            
            // 데이터 파도타기
            temp_data = (k + 1) * 10;
            bottom_out_arr = temp_data << (k * BW_P);
        end

        // 파도타기 종료 후 데이터 비우기
        @(posedge clk);
        #1;
        valid_in_arr = 0;
        bottom_out_arr = 0;
        
        // 컨트롤러가 Stage 5 연산을 다 끝냈다고 판단하면 그제야 내림
        #30; 
        route_ctrl_master = 0;

        #150;
        $finish;
    end
endmodule