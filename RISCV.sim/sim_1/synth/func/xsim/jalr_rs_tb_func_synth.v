// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
// Date        : Sat Dec  6 14:37:57 2025
// Host        : voidknight-XPS-13-7390 running 64-bit Ubuntu 24.04.3 LTS
// Command     : write_verilog -mode funcsim -nolib -force -file
//               /home/voidknight/RISCV/RISCV.sim/sim_1/synth/func/xsim/jalr_rs_tb_func_synth.v
// Design      : jalr_rs
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-2L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* I = "7" *) (* ROB = "32" *) (* RS = "4" *) 
(* W = "31" *) 
(* NotValidForBitStream *)
module jalr_rs
   (clk,
    reset,
    reset_pipeline,
    full_rob,
    read_ptr,
    rob_entry,
    src1_booking,
    src2_booking,
    station_request,
    rs1,
    rs2,
    seq_pc,
    prediction_index,
    ghr_checkpoint,
    execution_rob,
    reset_rob,
    execution_result,
    instr_executed,
    jalr_rob,
    jalr_op1,
    jalr_op2,
    jalr_selected,
    jalr_prediction_index,
    jalr_ghr,
    jalr_seq_pc,
    rs_full);
  input clk;
  input reset;
  input reset_pipeline;
  input full_rob;
  input [5:0]read_ptr;
  input [5:0]rob_entry;
  input [6:0]src1_booking;
  input [6:0]src2_booking;
  input station_request;
  input [31:0]rs1;
  input [31:0]rs2;
  input [31:0]seq_pc;
  input [7:0]prediction_index;
  input [7:0]ghr_checkpoint;
  input [5:0]execution_rob;
  input [5:0]reset_rob;
  input [31:0]execution_result;
  input instr_executed;
  output [5:0]jalr_rob;
  output [31:0]jalr_op1;
  output [31:0]jalr_op2;
  output jalr_selected;
  output [7:0]jalr_prediction_index;
  output [7:0]jalr_ghr;
  output [31:0]jalr_seq_pc;
  output rs_full;

  wire [7:0]jalr_ghr;
  wire [31:0]jalr_op1;
  wire [31:0]jalr_op2;
  wire [7:0]jalr_prediction_index;
  wire [5:0]jalr_rob;
  wire jalr_selected;
  wire [31:0]jalr_seq_pc;
  wire rs_full;

  OBUF \jalr_ghr_OBUF[0]_inst 
       (.I(1'b0),
        .O(jalr_ghr[0]));
  OBUF \jalr_ghr_OBUF[1]_inst 
       (.I(1'b0),
        .O(jalr_ghr[1]));
  OBUF \jalr_ghr_OBUF[2]_inst 
       (.I(1'b0),
        .O(jalr_ghr[2]));
  OBUF \jalr_ghr_OBUF[3]_inst 
       (.I(1'b0),
        .O(jalr_ghr[3]));
  OBUF \jalr_ghr_OBUF[4]_inst 
       (.I(1'b0),
        .O(jalr_ghr[4]));
  OBUF \jalr_ghr_OBUF[5]_inst 
       (.I(1'b0),
        .O(jalr_ghr[5]));
  OBUF \jalr_ghr_OBUF[6]_inst 
       (.I(1'b0),
        .O(jalr_ghr[6]));
  OBUF \jalr_ghr_OBUF[7]_inst 
       (.I(1'b0),
        .O(jalr_ghr[7]));
  OBUF \jalr_op1_OBUF[0]_inst 
       (.I(1'b0),
        .O(jalr_op1[0]));
  OBUF \jalr_op1_OBUF[10]_inst 
       (.I(1'b0),
        .O(jalr_op1[10]));
  OBUF \jalr_op1_OBUF[11]_inst 
       (.I(1'b0),
        .O(jalr_op1[11]));
  OBUF \jalr_op1_OBUF[12]_inst 
       (.I(1'b0),
        .O(jalr_op1[12]));
  OBUF \jalr_op1_OBUF[13]_inst 
       (.I(1'b0),
        .O(jalr_op1[13]));
  OBUF \jalr_op1_OBUF[14]_inst 
       (.I(1'b0),
        .O(jalr_op1[14]));
  OBUF \jalr_op1_OBUF[15]_inst 
       (.I(1'b0),
        .O(jalr_op1[15]));
  OBUF \jalr_op1_OBUF[16]_inst 
       (.I(1'b0),
        .O(jalr_op1[16]));
  OBUF \jalr_op1_OBUF[17]_inst 
       (.I(1'b0),
        .O(jalr_op1[17]));
  OBUF \jalr_op1_OBUF[18]_inst 
       (.I(1'b0),
        .O(jalr_op1[18]));
  OBUF \jalr_op1_OBUF[19]_inst 
       (.I(1'b0),
        .O(jalr_op1[19]));
  OBUF \jalr_op1_OBUF[1]_inst 
       (.I(1'b0),
        .O(jalr_op1[1]));
  OBUF \jalr_op1_OBUF[20]_inst 
       (.I(1'b0),
        .O(jalr_op1[20]));
  OBUF \jalr_op1_OBUF[21]_inst 
       (.I(1'b0),
        .O(jalr_op1[21]));
  OBUF \jalr_op1_OBUF[22]_inst 
       (.I(1'b0),
        .O(jalr_op1[22]));
  OBUF \jalr_op1_OBUF[23]_inst 
       (.I(1'b0),
        .O(jalr_op1[23]));
  OBUF \jalr_op1_OBUF[24]_inst 
       (.I(1'b0),
        .O(jalr_op1[24]));
  OBUF \jalr_op1_OBUF[25]_inst 
       (.I(1'b0),
        .O(jalr_op1[25]));
  OBUF \jalr_op1_OBUF[26]_inst 
       (.I(1'b0),
        .O(jalr_op1[26]));
  OBUF \jalr_op1_OBUF[27]_inst 
       (.I(1'b0),
        .O(jalr_op1[27]));
  OBUF \jalr_op1_OBUF[28]_inst 
       (.I(1'b0),
        .O(jalr_op1[28]));
  OBUF \jalr_op1_OBUF[29]_inst 
       (.I(1'b0),
        .O(jalr_op1[29]));
  OBUF \jalr_op1_OBUF[2]_inst 
       (.I(1'b0),
        .O(jalr_op1[2]));
  OBUF \jalr_op1_OBUF[30]_inst 
       (.I(1'b0),
        .O(jalr_op1[30]));
  OBUF \jalr_op1_OBUF[31]_inst 
       (.I(1'b0),
        .O(jalr_op1[31]));
  OBUF \jalr_op1_OBUF[3]_inst 
       (.I(1'b0),
        .O(jalr_op1[3]));
  OBUF \jalr_op1_OBUF[4]_inst 
       (.I(1'b0),
        .O(jalr_op1[4]));
  OBUF \jalr_op1_OBUF[5]_inst 
       (.I(1'b0),
        .O(jalr_op1[5]));
  OBUF \jalr_op1_OBUF[6]_inst 
       (.I(1'b0),
        .O(jalr_op1[6]));
  OBUF \jalr_op1_OBUF[7]_inst 
       (.I(1'b0),
        .O(jalr_op1[7]));
  OBUF \jalr_op1_OBUF[8]_inst 
       (.I(1'b0),
        .O(jalr_op1[8]));
  OBUF \jalr_op1_OBUF[9]_inst 
       (.I(1'b0),
        .O(jalr_op1[9]));
  OBUF \jalr_op2_OBUF[0]_inst 
       (.I(1'b0),
        .O(jalr_op2[0]));
  OBUF \jalr_op2_OBUF[10]_inst 
       (.I(1'b0),
        .O(jalr_op2[10]));
  OBUF \jalr_op2_OBUF[11]_inst 
       (.I(1'b0),
        .O(jalr_op2[11]));
  OBUF \jalr_op2_OBUF[12]_inst 
       (.I(1'b0),
        .O(jalr_op2[12]));
  OBUF \jalr_op2_OBUF[13]_inst 
       (.I(1'b0),
        .O(jalr_op2[13]));
  OBUF \jalr_op2_OBUF[14]_inst 
       (.I(1'b0),
        .O(jalr_op2[14]));
  OBUF \jalr_op2_OBUF[15]_inst 
       (.I(1'b0),
        .O(jalr_op2[15]));
  OBUF \jalr_op2_OBUF[16]_inst 
       (.I(1'b0),
        .O(jalr_op2[16]));
  OBUF \jalr_op2_OBUF[17]_inst 
       (.I(1'b0),
        .O(jalr_op2[17]));
  OBUF \jalr_op2_OBUF[18]_inst 
       (.I(1'b0),
        .O(jalr_op2[18]));
  OBUF \jalr_op2_OBUF[19]_inst 
       (.I(1'b0),
        .O(jalr_op2[19]));
  OBUF \jalr_op2_OBUF[1]_inst 
       (.I(1'b0),
        .O(jalr_op2[1]));
  OBUF \jalr_op2_OBUF[20]_inst 
       (.I(1'b0),
        .O(jalr_op2[20]));
  OBUF \jalr_op2_OBUF[21]_inst 
       (.I(1'b0),
        .O(jalr_op2[21]));
  OBUF \jalr_op2_OBUF[22]_inst 
       (.I(1'b0),
        .O(jalr_op2[22]));
  OBUF \jalr_op2_OBUF[23]_inst 
       (.I(1'b0),
        .O(jalr_op2[23]));
  OBUF \jalr_op2_OBUF[24]_inst 
       (.I(1'b0),
        .O(jalr_op2[24]));
  OBUF \jalr_op2_OBUF[25]_inst 
       (.I(1'b0),
        .O(jalr_op2[25]));
  OBUF \jalr_op2_OBUF[26]_inst 
       (.I(1'b0),
        .O(jalr_op2[26]));
  OBUF \jalr_op2_OBUF[27]_inst 
       (.I(1'b0),
        .O(jalr_op2[27]));
  OBUF \jalr_op2_OBUF[28]_inst 
       (.I(1'b0),
        .O(jalr_op2[28]));
  OBUF \jalr_op2_OBUF[29]_inst 
       (.I(1'b0),
        .O(jalr_op2[29]));
  OBUF \jalr_op2_OBUF[2]_inst 
       (.I(1'b0),
        .O(jalr_op2[2]));
  OBUF \jalr_op2_OBUF[30]_inst 
       (.I(1'b0),
        .O(jalr_op2[30]));
  OBUF \jalr_op2_OBUF[31]_inst 
       (.I(1'b0),
        .O(jalr_op2[31]));
  OBUF \jalr_op2_OBUF[3]_inst 
       (.I(1'b0),
        .O(jalr_op2[3]));
  OBUF \jalr_op2_OBUF[4]_inst 
       (.I(1'b0),
        .O(jalr_op2[4]));
  OBUF \jalr_op2_OBUF[5]_inst 
       (.I(1'b0),
        .O(jalr_op2[5]));
  OBUF \jalr_op2_OBUF[6]_inst 
       (.I(1'b0),
        .O(jalr_op2[6]));
  OBUF \jalr_op2_OBUF[7]_inst 
       (.I(1'b0),
        .O(jalr_op2[7]));
  OBUF \jalr_op2_OBUF[8]_inst 
       (.I(1'b0),
        .O(jalr_op2[8]));
  OBUF \jalr_op2_OBUF[9]_inst 
       (.I(1'b0),
        .O(jalr_op2[9]));
  OBUF \jalr_prediction_index_OBUF[0]_inst 
       (.I(1'b0),
        .O(jalr_prediction_index[0]));
  OBUF \jalr_prediction_index_OBUF[1]_inst 
       (.I(1'b0),
        .O(jalr_prediction_index[1]));
  OBUF \jalr_prediction_index_OBUF[2]_inst 
       (.I(1'b0),
        .O(jalr_prediction_index[2]));
  OBUF \jalr_prediction_index_OBUF[3]_inst 
       (.I(1'b0),
        .O(jalr_prediction_index[3]));
  OBUF \jalr_prediction_index_OBUF[4]_inst 
       (.I(1'b0),
        .O(jalr_prediction_index[4]));
  OBUF \jalr_prediction_index_OBUF[5]_inst 
       (.I(1'b0),
        .O(jalr_prediction_index[5]));
  OBUF \jalr_prediction_index_OBUF[6]_inst 
       (.I(1'b0),
        .O(jalr_prediction_index[6]));
  OBUF \jalr_prediction_index_OBUF[7]_inst 
       (.I(1'b0),
        .O(jalr_prediction_index[7]));
  OBUF \jalr_rob_OBUF[0]_inst 
       (.I(1'b0),
        .O(jalr_rob[0]));
  OBUF \jalr_rob_OBUF[1]_inst 
       (.I(1'b0),
        .O(jalr_rob[1]));
  OBUF \jalr_rob_OBUF[2]_inst 
       (.I(1'b0),
        .O(jalr_rob[2]));
  OBUF \jalr_rob_OBUF[3]_inst 
       (.I(1'b0),
        .O(jalr_rob[3]));
  OBUF \jalr_rob_OBUF[4]_inst 
       (.I(1'b0),
        .O(jalr_rob[4]));
  OBUF \jalr_rob_OBUF[5]_inst 
       (.I(1'b0),
        .O(jalr_rob[5]));
  OBUF jalr_selected_OBUF_inst
       (.I(1'b0),
        .O(jalr_selected));
  OBUF \jalr_seq_pc_OBUF[0]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[0]));
  OBUF \jalr_seq_pc_OBUF[10]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[10]));
  OBUF \jalr_seq_pc_OBUF[11]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[11]));
  OBUF \jalr_seq_pc_OBUF[12]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[12]));
  OBUF \jalr_seq_pc_OBUF[13]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[13]));
  OBUF \jalr_seq_pc_OBUF[14]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[14]));
  OBUF \jalr_seq_pc_OBUF[15]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[15]));
  OBUF \jalr_seq_pc_OBUF[16]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[16]));
  OBUF \jalr_seq_pc_OBUF[17]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[17]));
  OBUF \jalr_seq_pc_OBUF[18]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[18]));
  OBUF \jalr_seq_pc_OBUF[19]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[19]));
  OBUF \jalr_seq_pc_OBUF[1]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[1]));
  OBUF \jalr_seq_pc_OBUF[20]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[20]));
  OBUF \jalr_seq_pc_OBUF[21]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[21]));
  OBUF \jalr_seq_pc_OBUF[22]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[22]));
  OBUF \jalr_seq_pc_OBUF[23]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[23]));
  OBUF \jalr_seq_pc_OBUF[24]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[24]));
  OBUF \jalr_seq_pc_OBUF[25]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[25]));
  OBUF \jalr_seq_pc_OBUF[26]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[26]));
  OBUF \jalr_seq_pc_OBUF[27]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[27]));
  OBUF \jalr_seq_pc_OBUF[28]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[28]));
  OBUF \jalr_seq_pc_OBUF[29]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[29]));
  OBUF \jalr_seq_pc_OBUF[2]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[2]));
  OBUF \jalr_seq_pc_OBUF[30]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[30]));
  OBUF \jalr_seq_pc_OBUF[31]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[31]));
  OBUF \jalr_seq_pc_OBUF[3]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[3]));
  OBUF \jalr_seq_pc_OBUF[4]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[4]));
  OBUF \jalr_seq_pc_OBUF[5]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[5]));
  OBUF \jalr_seq_pc_OBUF[6]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[6]));
  OBUF \jalr_seq_pc_OBUF[7]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[7]));
  OBUF \jalr_seq_pc_OBUF[8]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[8]));
  OBUF \jalr_seq_pc_OBUF[9]_inst 
       (.I(1'b0),
        .O(jalr_seq_pc[9]));
  OBUF rs_full_OBUF_inst
       (.I(1'b1),
        .O(rs_full));
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
