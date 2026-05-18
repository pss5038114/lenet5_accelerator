// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Thu May  7 20:12:09 2026
// Host        : MSI running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/lenet5_accelerator/lenet5_accelerator.gen/sources_1/ip/bram_4kb_32bit/bram_4kb_32bit_sim_netlist.v
// Design      : bram_4kb_32bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "bram_4kb_32bit,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module bram_4kb_32bit
   (clka,
    wea,
    addra,
    dina,
    clkb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [9:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;

  wire [9:0]addra;
  wire [9:0]addrb;
  wire clka;
  wire clkb;
  wire [31:0]dina;
  wire [31:0]doutb;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_douta_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     5.254725 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "bram_4kb_32bit.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  bram_4kb_32bit_blk_mem_gen_v8_4_12 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[31:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
YqH9kwIC39+qbZg4PSfFsXuB9k9wnuxNryS/CfnEri6Ci9fSC6fsrQ/T/hnt3u/yolbJ8DJa1Qu6
Qnm24A9jLbA+fu3Nsmm6/rM6a4vU6OfVl/gTFd/CiWDutv6Dhn6Lim4uUNPahoOR/A2Yc4Zo2tdI
kMLO9gn9WlH2l3O2oXs=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XJYO2VHd/cnMxQd3i7/2qRhl57dl+doEKuhAunQyv3vpGRG/jlNxj8PqrgLoF0HMdqE3qJUVE/oq
kBSapqjVjLDMOrNGQ+Tc6VGsKMZH8FE/TXHQJ/IM5Iuiu2eozEwwVUomF+7cfqn+9OsVsqCONQ1M
g0oRlangiqasJDhhMfnlGGqwAwmgWRGQA6dmhTuua1s8zdvIv540zY6p5au8cAKVhqyyKK7wbxEE
SGuFqX+NYoyRV+rfWCcWM+hJEmnWS8LNAKkd13YE2+17sPYzUdZ23DmTxXK6KlAxKFW27CBySUfg
qdNXp2DSs2KAQYih27pBNMuHfGbM/ATFPWFvxg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
lYoEi/e8HsDTz6N11EDe/B/iitERmeYndlCklmCluwgb0N4W80JUGVlkd7NlRZHRNhxaNBJPkcjC
n61nO0tb17NwsMwjbY5TF8JWRYTNw1JXCFacvQYrdKv4/7QNQEtwVGiCLxFhOA8aHlWMZIrc2fri
VRMVWaEBcPwCGorlVIM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QEw9fEsWFbdX0OQLvYs/gl+zyEOW3ak9TdQVaq+0AXXOT3LIqF7wDxJ6ZBnlf9mNbdsUVH5tAz1o
H8u7ihJl1L3THEvugW+TS8hkvVbEA9rKO2vV15KAj4Lla7UdFT/xDfe79RFarlLI7yGrubjgdoRi
QWy//UKsffG7IWNwmoSuppWiWB4ZHJtkunNyIkm70JPGyZF62VxJg1MTT+5LUbZG5vZjjuHZud9w
xJaKv1tFP/x8RVqLU5gPOqGqTW7/nKO2S+450Vo4D9vAmBVVcXpaL1EbSmCvQ+qJmcQKtf9qYFRV
Zko08hbpHjPxstqvTDro01jRzB8592m4xU2TWA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TC7q853CWBPPJgbRfgDV1lmjUwSAtliljShAyNFg8sfRfwDzchthzoSPH1UCHV++E2JXacEKq1lB
UWsNP92U4Xh0/Gu+6esOI0pJb8I+TRTxyBN1I4cRQEfQHcwfhbSdeH3yX9OV3opLEqYmT37hWU+J
zCawYnxVESI0FtRzEXve9gdEWlrKKckrT/hp4mvxxOjvOkOSQBvy0elgUOqh6mEOZl+JnUbsR+Wm
CoZLE1eefMZy3FnVmyDNPv3JPXi88aLXMyimal0MYFkTiS4XJiGT3eAIMIbksehXY+eYi/KFpZWQ
GHpX+lG3UmiWWLwyPakFwKEHbrBc70AlJ2eV9g==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
j9nmCKgjPWNChPbpSW6EWLrMA6oCG2JGPoum8px09v0PEAh0DRXZi0J8HPzXUsZgOEMcKpA7X54u
YFcDDCLAQ+urha/eSPbQYHQh4yGCursxAQ1C6LEyNQ2wJ0eLlO2bJeAl/gof06zqsYVM2lLJVNv5
wao1k2bmgPdfpfY3c9vPD0fSMuZPS41EoRS0cQhO5GTZnKdjxm6tEUL3GnTjB8ynSCIbCJUsMtAX
4FRHNa52gudx5B5fagR+lXgFhE7e++rWTJELr7SYB+r5Es8qZLTpCH8TrQxEkV0rY/+e4sAjNE2D
gHw8GD7VcUtc15B8y1BbVmh29qc8Nd3V2i/miA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UkCD6I/Vye4qNoNoa3hIexBXG3xyKUJPAHAjIo7UcNVCDXpMQiYEtPDqExZMfiPlJn2nswCYIfIJ
FYWqMCloKSQyyI/7yZ2EtbyWEklb/P5IyZyvGi6hhFUo/JFTb12b4bK0gZPr+bCDdlVQKTx5GVHz
wptdUJO2omSj8axVMPbLRRtVzlJIZ29dTJ2ATXVXAcBxPnFfHRAMnYYKLeeLExX61vQvpqrkLQHm
XG7hpVzJi56gYKAzxa2BLq072OCVpVS70bfWlhlSTVcSlCrUf+EcarEk4FD8+Ih2NCvrqremG6yn
TtcBn8Xr8M/6zhOYvLi6AD6eArDMKA8n+Ccv8A==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
A5y5QVZU8yjPexRVPioSiAGohCHD5DX5FVobuMyhcgQRExLUhPvnnS8HOtxTj/2IapEcz68gFMGG
Hpi+m725u85/om/Vze9pGIW9Mn328Kz2FIg3W5EvGstfGwY+48LiAGAmTR269JS4lJGVYWYOz7Xk
S8cEsFd2m7j8iyKtARJzD90+UdXq/cIIh725jC9i8nbgxB364zddvm1Z/DF3JRw1qFp6GGcuRai1
KNcJ1j8c9wtIgktpsteU3e5+bxHEw8NT3gWXUFYjm00NDq97Jals8Jjktmum2nQxoF7ivPacfEey
gnSF6jRMkTsZObzc30hAhs0CEtc33hZLhPLHSn8pQ0WyvKJLHdd5s2yckgTZtqxC1Sbwe7WEgNXe
ZMX3pIkz+aoXsAL7GBLyVBMVQcyMoF0w8QGAaTe8sqatABwPqXidYRqNROTf62IYcMpV89XYgaTv
EwIn/oni9KOFd2BFVxRZbFGGC4IjvigsTBUijI+Dk6kVnDh240clGcc4

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Omtp+lCaqUx7Z4qdFj2zrN8LpCkit2eX4hlMtig+ielGm/x4FSZkpjoFmiqdKFPi2eg0pg09MSai
XyGH68UzAR7Xrj8f1jlIoUmMKp4GcxfdqfTeuu7kWGOJEP6cvgTjSJFj2gawDv7f4yZcltnK2x0L
e4GW/rBTmGvZtKWb2ahjINLxPuh3dDaSaWdb+zVgbtyrI5FrjxBkq+aOxSjyNsqnCx1L0uWbxnkl
88NbXN3dTaECXHNm/fsleayM5hKis7kTv9BFajJMGy+BhQlmIYpE+F5zchnTTFUFJZCz1sX9Fc8e
HcY7irB8mR3ajdzjUZLBQEMktp096Nheq3U75A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hpeBLwN9x2ZFDwroYLlUe5GjjDepHik2l0c2s3/6S7JPCRkzQSyt2V1Ad/JewAs/QNp5SXSbYYB4
rQl0My1LDMF3xw43r0g2IbcyHVpPhGp0W5msuQdF67afnsRv90iJYWLMI3QkYGCTWAzl4HrLxFSg
3z8XZRK670IcxznOrlvgHmIKsvubZrBkuc1EynrVb9Nw16QnIx2rc4WgcEXeFf+4i1RoYLDd3gXK
NFCNMdtaRYUThunFP6Z4ViZ5UnDmKq+IMhd31jTaqIlWOBDxPI1+v5RJYxIyTbn4rxlKR2fNbl5/
z4OUjBTd+1GH3I2OXlqmAOvIhpe2Z2HH7nZu/A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Mt2RhTSUwEIEWeNARbyL+EdfS1UF6nPaL/fKl/7oO2gina93egwCWDLl1fbBtkfaPco0cu4MJ9K3
OraAsyHRlY+MNShmJ1LzAIA1LjZx4y55lu9dlQqSUXR7AW7wVbkg1864mK+hM/1XygU0jvebKNW9
B7xSER+asLO6pxi0mt7uC2PHxLPAYEszFhmnap82TtbDGdQ2qtyekY+ngs+N2fAdsblxVwJruiMl
e6XJ127M8N1mYwhWU2HtRpBOSnnKoHgD9fG51XK/rhk8DxT66QnX9uLPB+H25eDupBJGi1Y5o6x8
hOwZiSUVlBLh7brfzevh7+eRn+7es6wBas0+3w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 28384)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
