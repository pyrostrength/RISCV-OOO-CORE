// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
// Date        : Sun Nov 30 21:43:55 2025
// Host        : voidknight-XPS-13-7390 running 64-bit Ubuntu 24.04.3 LTS
// Command     : write_verilog -mode funcsim -nolib -force -file
//               /home/voidknight/RISCV/RISCV.sim/sim_1/synth/func/xsim/fix_flush_tb_func_synth.v
// Design      : fix_flush
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-2L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NotValidForBitStream *)
module fix_flush
   (clk,
    reset,
    reset_pipeline,
    freeze,
    fix,
    fix_flush);
  input clk;
  input reset;
  input reset_pipeline;
  input freeze;
  input fix;
  output fix_flush;

  wire \FSM_onehot_state[3]_i_1_n_0 ;
  wire \FSM_onehot_state[3]_i_2_n_0 ;
  wire \FSM_onehot_state_next_reg[3]_i_1_n_0 ;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire fix;
  wire fix_IBUF;
  wire fix_flush;
  wire fix_flush_OBUF;
  wire freeze;
  wire freeze_IBUF;
  wire reset;
  wire reset_IBUF;
  wire reset_pipeline;
  wire reset_pipeline_IBUF;
  wire [3:0]state;
  wire [3:0]state_next;
  wire [1:0]state_next__0;

  LUT2 #(
    .INIT(4'hE)) 
    \FSM_onehot_state[3]_i_1 
       (.I0(reset_IBUF),
        .I1(reset_pipeline_IBUF),
        .O(\FSM_onehot_state[3]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \FSM_onehot_state[3]_i_2 
       (.I0(freeze_IBUF),
        .O(\FSM_onehot_state[3]_i_2_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_next_reg[0] 
       (.CLR(1'b0),
        .D(state_next__0[0]),
        .G(\FSM_onehot_state_next_reg[3]_i_1_n_0 ),
        .GE(1'b1),
        .Q(state_next[0]));
  LUT3 #(
    .INIT(8'hBA)) 
    \FSM_onehot_state_next_reg[0]_i_1 
       (.I0(state[3]),
        .I1(fix_IBUF),
        .I2(state[0]),
        .O(state_next__0[0]));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_next_reg[1] 
       (.CLR(1'b0),
        .D(state_next__0[1]),
        .G(\FSM_onehot_state_next_reg[3]_i_1_n_0 ),
        .GE(1'b1),
        .Q(state_next[1]));
  LUT2 #(
    .INIT(4'h8)) 
    \FSM_onehot_state_next_reg[1]_i_1 
       (.I0(state[0]),
        .I1(fix_IBUF),
        .O(state_next__0[1]));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_next_reg[2] 
       (.CLR(1'b0),
        .D(state[1]),
        .G(\FSM_onehot_state_next_reg[3]_i_1_n_0 ),
        .GE(1'b1),
        .Q(state_next[2]));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_next_reg[3] 
       (.CLR(1'b0),
        .D(state[2]),
        .G(\FSM_onehot_state_next_reg[3]_i_1_n_0 ),
        .GE(1'b1),
        .Q(state_next[3]));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_onehot_state_next_reg[3]_i_1 
       (.I0(state[3]),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .O(\FSM_onehot_state_next_reg[3]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "flush2:0100,flush3:1000,still:0001,flush1:0010" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\FSM_onehot_state[3]_i_2_n_0 ),
        .D(state_next[0]),
        .Q(state[0]),
        .S(\FSM_onehot_state[3]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "flush2:0100,flush3:1000,still:0001,flush1:0010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\FSM_onehot_state[3]_i_2_n_0 ),
        .D(state_next[1]),
        .Q(state[1]),
        .R(\FSM_onehot_state[3]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "flush2:0100,flush3:1000,still:0001,flush1:0010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\FSM_onehot_state[3]_i_2_n_0 ),
        .D(state_next[2]),
        .Q(state[2]),
        .R(\FSM_onehot_state[3]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "flush2:0100,flush3:1000,still:0001,flush1:0010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\FSM_onehot_state[3]_i_2_n_0 ),
        .D(state_next[3]),
        .Q(state[3]),
        .R(\FSM_onehot_state[3]_i_1_n_0 ));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  IBUF fix_IBUF_inst
       (.I(fix),
        .O(fix_IBUF));
  OBUF fix_flush_OBUF_inst
       (.I(fix_flush_OBUF),
        .O(fix_flush));
  LUT4 #(
    .INIT(16'hFFEA)) 
    fix_flush_OBUF_inst_i_1
       (.I0(state[2]),
        .I1(state[0]),
        .I2(fix_IBUF),
        .I3(state[1]),
        .O(fix_flush_OBUF));
  IBUF freeze_IBUF_inst
       (.I(freeze),
        .O(freeze_IBUF));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
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
