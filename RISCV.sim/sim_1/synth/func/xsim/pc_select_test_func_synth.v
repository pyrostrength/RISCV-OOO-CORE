// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
// Date        : Sun Nov 30 16:33:30 2025
// Host        : voidknight-XPS-13-7390 running 64-bit Ubuntu 24.04.3 LTS
// Command     : write_verilog -mode funcsim -nolib -force -file
//               /home/voidknight/RISCV/RISCV.sim/sim_1/synth/func/xsim/pc_select_test_func_synth.v
// Design      : pc_select
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-2L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* C = "2" *) (* W = "31" *) 
(* NotValidForBitStream *)
module pc_select
   (reset_addr,
    fix_addr,
    predicted_addr,
    clk,
    reset,
    reset_pipeline,
    fix,
    freeze,
    btb_hit,
    pht_hit,
    PC);
  input [31:0]reset_addr;
  input [31:0]fix_addr;
  input [31:0]predicted_addr;
  input clk;
  input reset;
  input reset_pipeline;
  input fix;
  input freeze;
  input btb_hit;
  input pht_hit;
  output [31:0]PC;

  wire [31:0]PC;
  wire \PC[0]_i_2_n_0 ;
  wire \PC[10]_i_2_n_0 ;
  wire \PC[11]_i_2_n_0 ;
  wire \PC[12]_i_2_n_0 ;
  wire \PC[13]_i_2_n_0 ;
  wire \PC[14]_i_2_n_0 ;
  wire \PC[15]_i_2_n_0 ;
  wire \PC[16]_i_2_n_0 ;
  wire \PC[17]_i_2_n_0 ;
  wire \PC[18]_i_2_n_0 ;
  wire \PC[19]_i_2_n_0 ;
  wire \PC[1]_i_2_n_0 ;
  wire \PC[20]_i_2_n_0 ;
  wire \PC[21]_i_2_n_0 ;
  wire \PC[22]_i_2_n_0 ;
  wire \PC[23]_i_2_n_0 ;
  wire \PC[24]_i_2_n_0 ;
  wire \PC[25]_i_2_n_0 ;
  wire \PC[26]_i_2_n_0 ;
  wire \PC[27]_i_2_n_0 ;
  wire \PC[28]_i_2_n_0 ;
  wire \PC[29]_i_2_n_0 ;
  wire \PC[2]_i_2_n_0 ;
  wire \PC[30]_i_2_n_0 ;
  wire \PC[31]_i_1_n_0 ;
  wire \PC[31]_i_3_n_0 ;
  wire \PC[3]_i_2_n_0 ;
  wire \PC[4]_i_2_n_0 ;
  wire \PC[5]_i_2_n_0 ;
  wire \PC[6]_i_2_n_0 ;
  wire \PC[7]_i_2_n_0 ;
  wire \PC[8]_i_2_n_0 ;
  wire \PC[9]_i_2_n_0 ;
  wire [31:0]PC_OBUF;
  wire [31:0]PC_next;
  wire [31:1]PC_next0;
  wire \PC_reg[12]_i_3_n_0 ;
  wire \PC_reg[12]_i_3_n_1 ;
  wire \PC_reg[12]_i_3_n_2 ;
  wire \PC_reg[12]_i_3_n_3 ;
  wire \PC_reg[16]_i_3_n_0 ;
  wire \PC_reg[16]_i_3_n_1 ;
  wire \PC_reg[16]_i_3_n_2 ;
  wire \PC_reg[16]_i_3_n_3 ;
  wire \PC_reg[20]_i_3_n_0 ;
  wire \PC_reg[20]_i_3_n_1 ;
  wire \PC_reg[20]_i_3_n_2 ;
  wire \PC_reg[20]_i_3_n_3 ;
  wire \PC_reg[24]_i_3_n_0 ;
  wire \PC_reg[24]_i_3_n_1 ;
  wire \PC_reg[24]_i_3_n_2 ;
  wire \PC_reg[24]_i_3_n_3 ;
  wire \PC_reg[28]_i_3_n_0 ;
  wire \PC_reg[28]_i_3_n_1 ;
  wire \PC_reg[28]_i_3_n_2 ;
  wire \PC_reg[28]_i_3_n_3 ;
  wire \PC_reg[31]_i_4_n_2 ;
  wire \PC_reg[31]_i_4_n_3 ;
  wire \PC_reg[4]_i_3_n_0 ;
  wire \PC_reg[4]_i_3_n_1 ;
  wire \PC_reg[4]_i_3_n_2 ;
  wire \PC_reg[4]_i_3_n_3 ;
  wire \PC_reg[8]_i_3_n_0 ;
  wire \PC_reg[8]_i_3_n_1 ;
  wire \PC_reg[8]_i_3_n_2 ;
  wire \PC_reg[8]_i_3_n_3 ;
  wire btb_hit;
  wire btb_hit_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire fix;
  wire fix_IBUF;
  wire [31:0]fix_addr;
  wire [31:0]fix_addr_IBUF;
  wire freeze;
  wire freeze_IBUF;
  wire pht_hit;
  wire pht_hit_IBUF;
  wire [31:0]predicted_addr;
  wire [31:0]predicted_addr_IBUF;
  wire reset;
  wire reset_IBUF;
  wire [31:0]reset_addr;
  wire [31:0]reset_addr_IBUF;
  wire reset_pipeline;
  wire reset_pipeline_IBUF;
  wire [3:2]\NLW_PC_reg[31]_i_4_CO_UNCONNECTED ;
  wire [3:3]\NLW_PC_reg[31]_i_4_O_UNCONNECTED ;

  LUT3 #(
    .INIT(8'hB8)) 
    \PC[0]_i_1 
       (.I0(reset_addr_IBUF[0]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[0]_i_2_n_0 ),
        .O(PC_next[0]));
  LUT6 #(
    .INIT(64'hB8888888B8BBBBBB)) 
    \PC[0]_i_2 
       (.I0(fix_addr_IBUF[0]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[0]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_OBUF[0]),
        .O(\PC[0]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[10]_i_1 
       (.I0(reset_addr_IBUF[10]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[10]_i_2_n_0 ),
        .O(PC_next[10]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[10]_i_2 
       (.I0(fix_addr_IBUF[10]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[10]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[10]),
        .O(\PC[10]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[11]_i_1 
       (.I0(reset_addr_IBUF[11]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[11]_i_2_n_0 ),
        .O(PC_next[11]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[11]_i_2 
       (.I0(fix_addr_IBUF[11]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[11]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[11]),
        .O(\PC[11]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[12]_i_1 
       (.I0(reset_addr_IBUF[12]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[12]_i_2_n_0 ),
        .O(PC_next[12]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[12]_i_2 
       (.I0(fix_addr_IBUF[12]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[12]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[12]),
        .O(\PC[12]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[13]_i_1 
       (.I0(reset_addr_IBUF[13]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[13]_i_2_n_0 ),
        .O(PC_next[13]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[13]_i_2 
       (.I0(fix_addr_IBUF[13]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[13]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[13]),
        .O(\PC[13]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[14]_i_1 
       (.I0(reset_addr_IBUF[14]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[14]_i_2_n_0 ),
        .O(PC_next[14]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[14]_i_2 
       (.I0(fix_addr_IBUF[14]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[14]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[14]),
        .O(\PC[14]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[15]_i_1 
       (.I0(reset_addr_IBUF[15]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[15]_i_2_n_0 ),
        .O(PC_next[15]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[15]_i_2 
       (.I0(fix_addr_IBUF[15]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[15]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[15]),
        .O(\PC[15]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[16]_i_1 
       (.I0(reset_addr_IBUF[16]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[16]_i_2_n_0 ),
        .O(PC_next[16]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[16]_i_2 
       (.I0(fix_addr_IBUF[16]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[16]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[16]),
        .O(\PC[16]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[17]_i_1 
       (.I0(reset_addr_IBUF[17]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[17]_i_2_n_0 ),
        .O(PC_next[17]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[17]_i_2 
       (.I0(fix_addr_IBUF[17]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[17]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[17]),
        .O(\PC[17]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[18]_i_1 
       (.I0(reset_addr_IBUF[18]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[18]_i_2_n_0 ),
        .O(PC_next[18]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[18]_i_2 
       (.I0(fix_addr_IBUF[18]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[18]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[18]),
        .O(\PC[18]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[19]_i_1 
       (.I0(reset_addr_IBUF[19]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[19]_i_2_n_0 ),
        .O(PC_next[19]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[19]_i_2 
       (.I0(fix_addr_IBUF[19]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[19]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[19]),
        .O(\PC[19]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[1]_i_1 
       (.I0(reset_addr_IBUF[1]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[1]_i_2_n_0 ),
        .O(PC_next[1]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[1]_i_2 
       (.I0(fix_addr_IBUF[1]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[1]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[1]),
        .O(\PC[1]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[20]_i_1 
       (.I0(reset_addr_IBUF[20]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[20]_i_2_n_0 ),
        .O(PC_next[20]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[20]_i_2 
       (.I0(fix_addr_IBUF[20]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[20]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[20]),
        .O(\PC[20]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[21]_i_1 
       (.I0(reset_addr_IBUF[21]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[21]_i_2_n_0 ),
        .O(PC_next[21]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[21]_i_2 
       (.I0(fix_addr_IBUF[21]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[21]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[21]),
        .O(\PC[21]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[22]_i_1 
       (.I0(reset_addr_IBUF[22]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[22]_i_2_n_0 ),
        .O(PC_next[22]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[22]_i_2 
       (.I0(fix_addr_IBUF[22]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[22]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[22]),
        .O(\PC[22]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[23]_i_1 
       (.I0(reset_addr_IBUF[23]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[23]_i_2_n_0 ),
        .O(PC_next[23]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[23]_i_2 
       (.I0(fix_addr_IBUF[23]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[23]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[23]),
        .O(\PC[23]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[24]_i_1 
       (.I0(reset_addr_IBUF[24]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[24]_i_2_n_0 ),
        .O(PC_next[24]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[24]_i_2 
       (.I0(fix_addr_IBUF[24]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[24]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[24]),
        .O(\PC[24]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[25]_i_1 
       (.I0(reset_addr_IBUF[25]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[25]_i_2_n_0 ),
        .O(PC_next[25]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[25]_i_2 
       (.I0(fix_addr_IBUF[25]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[25]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[25]),
        .O(\PC[25]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[26]_i_1 
       (.I0(reset_addr_IBUF[26]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[26]_i_2_n_0 ),
        .O(PC_next[26]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[26]_i_2 
       (.I0(fix_addr_IBUF[26]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[26]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[26]),
        .O(\PC[26]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[27]_i_1 
       (.I0(reset_addr_IBUF[27]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[27]_i_2_n_0 ),
        .O(PC_next[27]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[27]_i_2 
       (.I0(fix_addr_IBUF[27]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[27]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[27]),
        .O(\PC[27]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[28]_i_1 
       (.I0(reset_addr_IBUF[28]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[28]_i_2_n_0 ),
        .O(PC_next[28]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[28]_i_2 
       (.I0(fix_addr_IBUF[28]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[28]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[28]),
        .O(\PC[28]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[29]_i_1 
       (.I0(reset_addr_IBUF[29]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[29]_i_2_n_0 ),
        .O(PC_next[29]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[29]_i_2 
       (.I0(fix_addr_IBUF[29]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[29]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[29]),
        .O(\PC[29]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[2]_i_1 
       (.I0(reset_addr_IBUF[2]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[2]_i_2_n_0 ),
        .O(PC_next[2]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[2]_i_2 
       (.I0(fix_addr_IBUF[2]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[2]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[2]),
        .O(\PC[2]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[30]_i_1 
       (.I0(reset_addr_IBUF[30]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[30]_i_2_n_0 ),
        .O(PC_next[30]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[30]_i_2 
       (.I0(fix_addr_IBUF[30]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[30]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[30]),
        .O(\PC[30]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'hB)) 
    \PC[31]_i_1 
       (.I0(reset_pipeline_IBUF),
        .I1(freeze_IBUF),
        .O(\PC[31]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[31]_i_2 
       (.I0(reset_addr_IBUF[31]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[31]_i_3_n_0 ),
        .O(PC_next[31]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[31]_i_3 
       (.I0(fix_addr_IBUF[31]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[31]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[31]),
        .O(\PC[31]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[3]_i_1 
       (.I0(reset_addr_IBUF[3]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[3]_i_2_n_0 ),
        .O(PC_next[3]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[3]_i_2 
       (.I0(fix_addr_IBUF[3]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[3]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[3]),
        .O(\PC[3]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[4]_i_1 
       (.I0(reset_addr_IBUF[4]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[4]_i_2_n_0 ),
        .O(PC_next[4]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[4]_i_2 
       (.I0(fix_addr_IBUF[4]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[4]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[4]),
        .O(\PC[4]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[5]_i_1 
       (.I0(reset_addr_IBUF[5]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[5]_i_2_n_0 ),
        .O(PC_next[5]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[5]_i_2 
       (.I0(fix_addr_IBUF[5]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[5]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[5]),
        .O(\PC[5]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[6]_i_1 
       (.I0(reset_addr_IBUF[6]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[6]_i_2_n_0 ),
        .O(PC_next[6]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[6]_i_2 
       (.I0(fix_addr_IBUF[6]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[6]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[6]),
        .O(\PC[6]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[7]_i_1 
       (.I0(reset_addr_IBUF[7]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[7]_i_2_n_0 ),
        .O(PC_next[7]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[7]_i_2 
       (.I0(fix_addr_IBUF[7]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[7]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[7]),
        .O(\PC[7]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[8]_i_1 
       (.I0(reset_addr_IBUF[8]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[8]_i_2_n_0 ),
        .O(PC_next[8]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[8]_i_2 
       (.I0(fix_addr_IBUF[8]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[8]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[8]),
        .O(\PC[8]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \PC[9]_i_1 
       (.I0(reset_addr_IBUF[9]),
        .I1(reset_pipeline_IBUF),
        .I2(\PC[9]_i_2_n_0 ),
        .O(PC_next[9]));
  LUT6 #(
    .INIT(64'hB8BBBBBBB8888888)) 
    \PC[9]_i_2 
       (.I0(fix_addr_IBUF[9]),
        .I1(fix_IBUF),
        .I2(predicted_addr_IBUF[9]),
        .I3(pht_hit_IBUF),
        .I4(btb_hit_IBUF),
        .I5(PC_next0[9]),
        .O(\PC[9]_i_2_n_0 ));
  OBUF \PC_OBUF[0]_inst 
       (.I(PC_OBUF[0]),
        .O(PC[0]));
  OBUF \PC_OBUF[10]_inst 
       (.I(PC_OBUF[10]),
        .O(PC[10]));
  OBUF \PC_OBUF[11]_inst 
       (.I(PC_OBUF[11]),
        .O(PC[11]));
  OBUF \PC_OBUF[12]_inst 
       (.I(PC_OBUF[12]),
        .O(PC[12]));
  OBUF \PC_OBUF[13]_inst 
       (.I(PC_OBUF[13]),
        .O(PC[13]));
  OBUF \PC_OBUF[14]_inst 
       (.I(PC_OBUF[14]),
        .O(PC[14]));
  OBUF \PC_OBUF[15]_inst 
       (.I(PC_OBUF[15]),
        .O(PC[15]));
  OBUF \PC_OBUF[16]_inst 
       (.I(PC_OBUF[16]),
        .O(PC[16]));
  OBUF \PC_OBUF[17]_inst 
       (.I(PC_OBUF[17]),
        .O(PC[17]));
  OBUF \PC_OBUF[18]_inst 
       (.I(PC_OBUF[18]),
        .O(PC[18]));
  OBUF \PC_OBUF[19]_inst 
       (.I(PC_OBUF[19]),
        .O(PC[19]));
  OBUF \PC_OBUF[1]_inst 
       (.I(PC_OBUF[1]),
        .O(PC[1]));
  OBUF \PC_OBUF[20]_inst 
       (.I(PC_OBUF[20]),
        .O(PC[20]));
  OBUF \PC_OBUF[21]_inst 
       (.I(PC_OBUF[21]),
        .O(PC[21]));
  OBUF \PC_OBUF[22]_inst 
       (.I(PC_OBUF[22]),
        .O(PC[22]));
  OBUF \PC_OBUF[23]_inst 
       (.I(PC_OBUF[23]),
        .O(PC[23]));
  OBUF \PC_OBUF[24]_inst 
       (.I(PC_OBUF[24]),
        .O(PC[24]));
  OBUF \PC_OBUF[25]_inst 
       (.I(PC_OBUF[25]),
        .O(PC[25]));
  OBUF \PC_OBUF[26]_inst 
       (.I(PC_OBUF[26]),
        .O(PC[26]));
  OBUF \PC_OBUF[27]_inst 
       (.I(PC_OBUF[27]),
        .O(PC[27]));
  OBUF \PC_OBUF[28]_inst 
       (.I(PC_OBUF[28]),
        .O(PC[28]));
  OBUF \PC_OBUF[29]_inst 
       (.I(PC_OBUF[29]),
        .O(PC[29]));
  OBUF \PC_OBUF[2]_inst 
       (.I(PC_OBUF[2]),
        .O(PC[2]));
  OBUF \PC_OBUF[30]_inst 
       (.I(PC_OBUF[30]),
        .O(PC[30]));
  OBUF \PC_OBUF[31]_inst 
       (.I(PC_OBUF[31]),
        .O(PC[31]));
  OBUF \PC_OBUF[3]_inst 
       (.I(PC_OBUF[3]),
        .O(PC[3]));
  OBUF \PC_OBUF[4]_inst 
       (.I(PC_OBUF[4]),
        .O(PC[4]));
  OBUF \PC_OBUF[5]_inst 
       (.I(PC_OBUF[5]),
        .O(PC[5]));
  OBUF \PC_OBUF[6]_inst 
       (.I(PC_OBUF[6]),
        .O(PC[6]));
  OBUF \PC_OBUF[7]_inst 
       (.I(PC_OBUF[7]),
        .O(PC[7]));
  OBUF \PC_OBUF[8]_inst 
       (.I(PC_OBUF[8]),
        .O(PC[8]));
  OBUF \PC_OBUF[9]_inst 
       (.I(PC_OBUF[9]),
        .O(PC[9]));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[0]),
        .Q(PC_OBUF[0]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[10]),
        .Q(PC_OBUF[10]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[11]),
        .Q(PC_OBUF[11]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[12]),
        .Q(PC_OBUF[12]),
        .R(reset_IBUF));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \PC_reg[12]_i_3 
       (.CI(\PC_reg[8]_i_3_n_0 ),
        .CO({\PC_reg[12]_i_3_n_0 ,\PC_reg[12]_i_3_n_1 ,\PC_reg[12]_i_3_n_2 ,\PC_reg[12]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(PC_next0[12:9]),
        .S(PC_OBUF[12:9]));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[13]),
        .Q(PC_OBUF[13]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[14]),
        .Q(PC_OBUF[14]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[15]),
        .Q(PC_OBUF[15]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[16]),
        .Q(PC_OBUF[16]),
        .R(reset_IBUF));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \PC_reg[16]_i_3 
       (.CI(\PC_reg[12]_i_3_n_0 ),
        .CO({\PC_reg[16]_i_3_n_0 ,\PC_reg[16]_i_3_n_1 ,\PC_reg[16]_i_3_n_2 ,\PC_reg[16]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(PC_next0[16:13]),
        .S(PC_OBUF[16:13]));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[17]),
        .Q(PC_OBUF[17]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[18]),
        .Q(PC_OBUF[18]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[19]),
        .Q(PC_OBUF[19]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[1]),
        .Q(PC_OBUF[1]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[20]),
        .Q(PC_OBUF[20]),
        .R(reset_IBUF));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \PC_reg[20]_i_3 
       (.CI(\PC_reg[16]_i_3_n_0 ),
        .CO({\PC_reg[20]_i_3_n_0 ,\PC_reg[20]_i_3_n_1 ,\PC_reg[20]_i_3_n_2 ,\PC_reg[20]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(PC_next0[20:17]),
        .S(PC_OBUF[20:17]));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[21]),
        .Q(PC_OBUF[21]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[22]),
        .Q(PC_OBUF[22]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[23]),
        .Q(PC_OBUF[23]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[24]),
        .Q(PC_OBUF[24]),
        .R(reset_IBUF));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \PC_reg[24]_i_3 
       (.CI(\PC_reg[20]_i_3_n_0 ),
        .CO({\PC_reg[24]_i_3_n_0 ,\PC_reg[24]_i_3_n_1 ,\PC_reg[24]_i_3_n_2 ,\PC_reg[24]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(PC_next0[24:21]),
        .S(PC_OBUF[24:21]));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[25]),
        .Q(PC_OBUF[25]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[26]),
        .Q(PC_OBUF[26]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[27]),
        .Q(PC_OBUF[27]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[28]),
        .Q(PC_OBUF[28]),
        .R(reset_IBUF));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \PC_reg[28]_i_3 
       (.CI(\PC_reg[24]_i_3_n_0 ),
        .CO({\PC_reg[28]_i_3_n_0 ,\PC_reg[28]_i_3_n_1 ,\PC_reg[28]_i_3_n_2 ,\PC_reg[28]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(PC_next0[28:25]),
        .S(PC_OBUF[28:25]));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[29]),
        .Q(PC_OBUF[29]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[2]),
        .Q(PC_OBUF[2]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[30]),
        .Q(PC_OBUF[30]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[31]),
        .Q(PC_OBUF[31]),
        .R(reset_IBUF));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \PC_reg[31]_i_4 
       (.CI(\PC_reg[28]_i_3_n_0 ),
        .CO({\NLW_PC_reg[31]_i_4_CO_UNCONNECTED [3:2],\PC_reg[31]_i_4_n_2 ,\PC_reg[31]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_PC_reg[31]_i_4_O_UNCONNECTED [3],PC_next0[31:29]}),
        .S({1'b0,PC_OBUF[31:29]}));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[3]),
        .Q(PC_OBUF[3]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[4]),
        .Q(PC_OBUF[4]),
        .R(reset_IBUF));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \PC_reg[4]_i_3 
       (.CI(1'b0),
        .CO({\PC_reg[4]_i_3_n_0 ,\PC_reg[4]_i_3_n_1 ,\PC_reg[4]_i_3_n_2 ,\PC_reg[4]_i_3_n_3 }),
        .CYINIT(PC_OBUF[0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(PC_next0[4:1]),
        .S(PC_OBUF[4:1]));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[5]),
        .Q(PC_OBUF[5]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[6]),
        .Q(PC_OBUF[6]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[7]),
        .Q(PC_OBUF[7]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[8]),
        .Q(PC_OBUF[8]),
        .R(reset_IBUF));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \PC_reg[8]_i_3 
       (.CI(\PC_reg[4]_i_3_n_0 ),
        .CO({\PC_reg[8]_i_3_n_0 ,\PC_reg[8]_i_3_n_1 ,\PC_reg[8]_i_3_n_2 ,\PC_reg[8]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(PC_next0[8:5]),
        .S(PC_OBUF[8:5]));
  FDRE #(
    .INIT(1'b0)) 
    \PC_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\PC[31]_i_1_n_0 ),
        .D(PC_next[9]),
        .Q(PC_OBUF[9]),
        .R(reset_IBUF));
  IBUF btb_hit_IBUF_inst
       (.I(btb_hit),
        .O(btb_hit_IBUF));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  IBUF fix_IBUF_inst
       (.I(fix),
        .O(fix_IBUF));
  IBUF \fix_addr_IBUF[0]_inst 
       (.I(fix_addr[0]),
        .O(fix_addr_IBUF[0]));
  IBUF \fix_addr_IBUF[10]_inst 
       (.I(fix_addr[10]),
        .O(fix_addr_IBUF[10]));
  IBUF \fix_addr_IBUF[11]_inst 
       (.I(fix_addr[11]),
        .O(fix_addr_IBUF[11]));
  IBUF \fix_addr_IBUF[12]_inst 
       (.I(fix_addr[12]),
        .O(fix_addr_IBUF[12]));
  IBUF \fix_addr_IBUF[13]_inst 
       (.I(fix_addr[13]),
        .O(fix_addr_IBUF[13]));
  IBUF \fix_addr_IBUF[14]_inst 
       (.I(fix_addr[14]),
        .O(fix_addr_IBUF[14]));
  IBUF \fix_addr_IBUF[15]_inst 
       (.I(fix_addr[15]),
        .O(fix_addr_IBUF[15]));
  IBUF \fix_addr_IBUF[16]_inst 
       (.I(fix_addr[16]),
        .O(fix_addr_IBUF[16]));
  IBUF \fix_addr_IBUF[17]_inst 
       (.I(fix_addr[17]),
        .O(fix_addr_IBUF[17]));
  IBUF \fix_addr_IBUF[18]_inst 
       (.I(fix_addr[18]),
        .O(fix_addr_IBUF[18]));
  IBUF \fix_addr_IBUF[19]_inst 
       (.I(fix_addr[19]),
        .O(fix_addr_IBUF[19]));
  IBUF \fix_addr_IBUF[1]_inst 
       (.I(fix_addr[1]),
        .O(fix_addr_IBUF[1]));
  IBUF \fix_addr_IBUF[20]_inst 
       (.I(fix_addr[20]),
        .O(fix_addr_IBUF[20]));
  IBUF \fix_addr_IBUF[21]_inst 
       (.I(fix_addr[21]),
        .O(fix_addr_IBUF[21]));
  IBUF \fix_addr_IBUF[22]_inst 
       (.I(fix_addr[22]),
        .O(fix_addr_IBUF[22]));
  IBUF \fix_addr_IBUF[23]_inst 
       (.I(fix_addr[23]),
        .O(fix_addr_IBUF[23]));
  IBUF \fix_addr_IBUF[24]_inst 
       (.I(fix_addr[24]),
        .O(fix_addr_IBUF[24]));
  IBUF \fix_addr_IBUF[25]_inst 
       (.I(fix_addr[25]),
        .O(fix_addr_IBUF[25]));
  IBUF \fix_addr_IBUF[26]_inst 
       (.I(fix_addr[26]),
        .O(fix_addr_IBUF[26]));
  IBUF \fix_addr_IBUF[27]_inst 
       (.I(fix_addr[27]),
        .O(fix_addr_IBUF[27]));
  IBUF \fix_addr_IBUF[28]_inst 
       (.I(fix_addr[28]),
        .O(fix_addr_IBUF[28]));
  IBUF \fix_addr_IBUF[29]_inst 
       (.I(fix_addr[29]),
        .O(fix_addr_IBUF[29]));
  IBUF \fix_addr_IBUF[2]_inst 
       (.I(fix_addr[2]),
        .O(fix_addr_IBUF[2]));
  IBUF \fix_addr_IBUF[30]_inst 
       (.I(fix_addr[30]),
        .O(fix_addr_IBUF[30]));
  IBUF \fix_addr_IBUF[31]_inst 
       (.I(fix_addr[31]),
        .O(fix_addr_IBUF[31]));
  IBUF \fix_addr_IBUF[3]_inst 
       (.I(fix_addr[3]),
        .O(fix_addr_IBUF[3]));
  IBUF \fix_addr_IBUF[4]_inst 
       (.I(fix_addr[4]),
        .O(fix_addr_IBUF[4]));
  IBUF \fix_addr_IBUF[5]_inst 
       (.I(fix_addr[5]),
        .O(fix_addr_IBUF[5]));
  IBUF \fix_addr_IBUF[6]_inst 
       (.I(fix_addr[6]),
        .O(fix_addr_IBUF[6]));
  IBUF \fix_addr_IBUF[7]_inst 
       (.I(fix_addr[7]),
        .O(fix_addr_IBUF[7]));
  IBUF \fix_addr_IBUF[8]_inst 
       (.I(fix_addr[8]),
        .O(fix_addr_IBUF[8]));
  IBUF \fix_addr_IBUF[9]_inst 
       (.I(fix_addr[9]),
        .O(fix_addr_IBUF[9]));
  IBUF freeze_IBUF_inst
       (.I(freeze),
        .O(freeze_IBUF));
  IBUF pht_hit_IBUF_inst
       (.I(pht_hit),
        .O(pht_hit_IBUF));
  IBUF \predicted_addr_IBUF[0]_inst 
       (.I(predicted_addr[0]),
        .O(predicted_addr_IBUF[0]));
  IBUF \predicted_addr_IBUF[10]_inst 
       (.I(predicted_addr[10]),
        .O(predicted_addr_IBUF[10]));
  IBUF \predicted_addr_IBUF[11]_inst 
       (.I(predicted_addr[11]),
        .O(predicted_addr_IBUF[11]));
  IBUF \predicted_addr_IBUF[12]_inst 
       (.I(predicted_addr[12]),
        .O(predicted_addr_IBUF[12]));
  IBUF \predicted_addr_IBUF[13]_inst 
       (.I(predicted_addr[13]),
        .O(predicted_addr_IBUF[13]));
  IBUF \predicted_addr_IBUF[14]_inst 
       (.I(predicted_addr[14]),
        .O(predicted_addr_IBUF[14]));
  IBUF \predicted_addr_IBUF[15]_inst 
       (.I(predicted_addr[15]),
        .O(predicted_addr_IBUF[15]));
  IBUF \predicted_addr_IBUF[16]_inst 
       (.I(predicted_addr[16]),
        .O(predicted_addr_IBUF[16]));
  IBUF \predicted_addr_IBUF[17]_inst 
       (.I(predicted_addr[17]),
        .O(predicted_addr_IBUF[17]));
  IBUF \predicted_addr_IBUF[18]_inst 
       (.I(predicted_addr[18]),
        .O(predicted_addr_IBUF[18]));
  IBUF \predicted_addr_IBUF[19]_inst 
       (.I(predicted_addr[19]),
        .O(predicted_addr_IBUF[19]));
  IBUF \predicted_addr_IBUF[1]_inst 
       (.I(predicted_addr[1]),
        .O(predicted_addr_IBUF[1]));
  IBUF \predicted_addr_IBUF[20]_inst 
       (.I(predicted_addr[20]),
        .O(predicted_addr_IBUF[20]));
  IBUF \predicted_addr_IBUF[21]_inst 
       (.I(predicted_addr[21]),
        .O(predicted_addr_IBUF[21]));
  IBUF \predicted_addr_IBUF[22]_inst 
       (.I(predicted_addr[22]),
        .O(predicted_addr_IBUF[22]));
  IBUF \predicted_addr_IBUF[23]_inst 
       (.I(predicted_addr[23]),
        .O(predicted_addr_IBUF[23]));
  IBUF \predicted_addr_IBUF[24]_inst 
       (.I(predicted_addr[24]),
        .O(predicted_addr_IBUF[24]));
  IBUF \predicted_addr_IBUF[25]_inst 
       (.I(predicted_addr[25]),
        .O(predicted_addr_IBUF[25]));
  IBUF \predicted_addr_IBUF[26]_inst 
       (.I(predicted_addr[26]),
        .O(predicted_addr_IBUF[26]));
  IBUF \predicted_addr_IBUF[27]_inst 
       (.I(predicted_addr[27]),
        .O(predicted_addr_IBUF[27]));
  IBUF \predicted_addr_IBUF[28]_inst 
       (.I(predicted_addr[28]),
        .O(predicted_addr_IBUF[28]));
  IBUF \predicted_addr_IBUF[29]_inst 
       (.I(predicted_addr[29]),
        .O(predicted_addr_IBUF[29]));
  IBUF \predicted_addr_IBUF[2]_inst 
       (.I(predicted_addr[2]),
        .O(predicted_addr_IBUF[2]));
  IBUF \predicted_addr_IBUF[30]_inst 
       (.I(predicted_addr[30]),
        .O(predicted_addr_IBUF[30]));
  IBUF \predicted_addr_IBUF[31]_inst 
       (.I(predicted_addr[31]),
        .O(predicted_addr_IBUF[31]));
  IBUF \predicted_addr_IBUF[3]_inst 
       (.I(predicted_addr[3]),
        .O(predicted_addr_IBUF[3]));
  IBUF \predicted_addr_IBUF[4]_inst 
       (.I(predicted_addr[4]),
        .O(predicted_addr_IBUF[4]));
  IBUF \predicted_addr_IBUF[5]_inst 
       (.I(predicted_addr[5]),
        .O(predicted_addr_IBUF[5]));
  IBUF \predicted_addr_IBUF[6]_inst 
       (.I(predicted_addr[6]),
        .O(predicted_addr_IBUF[6]));
  IBUF \predicted_addr_IBUF[7]_inst 
       (.I(predicted_addr[7]),
        .O(predicted_addr_IBUF[7]));
  IBUF \predicted_addr_IBUF[8]_inst 
       (.I(predicted_addr[8]),
        .O(predicted_addr_IBUF[8]));
  IBUF \predicted_addr_IBUF[9]_inst 
       (.I(predicted_addr[9]),
        .O(predicted_addr_IBUF[9]));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  IBUF \reset_addr_IBUF[0]_inst 
       (.I(reset_addr[0]),
        .O(reset_addr_IBUF[0]));
  IBUF \reset_addr_IBUF[10]_inst 
       (.I(reset_addr[10]),
        .O(reset_addr_IBUF[10]));
  IBUF \reset_addr_IBUF[11]_inst 
       (.I(reset_addr[11]),
        .O(reset_addr_IBUF[11]));
  IBUF \reset_addr_IBUF[12]_inst 
       (.I(reset_addr[12]),
        .O(reset_addr_IBUF[12]));
  IBUF \reset_addr_IBUF[13]_inst 
       (.I(reset_addr[13]),
        .O(reset_addr_IBUF[13]));
  IBUF \reset_addr_IBUF[14]_inst 
       (.I(reset_addr[14]),
        .O(reset_addr_IBUF[14]));
  IBUF \reset_addr_IBUF[15]_inst 
       (.I(reset_addr[15]),
        .O(reset_addr_IBUF[15]));
  IBUF \reset_addr_IBUF[16]_inst 
       (.I(reset_addr[16]),
        .O(reset_addr_IBUF[16]));
  IBUF \reset_addr_IBUF[17]_inst 
       (.I(reset_addr[17]),
        .O(reset_addr_IBUF[17]));
  IBUF \reset_addr_IBUF[18]_inst 
       (.I(reset_addr[18]),
        .O(reset_addr_IBUF[18]));
  IBUF \reset_addr_IBUF[19]_inst 
       (.I(reset_addr[19]),
        .O(reset_addr_IBUF[19]));
  IBUF \reset_addr_IBUF[1]_inst 
       (.I(reset_addr[1]),
        .O(reset_addr_IBUF[1]));
  IBUF \reset_addr_IBUF[20]_inst 
       (.I(reset_addr[20]),
        .O(reset_addr_IBUF[20]));
  IBUF \reset_addr_IBUF[21]_inst 
       (.I(reset_addr[21]),
        .O(reset_addr_IBUF[21]));
  IBUF \reset_addr_IBUF[22]_inst 
       (.I(reset_addr[22]),
        .O(reset_addr_IBUF[22]));
  IBUF \reset_addr_IBUF[23]_inst 
       (.I(reset_addr[23]),
        .O(reset_addr_IBUF[23]));
  IBUF \reset_addr_IBUF[24]_inst 
       (.I(reset_addr[24]),
        .O(reset_addr_IBUF[24]));
  IBUF \reset_addr_IBUF[25]_inst 
       (.I(reset_addr[25]),
        .O(reset_addr_IBUF[25]));
  IBUF \reset_addr_IBUF[26]_inst 
       (.I(reset_addr[26]),
        .O(reset_addr_IBUF[26]));
  IBUF \reset_addr_IBUF[27]_inst 
       (.I(reset_addr[27]),
        .O(reset_addr_IBUF[27]));
  IBUF \reset_addr_IBUF[28]_inst 
       (.I(reset_addr[28]),
        .O(reset_addr_IBUF[28]));
  IBUF \reset_addr_IBUF[29]_inst 
       (.I(reset_addr[29]),
        .O(reset_addr_IBUF[29]));
  IBUF \reset_addr_IBUF[2]_inst 
       (.I(reset_addr[2]),
        .O(reset_addr_IBUF[2]));
  IBUF \reset_addr_IBUF[30]_inst 
       (.I(reset_addr[30]),
        .O(reset_addr_IBUF[30]));
  IBUF \reset_addr_IBUF[31]_inst 
       (.I(reset_addr[31]),
        .O(reset_addr_IBUF[31]));
  IBUF \reset_addr_IBUF[3]_inst 
       (.I(reset_addr[3]),
        .O(reset_addr_IBUF[3]));
  IBUF \reset_addr_IBUF[4]_inst 
       (.I(reset_addr[4]),
        .O(reset_addr_IBUF[4]));
  IBUF \reset_addr_IBUF[5]_inst 
       (.I(reset_addr[5]),
        .O(reset_addr_IBUF[5]));
  IBUF \reset_addr_IBUF[6]_inst 
       (.I(reset_addr[6]),
        .O(reset_addr_IBUF[6]));
  IBUF \reset_addr_IBUF[7]_inst 
       (.I(reset_addr[7]),
        .O(reset_addr_IBUF[7]));
  IBUF \reset_addr_IBUF[8]_inst 
       (.I(reset_addr[8]),
        .O(reset_addr_IBUF[8]));
  IBUF \reset_addr_IBUF[9]_inst 
       (.I(reset_addr[9]),
        .O(reset_addr_IBUF[9]));
  IBUF reset_pipeline_IBUF_inst
       (.I(reset_pipeline),
        .O(reset_pipeline_IBUF));
endmodule
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
