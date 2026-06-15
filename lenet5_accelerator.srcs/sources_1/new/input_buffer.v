`timescale 1ns / 1ps

module input_buffer #(
    parameter BW_A = 8,
    parameter ADDR_WIDTH = 12
)(
    input wire clk,
    input wire reset_n,
    
    input wire start,
    input wire [2:0] stage_idx,
    input wire [7:0] input_width,
    
    output wire [ADDR_WIDTH-1:0] rd_addr,
    input wire [BW_A-1:0] rd_data, 
    
    output reg [BW_A-1:0] iact_out,
    output reg master_valid_out,

    // output_bram psum read address를 master_valid보다 1클럭 먼저 움직이기 위한 신호
    output wire psum_prefetch_valid
);

    reg running;
    reg [7:0] col_cnt;
    reg [7:0] row_cnt;
    reg [ADDR_WIDTH-1:0] current_addr;
    
    reg valid_pipe;      

    wire [7:0] valid_width = input_width - 4; 

    assign rd_addr = current_addr;

    // master_valid_out보다 1클럭 빠른 psum prefetch valid
    // running && (col_cnt < valid_width)는 너무 빨라서 사용하지 않음.
    assign psum_prefetch_valid = valid_pipe;

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
            // current_addr가 나간 후 1클럭 뒤에 rd_data가 도착함
            iact_out <= rd_data;
            master_valid_out <= valid_pipe;

            if (running) begin
                valid_pipe <= (col_cnt < valid_width);
            end else begin
                valid_pipe <= 0;
            end

            if (start) begin
                running <= 1;
                col_cnt <= 0;
                row_cnt <= 0;
                current_addr <= stage_idx * input_width;
            end 
            else if (running) begin
                current_addr <= current_addr + 1;

                if (col_cnt == input_width - 1) begin
                    col_cnt <= 0;
                    
                    if (row_cnt == valid_width - 1) begin
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