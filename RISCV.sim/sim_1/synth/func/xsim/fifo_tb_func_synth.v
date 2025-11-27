// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
// Date        : Tue Nov 25 20:10:35 2025
// Host        : voidknight-XPS-13-7390 running 64-bit Ubuntu 24.04.3 LTS
// Command     : write_verilog -mode funcsim -nolib -force -file
//               /home/voidknight/RISCV/RISCV.sim/sim_1/synth/func/xsim/fifo_tb_func_synth.v
// Design      : fifo_buffer
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-2L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* DW = "31" *) (* SIZE = "32" *) 
(* NotValidForBitStream *)
module fifo_buffer
   (clk,
    reset,
    write,
    read,
    full,
    empty,
    wr_data,
    rd_data);
  input clk;
  input reset;
  input write;
  input read;
  output full;
  output empty;
  input [31:0]wr_data;
  output [31:0]rd_data;

  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire empty;
  wire empty_OBUF;
  wire full;
  wire full_OBUF;
  wire full_OBUF_inst_i_2_n_0;
  wire full_OBUF_inst_i_3_n_0;
  wire p_0_in;
  wire [5:0]p_0_in__0;
  wire [5:5]p_0_in__1;
  wire p_1_in;
  wire [31:0]rd_data;
  wire [31:0]rd_data_OBUF;
  wire rd_ptr0;
  wire \rd_ptr[0]_i_1_n_0 ;
  wire \rd_ptr[1]_i_1_n_0 ;
  wire \rd_ptr[2]_i_1_n_0 ;
  wire \rd_ptr[3]_i_1_n_0 ;
  wire \rd_ptr[4]_i_1_n_0 ;
  wire \rd_ptr_reg_n_0_[0] ;
  wire \rd_ptr_reg_n_0_[1] ;
  wire \rd_ptr_reg_n_0_[2] ;
  wire \rd_ptr_reg_n_0_[3] ;
  wire \rd_ptr_reg_n_0_[4] ;
  wire read;
  wire read_IBUF;
  wire reset;
  wire reset_IBUF;
  wire [31:0]wr_data;
  wire [31:0]wr_data_IBUF;
  wire wr_ptr1;
  wire \wr_ptr[5]_i_1_n_0 ;
  wire \wr_ptr[5]_i_3_n_0 ;
  wire \wr_ptr_reg_n_0_[0] ;
  wire \wr_ptr_reg_n_0_[1] ;
  wire \wr_ptr_reg_n_0_[2] ;
  wire \wr_ptr_reg_n_0_[3] ;
  wire \wr_ptr_reg_n_0_[4] ;
  wire write;
  wire write_IBUF;
  wire [1:0]NLW_mem_array_reg_DOPADOP_UNCONNECTED;
  wire [1:0]NLW_mem_array_reg_DOPBDOP_UNCONNECTED;

  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF empty_OBUF_inst
       (.I(empty_OBUF),
        .O(empty));
  LUT6 #(
    .INIT(64'h2002000000002002)) 
    empty_OBUF_inst_i_1
       (.I0(full_OBUF_inst_i_2_n_0),
        .I1(full_OBUF_inst_i_3_n_0),
        .I2(\rd_ptr_reg_n_0_[2] ),
        .I3(\wr_ptr_reg_n_0_[2] ),
        .I4(\rd_ptr_reg_n_0_[1] ),
        .I5(\wr_ptr_reg_n_0_[1] ),
        .O(empty_OBUF));
  OBUF full_OBUF_inst
       (.I(full_OBUF),
        .O(full));
  LUT6 #(
    .INIT(64'h1001000000001001)) 
    full_OBUF_inst_i_1
       (.I0(full_OBUF_inst_i_2_n_0),
        .I1(full_OBUF_inst_i_3_n_0),
        .I2(\rd_ptr_reg_n_0_[2] ),
        .I3(\wr_ptr_reg_n_0_[2] ),
        .I4(\rd_ptr_reg_n_0_[1] ),
        .I5(\wr_ptr_reg_n_0_[1] ),
        .O(full_OBUF));
  LUT2 #(
    .INIT(4'h9)) 
    full_OBUF_inst_i_2
       (.I0(p_0_in),
        .I1(p_1_in),
        .O(full_OBUF_inst_i_2_n_0));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    full_OBUF_inst_i_3
       (.I0(\rd_ptr_reg_n_0_[4] ),
        .I1(\wr_ptr_reg_n_0_[4] ),
        .I2(\rd_ptr_reg_n_0_[3] ),
        .I3(\wr_ptr_reg_n_0_[3] ),
        .I4(\wr_ptr_reg_n_0_[0] ),
        .I5(\rd_ptr_reg_n_0_[0] ),
        .O(full_OBUF_inst_i_3_n_0));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d32" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d32" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "1024" *) 
  (* RTL_RAM_NAME = "fifo_buffer/mem_array_reg" *) 
  (* RTL_RAM_STYLE = "auto" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "511" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "31" *) 
  RAMB18E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .INIT_FILE("NONE"),
    .RAM_MODE("SDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(36),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(0),
    .WRITE_WIDTH_B(36)) 
    mem_array_reg
       (.ADDRARDADDR({1'b0,1'b0,1'b0,1'b0,\rd_ptr_reg_n_0_[4] ,\rd_ptr_reg_n_0_[3] ,\rd_ptr_reg_n_0_[2] ,\rd_ptr_reg_n_0_[1] ,\rd_ptr_reg_n_0_[0] ,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,\wr_ptr_reg_n_0_[4] ,\wr_ptr_reg_n_0_[3] ,\wr_ptr_reg_n_0_[2] ,\wr_ptr_reg_n_0_[1] ,\wr_ptr_reg_n_0_[0] ,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CLKARDCLK(clk_IBUF_BUFG),
        .CLKBWRCLK(clk_IBUF_BUFG),
        .DIADI(wr_data_IBUF[15:0]),
        .DIBDI(wr_data_IBUF[31:16]),
        .DIPADIP({1'b1,1'b1}),
        .DIPBDIP({1'b1,1'b1}),
        .DOADO(rd_data_OBUF[15:0]),
        .DOBDO(rd_data_OBUF[31:16]),
        .DOPADOP(NLW_mem_array_reg_DOPADOP_UNCONNECTED[1:0]),
        .DOPBDOP(NLW_mem_array_reg_DOPBDOP_UNCONNECTED[1:0]),
        .ENARDEN(1'b1),
        .ENBWREN(write_IBUF),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .WEA({1'b0,1'b0}),
        .WEBWE({wr_ptr1,wr_ptr1,wr_ptr1,wr_ptr1}));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF6FF6)) 
    mem_array_reg_i_1
       (.I0(\wr_ptr_reg_n_0_[1] ),
        .I1(\rd_ptr_reg_n_0_[1] ),
        .I2(\wr_ptr_reg_n_0_[2] ),
        .I3(\rd_ptr_reg_n_0_[2] ),
        .I4(full_OBUF_inst_i_3_n_0),
        .I5(full_OBUF_inst_i_2_n_0),
        .O(wr_ptr1));
  OBUF \rd_data_OBUF[0]_inst 
       (.I(rd_data_OBUF[0]),
        .O(rd_data[0]));
  OBUF \rd_data_OBUF[10]_inst 
       (.I(rd_data_OBUF[10]),
        .O(rd_data[10]));
  OBUF \rd_data_OBUF[11]_inst 
       (.I(rd_data_OBUF[11]),
        .O(rd_data[11]));
  OBUF \rd_data_OBUF[12]_inst 
       (.I(rd_data_OBUF[12]),
        .O(rd_data[12]));
  OBUF \rd_data_OBUF[13]_inst 
       (.I(rd_data_OBUF[13]),
        .O(rd_data[13]));
  OBUF \rd_data_OBUF[14]_inst 
       (.I(rd_data_OBUF[14]),
        .O(rd_data[14]));
  OBUF \rd_data_OBUF[15]_inst 
       (.I(rd_data_OBUF[15]),
        .O(rd_data[15]));
  OBUF \rd_data_OBUF[16]_inst 
       (.I(rd_data_OBUF[16]),
        .O(rd_data[16]));
  OBUF \rd_data_OBUF[17]_inst 
       (.I(rd_data_OBUF[17]),
        .O(rd_data[17]));
  OBUF \rd_data_OBUF[18]_inst 
       (.I(rd_data_OBUF[18]),
        .O(rd_data[18]));
  OBUF \rd_data_OBUF[19]_inst 
       (.I(rd_data_OBUF[19]),
        .O(rd_data[19]));
  OBUF \rd_data_OBUF[1]_inst 
       (.I(rd_data_OBUF[1]),
        .O(rd_data[1]));
  OBUF \rd_data_OBUF[20]_inst 
       (.I(rd_data_OBUF[20]),
        .O(rd_data[20]));
  OBUF \rd_data_OBUF[21]_inst 
       (.I(rd_data_OBUF[21]),
        .O(rd_data[21]));
  OBUF \rd_data_OBUF[22]_inst 
       (.I(rd_data_OBUF[22]),
        .O(rd_data[22]));
  OBUF \rd_data_OBUF[23]_inst 
       (.I(rd_data_OBUF[23]),
        .O(rd_data[23]));
  OBUF \rd_data_OBUF[24]_inst 
       (.I(rd_data_OBUF[24]),
        .O(rd_data[24]));
  OBUF \rd_data_OBUF[25]_inst 
       (.I(rd_data_OBUF[25]),
        .O(rd_data[25]));
  OBUF \rd_data_OBUF[26]_inst 
       (.I(rd_data_OBUF[26]),
        .O(rd_data[26]));
  OBUF \rd_data_OBUF[27]_inst 
       (.I(rd_data_OBUF[27]),
        .O(rd_data[27]));
  OBUF \rd_data_OBUF[28]_inst 
       (.I(rd_data_OBUF[28]),
        .O(rd_data[28]));
  OBUF \rd_data_OBUF[29]_inst 
       (.I(rd_data_OBUF[29]),
        .O(rd_data[29]));
  OBUF \rd_data_OBUF[2]_inst 
       (.I(rd_data_OBUF[2]),
        .O(rd_data[2]));
  OBUF \rd_data_OBUF[30]_inst 
       (.I(rd_data_OBUF[30]),
        .O(rd_data[30]));
  OBUF \rd_data_OBUF[31]_inst 
       (.I(rd_data_OBUF[31]),
        .O(rd_data[31]));
  OBUF \rd_data_OBUF[3]_inst 
       (.I(rd_data_OBUF[3]),
        .O(rd_data[3]));
  OBUF \rd_data_OBUF[4]_inst 
       (.I(rd_data_OBUF[4]),
        .O(rd_data[4]));
  OBUF \rd_data_OBUF[5]_inst 
       (.I(rd_data_OBUF[5]),
        .O(rd_data[5]));
  OBUF \rd_data_OBUF[6]_inst 
       (.I(rd_data_OBUF[6]),
        .O(rd_data[6]));
  OBUF \rd_data_OBUF[7]_inst 
       (.I(rd_data_OBUF[7]),
        .O(rd_data[7]));
  OBUF \rd_data_OBUF[8]_inst 
       (.I(rd_data_OBUF[8]),
        .O(rd_data[8]));
  OBUF \rd_data_OBUF[9]_inst 
       (.I(rd_data_OBUF[9]),
        .O(rd_data[9]));
  LUT1 #(
    .INIT(2'h1)) 
    \rd_ptr[0]_i_1 
       (.I0(\rd_ptr_reg_n_0_[0] ),
        .O(\rd_ptr[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_ptr[1]_i_1 
       (.I0(\rd_ptr_reg_n_0_[0] ),
        .I1(\rd_ptr_reg_n_0_[1] ),
        .O(\rd_ptr[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr[2]_i_1 
       (.I0(\rd_ptr_reg_n_0_[1] ),
        .I1(\rd_ptr_reg_n_0_[0] ),
        .I2(\rd_ptr_reg_n_0_[2] ),
        .O(\rd_ptr[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rd_ptr[3]_i_1 
       (.I0(\rd_ptr_reg_n_0_[2] ),
        .I1(\rd_ptr_reg_n_0_[0] ),
        .I2(\rd_ptr_reg_n_0_[1] ),
        .I3(\rd_ptr_reg_n_0_[3] ),
        .O(\rd_ptr[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \rd_ptr[4]_i_1 
       (.I0(\rd_ptr_reg_n_0_[3] ),
        .I1(\rd_ptr_reg_n_0_[1] ),
        .I2(\rd_ptr_reg_n_0_[0] ),
        .I3(\rd_ptr_reg_n_0_[2] ),
        .I4(\rd_ptr_reg_n_0_[4] ),
        .O(\rd_ptr[4]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFF60000)) 
    \rd_ptr[5]_i_1 
       (.I0(p_0_in),
        .I1(p_1_in),
        .I2(full_OBUF_inst_i_3_n_0),
        .I3(\wr_ptr[5]_i_3_n_0 ),
        .I4(read_IBUF),
        .O(rd_ptr0));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \rd_ptr[5]_i_2 
       (.I0(\rd_ptr_reg_n_0_[4] ),
        .I1(\rd_ptr_reg_n_0_[2] ),
        .I2(\rd_ptr_reg_n_0_[0] ),
        .I3(\rd_ptr_reg_n_0_[1] ),
        .I4(\rd_ptr_reg_n_0_[3] ),
        .I5(p_0_in),
        .O(p_0_in__1));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(rd_ptr0),
        .D(\rd_ptr[0]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[0] ),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(rd_ptr0),
        .D(\rd_ptr[1]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[1] ),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(rd_ptr0),
        .D(\rd_ptr[2]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[2] ),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(rd_ptr0),
        .D(\rd_ptr[3]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[3] ),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(rd_ptr0),
        .D(\rd_ptr[4]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[4] ),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(rd_ptr0),
        .D(p_0_in__1),
        .Q(p_0_in),
        .R(reset_IBUF));
  IBUF read_IBUF_inst
       (.I(read),
        .O(read_IBUF));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  IBUF \wr_data_IBUF[0]_inst 
       (.I(wr_data[0]),
        .O(wr_data_IBUF[0]));
  IBUF \wr_data_IBUF[10]_inst 
       (.I(wr_data[10]),
        .O(wr_data_IBUF[10]));
  IBUF \wr_data_IBUF[11]_inst 
       (.I(wr_data[11]),
        .O(wr_data_IBUF[11]));
  IBUF \wr_data_IBUF[12]_inst 
       (.I(wr_data[12]),
        .O(wr_data_IBUF[12]));
  IBUF \wr_data_IBUF[13]_inst 
       (.I(wr_data[13]),
        .O(wr_data_IBUF[13]));
  IBUF \wr_data_IBUF[14]_inst 
       (.I(wr_data[14]),
        .O(wr_data_IBUF[14]));
  IBUF \wr_data_IBUF[15]_inst 
       (.I(wr_data[15]),
        .O(wr_data_IBUF[15]));
  IBUF \wr_data_IBUF[16]_inst 
       (.I(wr_data[16]),
        .O(wr_data_IBUF[16]));
  IBUF \wr_data_IBUF[17]_inst 
       (.I(wr_data[17]),
        .O(wr_data_IBUF[17]));
  IBUF \wr_data_IBUF[18]_inst 
       (.I(wr_data[18]),
        .O(wr_data_IBUF[18]));
  IBUF \wr_data_IBUF[19]_inst 
       (.I(wr_data[19]),
        .O(wr_data_IBUF[19]));
  IBUF \wr_data_IBUF[1]_inst 
       (.I(wr_data[1]),
        .O(wr_data_IBUF[1]));
  IBUF \wr_data_IBUF[20]_inst 
       (.I(wr_data[20]),
        .O(wr_data_IBUF[20]));
  IBUF \wr_data_IBUF[21]_inst 
       (.I(wr_data[21]),
        .O(wr_data_IBUF[21]));
  IBUF \wr_data_IBUF[22]_inst 
       (.I(wr_data[22]),
        .O(wr_data_IBUF[22]));
  IBUF \wr_data_IBUF[23]_inst 
       (.I(wr_data[23]),
        .O(wr_data_IBUF[23]));
  IBUF \wr_data_IBUF[24]_inst 
       (.I(wr_data[24]),
        .O(wr_data_IBUF[24]));
  IBUF \wr_data_IBUF[25]_inst 
       (.I(wr_data[25]),
        .O(wr_data_IBUF[25]));
  IBUF \wr_data_IBUF[26]_inst 
       (.I(wr_data[26]),
        .O(wr_data_IBUF[26]));
  IBUF \wr_data_IBUF[27]_inst 
       (.I(wr_data[27]),
        .O(wr_data_IBUF[27]));
  IBUF \wr_data_IBUF[28]_inst 
       (.I(wr_data[28]),
        .O(wr_data_IBUF[28]));
  IBUF \wr_data_IBUF[29]_inst 
       (.I(wr_data[29]),
        .O(wr_data_IBUF[29]));
  IBUF \wr_data_IBUF[2]_inst 
       (.I(wr_data[2]),
        .O(wr_data_IBUF[2]));
  IBUF \wr_data_IBUF[30]_inst 
       (.I(wr_data[30]),
        .O(wr_data_IBUF[30]));
  IBUF \wr_data_IBUF[31]_inst 
       (.I(wr_data[31]),
        .O(wr_data_IBUF[31]));
  IBUF \wr_data_IBUF[3]_inst 
       (.I(wr_data[3]),
        .O(wr_data_IBUF[3]));
  IBUF \wr_data_IBUF[4]_inst 
       (.I(wr_data[4]),
        .O(wr_data_IBUF[4]));
  IBUF \wr_data_IBUF[5]_inst 
       (.I(wr_data[5]),
        .O(wr_data_IBUF[5]));
  IBUF \wr_data_IBUF[6]_inst 
       (.I(wr_data[6]),
        .O(wr_data_IBUF[6]));
  IBUF \wr_data_IBUF[7]_inst 
       (.I(wr_data[7]),
        .O(wr_data_IBUF[7]));
  IBUF \wr_data_IBUF[8]_inst 
       (.I(wr_data[8]),
        .O(wr_data_IBUF[8]));
  IBUF \wr_data_IBUF[9]_inst 
       (.I(wr_data[9]),
        .O(wr_data_IBUF[9]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \wr_ptr[0]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0] ),
        .O(p_0_in__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_ptr[1]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0] ),
        .I1(\wr_ptr_reg_n_0_[1] ),
        .O(p_0_in__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \wr_ptr[2]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1] ),
        .I1(\wr_ptr_reg_n_0_[0] ),
        .I2(\wr_ptr_reg_n_0_[2] ),
        .O(p_0_in__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \wr_ptr[3]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2] ),
        .I1(\wr_ptr_reg_n_0_[0] ),
        .I2(\wr_ptr_reg_n_0_[1] ),
        .I3(\wr_ptr_reg_n_0_[3] ),
        .O(p_0_in__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \wr_ptr[4]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3] ),
        .I1(\wr_ptr_reg_n_0_[1] ),
        .I2(\wr_ptr_reg_n_0_[0] ),
        .I3(\wr_ptr_reg_n_0_[2] ),
        .I4(\wr_ptr_reg_n_0_[4] ),
        .O(p_0_in__0[4]));
  LUT5 #(
    .INIT(32'hFFF90000)) 
    \wr_ptr[5]_i_1 
       (.I0(p_0_in),
        .I1(p_1_in),
        .I2(full_OBUF_inst_i_3_n_0),
        .I3(\wr_ptr[5]_i_3_n_0 ),
        .I4(write_IBUF),
        .O(\wr_ptr[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \wr_ptr[5]_i_2 
       (.I0(\wr_ptr_reg_n_0_[4] ),
        .I1(\wr_ptr_reg_n_0_[2] ),
        .I2(\wr_ptr_reg_n_0_[0] ),
        .I3(\wr_ptr_reg_n_0_[1] ),
        .I4(\wr_ptr_reg_n_0_[3] ),
        .I5(p_1_in),
        .O(p_0_in__0[5]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h6FF6)) 
    \wr_ptr[5]_i_3 
       (.I0(\wr_ptr_reg_n_0_[1] ),
        .I1(\rd_ptr_reg_n_0_[1] ),
        .I2(\wr_ptr_reg_n_0_[2] ),
        .I3(\rd_ptr_reg_n_0_[2] ),
        .O(\wr_ptr[5]_i_3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\wr_ptr[5]_i_1_n_0 ),
        .D(p_0_in__0[0]),
        .Q(\wr_ptr_reg_n_0_[0] ),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\wr_ptr[5]_i_1_n_0 ),
        .D(p_0_in__0[1]),
        .Q(\wr_ptr_reg_n_0_[1] ),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\wr_ptr[5]_i_1_n_0 ),
        .D(p_0_in__0[2]),
        .Q(\wr_ptr_reg_n_0_[2] ),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\wr_ptr[5]_i_1_n_0 ),
        .D(p_0_in__0[3]),
        .Q(\wr_ptr_reg_n_0_[3] ),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\wr_ptr[5]_i_1_n_0 ),
        .D(p_0_in__0[4]),
        .Q(\wr_ptr_reg_n_0_[4] ),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\wr_ptr[5]_i_1_n_0 ),
        .D(p_0_in__0[5]),
        .Q(p_1_in),
        .R(reset_IBUF));
  IBUF write_IBUF_inst
       (.I(write),
        .O(write_IBUF));
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
