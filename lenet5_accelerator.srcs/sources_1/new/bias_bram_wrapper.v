`timescale 1ns / 1ps

module bias_bram_wrapper (
    input wire clk,
    
    // ==========================================
    // ✍️ Write Port (Port A) - ARM 코어/DMA에서 바이어스를 쓰는 길
    // ==========================================
    input wire [7:0] we_arr,      
    
    // 💡 수정됨: Depth가 128이므로 주소 폭을 [6:0] (0~127)으로 변경!
    input wire [6:0] addr_w,      
    
    input wire [31:0] din_0, din_1, din_2, din_3,
    input wire [31:0] din_4, din_5, din_6, din_7,
    
    // ==========================================
    // 📖 Read Port (Port B) - Bias/PSum Buffer(PE)로 나가는 길
    // ==========================================
    
    // 💡 수정됨: Depth가 128이므로 주소 폭을 [6:0] (0~127)으로 변경!
    input wire [6:0] addr_r,      
    
    output wire [31:0] dout_0, dout_1, dout_2, dout_3,
    output wire [31:0] dout_4, dout_5, dout_6, dout_7
);

    // 💡 만약 IP 이름을 변경하지 않고 기존 bram_128b_32bit를 Re-customize 하셨다면 아래 그대로 쓰시면 됩니다.
    // (만약 이름을 새로 만드셨다면 아래 bram_128b_32bit 부분만 새 이름으로 바꿔주세요!)
    bram_128b_32bit bank0 (.clka(clk), .wea(we_arr), .addra(addr_w), .dina(din_0), .clkb(clk), .addrb(addr_r), .doutb(dout_0));
    bram_128b_32bit bank1 (.clka(clk), .wea(we_arr[1]), .addra(addr_w), .dina(din_1), .clkb(clk), .addrb(addr_r), .doutb(dout_1));
    bram_128b_32bit bank2 (.clka(clk), .wea(we_arr[2]), .addra(addr_w), .dina(din_2), .clkb(clk), .addrb(addr_r), .doutb(dout_2));
    bram_128b_32bit bank3 (.clka(clk), .wea(we_arr[3]), .addra(addr_w), .dina(din_3), .clkb(clk), .addrb(addr_r), .doutb(dout_3));
    bram_128b_32bit bank4 (.clka(clk), .wea(we_arr[4]), .addra(addr_w), .dina(din_4), .clkb(clk), .addrb(addr_r), .doutb(dout_4));
    bram_128b_32bit bank5 (.clka(clk), .wea(we_arr[5]), .addra(addr_w), .dina(din_5), .clkb(clk), .addrb(addr_r), .doutb(dout_5));
    bram_128b_32bit bank6 (.clka(clk), .wea(we_arr[6]), .addra(addr_w), .dina(din_6), .clkb(clk), .addrb(addr_r), .doutb(dout_6));
    bram_128b_32bit bank7 (.clka(clk), .wea(we_arr[7]), .addra(addr_w), .dina(din_7), .clkb(clk), .addrb(addr_r), .doutb(dout_7));

endmodule