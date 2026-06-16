`timescale 1ns / 1ps

module output_bram_wrapper (
    input wire clk,
    
    // ==========================================
    // ✍️ Write Port (Port A) - Demux에서 버려진(?) PSum이 들어오는 길
    // ==========================================
    input wire [7:0] we_arr,      // 8개 뱅크 각각의 Write Enable
    
    input wire [9:0] addr_w_0, addr_w_1, addr_w_2, addr_w_3,
    input wire [9:0] addr_w_4, addr_w_5, addr_w_6, addr_w_7,
    
    input wire [31:0] din_0, din_1, din_2, din_3,
    input wire [31:0] din_4, din_5, din_6, din_7,
    
    // ==========================================
    // 📖 Read Port (Port B) - PE Array 최상단(top_in)으로 올라가는 길
    // ==========================================
    input wire [9:0] addr_r,      // 읽기 주소 (0 ~ 1023)
    
    output wire [31:0] dout_0, dout_1, dout_2, dout_3,
    output wire [31:0] dout_4, dout_5, dout_6, dout_7
);

    bram_4kb_32bit bank0 (
        .clka(clk), .wea(we_arr[0]), .addra(addr_w_0), .dina(din_0),
        .clkb(clk), .addrb(addr_r), .doutb(dout_0)
    );
    
    bram_4kb_32bit bank1 (
        .clka(clk), .wea(we_arr[1]), .addra(addr_w_1), .dina(din_1),
        .clkb(clk), .addrb(addr_r), .doutb(dout_1)
    );
    
    bram_4kb_32bit bank2 (
        .clka(clk), .wea(we_arr[2]), .addra(addr_w_2), .dina(din_2),
        .clkb(clk), .addrb(addr_r), .doutb(dout_2)
    );
    
    bram_4kb_32bit bank3 (
        .clka(clk), .wea(we_arr[3]), .addra(addr_w_3), .dina(din_3),
        .clkb(clk), .addrb(addr_r), .doutb(dout_3)
    );
    
    bram_4kb_32bit bank4 (
        .clka(clk), .wea(we_arr[4]), .addra(addr_w_4), .dina(din_4),
        .clkb(clk), .addrb(addr_r), .doutb(dout_4)
    );
    
    bram_4kb_32bit bank5 (
        .clka(clk), .wea(we_arr[5]), .addra(addr_w_5), .dina(din_5),
        .clkb(clk), .addrb(addr_r), .doutb(dout_5)
    );
    
    bram_4kb_32bit bank6 (
        .clka(clk), .wea(we_arr[6]), .addra(addr_w_6), .dina(din_6),
        .clkb(clk), .addrb(addr_r), .doutb(dout_6)
    );
    
    bram_4kb_32bit bank7 (
        .clka(clk), .wea(we_arr[7]), .addra(addr_w_7), .dina(din_7),
        .clkb(clk), .addrb(addr_r), .doutb(dout_7)
    );

endmodule