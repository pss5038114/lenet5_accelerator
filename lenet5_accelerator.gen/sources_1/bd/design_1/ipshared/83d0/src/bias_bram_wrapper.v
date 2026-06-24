`timescale 1ns / 1ps

module bias_bram_wrapper (
    input wire clk,
    
    input wire [7:0] we_arr,      
    input wire [7:0] addr_w,      

    input wire [31:0] din_0, din_1, din_2, din_3,
    input wire [31:0] din_4, din_5, din_6, din_7,
    
    input wire [7:0] addr_r,      

    output wire [31:0] dout_0, dout_1, dout_2, dout_3,
    output wire [31:0] dout_4, dout_5, dout_6, dout_7
);

    bram_128b_32bit bank0 (
        .clka(clk), .wea(we_arr[0]), .addra(addr_w), .dina(din_0),
        .clkb(clk), .addrb(addr_r), .doutb(dout_0)
    );

    bram_128b_32bit bank1 (
        .clka(clk), .wea(we_arr[1]), .addra(addr_w), .dina(din_1),
        .clkb(clk), .addrb(addr_r), .doutb(dout_1)
    );

    bram_128b_32bit bank2 (
        .clka(clk), .wea(we_arr[2]), .addra(addr_w), .dina(din_2),
        .clkb(clk), .addrb(addr_r), .doutb(dout_2)
    );

    bram_128b_32bit bank3 (
        .clka(clk), .wea(we_arr[3]), .addra(addr_w), .dina(din_3),
        .clkb(clk), .addrb(addr_r), .doutb(dout_3)
    );

    bram_128b_32bit bank4 (
        .clka(clk), .wea(we_arr[4]), .addra(addr_w), .dina(din_4),
        .clkb(clk), .addrb(addr_r), .doutb(dout_4)
    );

    bram_128b_32bit bank5 (
        .clka(clk), .wea(we_arr[5]), .addra(addr_w), .dina(din_5),
        .clkb(clk), .addrb(addr_r), .doutb(dout_5)
    );

    bram_128b_32bit bank6 (
        .clka(clk), .wea(we_arr[6]), .addra(addr_w), .dina(din_6),
        .clkb(clk), .addrb(addr_r), .doutb(dout_6)
    );

    bram_128b_32bit bank7 (
        .clka(clk), .wea(we_arr[7]), .addra(addr_w), .dina(din_7),
        .clkb(clk), .addrb(addr_r), .doutb(dout_7)
    );

endmodule