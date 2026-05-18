// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Thu May  7 20:05:38 2026
// Host        : MSI running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/lenet5_accelerator/lenet5_accelerator.gen/sources_1/ip/bram_4kb_8bit/bram_4kb_8bit_sim_netlist.v
// Design      : bram_4kb_8bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "bram_4kb_8bit,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module bram_4kb_8bit
   (clka,
    wea,
    addra,
    dina,
    clkb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [11:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [7:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [11:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [7:0]doutb;

  wire [11:0]addra;
  wire [11:0]addrb;
  wire clka;
  wire clkb;
  wire [7:0]dina;
  wire [7:0]doutb;
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
  wire [7:0]NLW_U0_douta_UNCONNECTED;
  wire [11:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "12" *) 
  (* C_ADDRB_WIDTH = "12" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     4.53475 mW" *) 
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
  (* C_INIT_FILE = "bram_4kb_8bit.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "4096" *) 
  (* C_READ_DEPTH_B = "4096" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "8" *) 
  (* C_READ_WIDTH_B = "8" *) 
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
  (* C_WRITE_DEPTH_A = "4096" *) 
  (* C_WRITE_DEPTH_B = "4096" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  bram_4kb_8bit_blk_mem_gen_v8_4_12 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[7:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[11:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[11:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[7:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 26880)
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
