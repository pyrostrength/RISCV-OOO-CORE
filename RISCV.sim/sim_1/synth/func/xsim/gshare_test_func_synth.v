// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
// Date        : Sun Nov 30 17:10:56 2025
// Host        : voidknight-XPS-13-7390 running 64-bit Ubuntu 24.04.3 LTS
// Command     : write_verilog -mode funcsim -nolib -force -file
//               /home/voidknight/RISCV/RISCV.sim/sim_1/synth/func/xsim/gshare_test_func_synth.v
// Design      : gshare_predictor
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-2L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* I = "7" *) (* WIDTH = "31" *) 
(* NotValidForBitStream *)
module gshare_predictor
   (clk,
    reset,
    pc_lowerbits,
    ghr_restore,
    update,
    restore,
    branch_taken,
    index,
    ghr_checkpoint);
  input clk;
  input reset;
  input [7:0]pc_lowerbits;
  input [7:0]ghr_restore;
  input update;
  input restore;
  input branch_taken;
  output [7:0]index;
  output [7:0]ghr_checkpoint;

  wire branch_taken;
  wire branch_taken_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire \ghr[0]_i_1_n_0 ;
  wire [7:0]ghr_checkpoint;
  wire [7:0]ghr_checkpoint_OBUF;
  wire [7:0]ghr_restore;
  wire [7:0]ghr_restore_IBUF;
  wire [7:0]index;
  wire [7:0]index_OBUF;
  wire [7:0]pc_lowerbits;
  wire [7:0]pc_lowerbits_IBUF;
  wire reset;
  wire reset_IBUF;
  wire restore;
  wire restore_IBUF;
  wire update;
  wire update_IBUF;

  IBUF branch_taken_IBUF_inst
       (.I(branch_taken),
        .O(branch_taken_IBUF));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  LUT6 #(
    .INIT(64'h00000000FEF20E02)) 
    \ghr[0]_i_1 
       (.I0(ghr_checkpoint_OBUF[0]),
        .I1(update_IBUF),
        .I2(restore_IBUF),
        .I3(branch_taken_IBUF),
        .I4(ghr_restore_IBUF[0]),
        .I5(reset_IBUF),
        .O(\ghr[0]_i_1_n_0 ));
  OBUF \ghr_checkpoint_OBUF[0]_inst 
       (.I(ghr_checkpoint_OBUF[0]),
        .O(ghr_checkpoint[0]));
  OBUF \ghr_checkpoint_OBUF[1]_inst 
       (.I(ghr_checkpoint_OBUF[1]),
        .O(ghr_checkpoint[1]));
  OBUF \ghr_checkpoint_OBUF[2]_inst 
       (.I(ghr_checkpoint_OBUF[2]),
        .O(ghr_checkpoint[2]));
  OBUF \ghr_checkpoint_OBUF[3]_inst 
       (.I(ghr_checkpoint_OBUF[3]),
        .O(ghr_checkpoint[3]));
  OBUF \ghr_checkpoint_OBUF[4]_inst 
       (.I(ghr_checkpoint_OBUF[4]),
        .O(ghr_checkpoint[4]));
  OBUF \ghr_checkpoint_OBUF[5]_inst 
       (.I(ghr_checkpoint_OBUF[5]),
        .O(ghr_checkpoint[5]));
  OBUF \ghr_checkpoint_OBUF[6]_inst 
       (.I(ghr_checkpoint_OBUF[6]),
        .O(ghr_checkpoint[6]));
  OBUF \ghr_checkpoint_OBUF[7]_inst 
       (.I(ghr_checkpoint_OBUF[7]),
        .O(ghr_checkpoint[7]));
  FDRE #(
    .INIT(1'b0)) 
    \ghr_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\ghr[0]_i_1_n_0 ),
        .Q(ghr_checkpoint_OBUF[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ghr_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(restore_IBUF),
        .D(ghr_restore_IBUF[1]),
        .Q(ghr_checkpoint_OBUF[1]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ghr_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(restore_IBUF),
        .D(ghr_restore_IBUF[2]),
        .Q(ghr_checkpoint_OBUF[2]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ghr_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(restore_IBUF),
        .D(ghr_restore_IBUF[3]),
        .Q(ghr_checkpoint_OBUF[3]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ghr_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(restore_IBUF),
        .D(ghr_restore_IBUF[4]),
        .Q(ghr_checkpoint_OBUF[4]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ghr_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(restore_IBUF),
        .D(ghr_restore_IBUF[5]),
        .Q(ghr_checkpoint_OBUF[5]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ghr_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(restore_IBUF),
        .D(ghr_restore_IBUF[6]),
        .Q(ghr_checkpoint_OBUF[6]),
        .R(reset_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ghr_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(restore_IBUF),
        .D(ghr_restore_IBUF[7]),
        .Q(ghr_checkpoint_OBUF[7]),
        .R(reset_IBUF));
  IBUF \ghr_restore_IBUF[0]_inst 
       (.I(ghr_restore[0]),
        .O(ghr_restore_IBUF[0]));
  IBUF \ghr_restore_IBUF[1]_inst 
       (.I(ghr_restore[1]),
        .O(ghr_restore_IBUF[1]));
  IBUF \ghr_restore_IBUF[2]_inst 
       (.I(ghr_restore[2]),
        .O(ghr_restore_IBUF[2]));
  IBUF \ghr_restore_IBUF[3]_inst 
       (.I(ghr_restore[3]),
        .O(ghr_restore_IBUF[3]));
  IBUF \ghr_restore_IBUF[4]_inst 
       (.I(ghr_restore[4]),
        .O(ghr_restore_IBUF[4]));
  IBUF \ghr_restore_IBUF[5]_inst 
       (.I(ghr_restore[5]),
        .O(ghr_restore_IBUF[5]));
  IBUF \ghr_restore_IBUF[6]_inst 
       (.I(ghr_restore[6]),
        .O(ghr_restore_IBUF[6]));
  IBUF \ghr_restore_IBUF[7]_inst 
       (.I(ghr_restore[7]),
        .O(ghr_restore_IBUF[7]));
  OBUF \index_OBUF[0]_inst 
       (.I(index_OBUF[0]),
        .O(index[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \index_OBUF[0]_inst_i_1 
       (.I0(ghr_checkpoint_OBUF[0]),
        .I1(pc_lowerbits_IBUF[0]),
        .O(index_OBUF[0]));
  OBUF \index_OBUF[1]_inst 
       (.I(index_OBUF[1]),
        .O(index[1]));
  LUT2 #(
    .INIT(4'h6)) 
    \index_OBUF[1]_inst_i_1 
       (.I0(ghr_checkpoint_OBUF[1]),
        .I1(pc_lowerbits_IBUF[1]),
        .O(index_OBUF[1]));
  OBUF \index_OBUF[2]_inst 
       (.I(index_OBUF[2]),
        .O(index[2]));
  LUT2 #(
    .INIT(4'h6)) 
    \index_OBUF[2]_inst_i_1 
       (.I0(ghr_checkpoint_OBUF[2]),
        .I1(pc_lowerbits_IBUF[2]),
        .O(index_OBUF[2]));
  OBUF \index_OBUF[3]_inst 
       (.I(index_OBUF[3]),
        .O(index[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \index_OBUF[3]_inst_i_1 
       (.I0(ghr_checkpoint_OBUF[3]),
        .I1(pc_lowerbits_IBUF[3]),
        .O(index_OBUF[3]));
  OBUF \index_OBUF[4]_inst 
       (.I(index_OBUF[4]),
        .O(index[4]));
  LUT2 #(
    .INIT(4'h6)) 
    \index_OBUF[4]_inst_i_1 
       (.I0(ghr_checkpoint_OBUF[4]),
        .I1(pc_lowerbits_IBUF[4]),
        .O(index_OBUF[4]));
  OBUF \index_OBUF[5]_inst 
       (.I(index_OBUF[5]),
        .O(index[5]));
  LUT2 #(
    .INIT(4'h6)) 
    \index_OBUF[5]_inst_i_1 
       (.I0(ghr_checkpoint_OBUF[5]),
        .I1(pc_lowerbits_IBUF[5]),
        .O(index_OBUF[5]));
  OBUF \index_OBUF[6]_inst 
       (.I(index_OBUF[6]),
        .O(index[6]));
  LUT2 #(
    .INIT(4'h6)) 
    \index_OBUF[6]_inst_i_1 
       (.I0(ghr_checkpoint_OBUF[6]),
        .I1(pc_lowerbits_IBUF[6]),
        .O(index_OBUF[6]));
  OBUF \index_OBUF[7]_inst 
       (.I(index_OBUF[7]),
        .O(index[7]));
  LUT2 #(
    .INIT(4'h6)) 
    \index_OBUF[7]_inst_i_1 
       (.I0(ghr_checkpoint_OBUF[7]),
        .I1(pc_lowerbits_IBUF[7]),
        .O(index_OBUF[7]));
  IBUF \pc_lowerbits_IBUF[0]_inst 
       (.I(pc_lowerbits[0]),
        .O(pc_lowerbits_IBUF[0]));
  IBUF \pc_lowerbits_IBUF[1]_inst 
       (.I(pc_lowerbits[1]),
        .O(pc_lowerbits_IBUF[1]));
  IBUF \pc_lowerbits_IBUF[2]_inst 
       (.I(pc_lowerbits[2]),
        .O(pc_lowerbits_IBUF[2]));
  IBUF \pc_lowerbits_IBUF[3]_inst 
       (.I(pc_lowerbits[3]),
        .O(pc_lowerbits_IBUF[3]));
  IBUF \pc_lowerbits_IBUF[4]_inst 
       (.I(pc_lowerbits[4]),
        .O(pc_lowerbits_IBUF[4]));
  IBUF \pc_lowerbits_IBUF[5]_inst 
       (.I(pc_lowerbits[5]),
        .O(pc_lowerbits_IBUF[5]));
  IBUF \pc_lowerbits_IBUF[6]_inst 
       (.I(pc_lowerbits[6]),
        .O(pc_lowerbits_IBUF[6]));
  IBUF \pc_lowerbits_IBUF[7]_inst 
       (.I(pc_lowerbits[7]),
        .O(pc_lowerbits_IBUF[7]));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  IBUF restore_IBUF_inst
       (.I(restore),
        .O(restore_IBUF));
  IBUF update_IBUF_inst
       (.I(update),
        .O(update_IBUF));
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
