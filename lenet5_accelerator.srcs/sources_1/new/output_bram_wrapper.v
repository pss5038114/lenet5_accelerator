`timescale 1ns / 1ps

module output_bram_wrapper (
    input wire clk,
    
    // ==========================================
    // ✍️ Write Port (Port A) - Demux에서 버려진(?) PSum이 들어오는 길
    // ==========================================
    input wire [7:0] we_arr,      // 8개 뱅크 각각의 Write Enable
    
    // 💡 Depth가 1024이므로 주소(addr)는 10비트([9:0])입니다!
    input wire [9:0] addr_w,      // 쓰기 주소 (0 ~ 1023)
    
    input wire [31:0] din_0, din_1, din_2, din_3,
    input wire [31:0] din_4, din_5, din_6, din_7,
    
    // ==========================================
    // 📖 Read Port (Port B) - PE Array 최상단(top_in)으로 올라가는 길
    // ==========================================
    input wire [9:0] addr_r,      // 읽기 주소 (0 ~ 1023)
    
    output wire [31:0] dout_0, dout_1, dout_2, dout_3,
    output wire [31:0] dout_4, dout_5, dout_6, dout_7
);

    // 💡 32-bit, 1024-depth BRAM IP 8번 인스턴스화
    bram_4kb_32bit bank0 (
        .clka(clk), .wea(we_arr[0]), .addra(addr_w), .dina(din_0),
        .clkb(clk), .addrb(addr_r), .doutb(dout_0)
    );

    bram_4kb_32bit bank1 (
        .clka(clk), .wea(we_arr[1]), .addra(addr_w), .dina(din_1),
        .clkb(clk), .addrb(addr_r), .doutb(dout_1)
    );

    bram_4kb_32bit bank2 (
        .clka(clk), .wea(we_arr[2]), .addra(addr_w), .dina(din_2),
        .clkb(clk), .addrb(addr_r), .doutb(dout_2)
    );

    bram_4kb_32bit bank3 (
        .clka(clk), .wea(we_arr[3]), .addra(addr_w), .dina(din_3),
        .clkb(clk), .addrb(addr_r), .doutb(dout_3)
    );

    bram_4kb_32bit bank4 (
        .clka(clk), .wea(we_arr[4]), .addra(addr_w), .dina(din_4),
        .clkb(clk), .addrb(addr_r), .doutb(dout_4)
    );

    bram_4kb_32bit bank5 (
        .clka(clk), .wea(we_arr[5]), .addra(addr_w), .dina(din_5),
        .clkb(clk), .addrb(addr_r), .doutb(dout_5)
    );

    bram_4kb_32bit bank6 (
        .clka(clk), .wea(we_arr[6]), .addra(addr_w), .dina(din_6),
        .clkb(clk), .addrb(addr_r), .doutb(dout_6)
    );

    bram_4kb_32bit bank7 (
        .clka(clk), .wea(we_arr[7]), .addra(addr_w), .dina(din_7),
        .clkb(clk), .addrb(addr_r), .doutb(dout_7)
    );

endmodule