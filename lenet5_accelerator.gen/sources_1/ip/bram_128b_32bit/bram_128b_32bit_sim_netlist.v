// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Sun Jun 14 18:11:48 2026
// Host        : MSI running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/lenet5_accelerator/lenet5_accelerator.gen/sources_1/ip/bram_128b_32bit/bram_128b_32bit_sim_netlist.v
// Design      : bram_128b_32bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "bram_128b_32bit,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module bram_128b_32bit
   (clka,
    wea,
    addra,
    dina,
    clkb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [7:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;

  wire [7:0]addra;
  wire [7:0]addrb;
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
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.68295 mW" *) 
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
  (* C_INIT_FILE = "bram_128b_32bit.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
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
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  bram_128b_32bit_blk_mem_gen_v8_4_12 U0
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20224)
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
