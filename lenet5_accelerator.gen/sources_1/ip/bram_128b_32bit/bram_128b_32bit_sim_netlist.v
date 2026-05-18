// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Mon May 18 12:17:05 2026
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
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [6:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [6:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;

  wire [6:0]addra;
  wire [6:0]addrb;
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
  wire [6:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [6:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "7" *) 
  (* C_ADDRB_WIDTH = "7" *) 
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
  (* C_READ_DEPTH_A = "128" *) 
  (* C_READ_DEPTH_B = "128" *) 
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
  (* C_WRITE_DEPTH_A = "128" *) 
  (* C_WRITE_DEPTH_B = "128" *) 
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[6:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[6:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20160)
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
