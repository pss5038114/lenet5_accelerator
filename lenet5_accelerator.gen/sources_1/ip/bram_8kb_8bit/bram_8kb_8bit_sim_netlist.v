// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Sun Jun 14 15:12:37 2026
// Host        : MSI running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/lenet5_accelerator/lenet5_accelerator.gen/sources_1/ip/bram_8kb_8bit/bram_8kb_8bit_sim_netlist.v
// Design      : bram_8kb_8bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "bram_8kb_8bit,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module bram_8kb_8bit
   (clka,
    wea,
    addra,
    dina,
    clkb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [12:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [7:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [12:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [7:0]doutb;

  wire [12:0]addra;
  wire [12:0]addrb;
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
  wire [12:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [12:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "13" *) 
  (* C_ADDRB_WIDTH = "13" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
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
  (* C_INIT_FILE = "bram_8kb_8bit.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "8192" *) 
  (* C_READ_DEPTH_B = "8192" *) 
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
  (* C_WRITE_DEPTH_A = "8192" *) 
  (* C_WRITE_DEPTH_B = "8192" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  bram_8kb_8bit_blk_mem_gen_v8_4_12 U0
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[12:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[12:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 48000)
`pragma protect data_block
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
aJfJStzO
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
