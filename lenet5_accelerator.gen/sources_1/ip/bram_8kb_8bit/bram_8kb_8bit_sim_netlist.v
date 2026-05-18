// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Thu May  7 20:20:28 2026
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
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [12:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [7:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;

  wire [12:0]addra;
  wire clka;
  wire [7:0]dina;
  wire [7:0]douta;
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
  wire [7:0]NLW_U0_doutb_UNCONNECTED;
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.535699 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
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
  (* C_MEM_TYPE = "0" *) 
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
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  bram_8kb_8bit_blk_mem_gen_v8_4_12 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[7:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 46496)
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
