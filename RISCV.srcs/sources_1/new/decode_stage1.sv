/*
First decode stage that resolves instruction
type which dictates source operands to be used,
reservation station to write to and
whether instruction writes to or access memory.

Note no instruction can write to register x0.
So we enforce that rule here.
*/ 
module decode_stage1 #(parameter W = 31, I_W = 24)
(   input logic[I_W:0] imm,
    input logic[4:0] rd,
    input logic[W:0] instr_pc,
    input logic[3:0] opcode,
    output logic[2:0] imm_src,
    output logic[1:0] execution_op,
    output logic ri_station,branch_station,jalr_station,
    output logic loadstore_station,
    output logic mem_write,is_jal,use_imm,
    output logic is_jalr,rob_write,
    output logic is_lui,is_auipc,
    
    output logic is_load,is_store,
    output logic reg_write,
    output logic branch,
    output logic[W:0] branch_addr,jal_addr
    );
    
    
    always_comb begin
        branch_addr = {{12{imm[24]}},imm[12:5],imm[13],imm[23:14],1'b0} + instr_pc;
        jal_addr = {{20{imm[24]}},imm[0],imm[23:18],imm[4:1],1'b0} + instr_pc;
    end

	always_comb begin
	   {mem_write,is_jal,is_jalr} = '0;
	   {ri_station,branch_station,jalr_station,loadstore_station} = '0;
	   execution_op = 2'b11;
	   imm_src = 3'b000; //For JALR and I-type instructions.
	   /*Most instructions use their immediate field*/
	   use_imm = 1'b1;
	   /*All instructions write to the reorder buffer*/
	   rob_write = 1'b1;
	   {is_lui,is_auipc,is_load,is_store} = '0;
	   
	   branch = '0;
	   //No instruction can write to destination register x0
	   reg_write = (rd != '0);
	   case(opcode)
	       4'b0001 : begin //R-type
	          ri_station = '1; 
	          execution_op = 2'b00;
	          imm_src = 3'b111;
	          use_imm = 1'b0;
	          rob_write = 1'b1;
		   end
		   
		    4'b0010 : begin //I-type
		      ri_station = '1;
	          execution_op = 2'b00;
	          imm_src = 3'b000;
	          rob_write= 1'b1;
		   end
		   
		   4'b0011 : begin //S-type
	          loadstore_station = '1;
	          execution_op = 2'b11;
	          imm_src = 3'b001;
	          mem_write = '1;
	          rob_write = 1'b1;
	          is_store = '1;
	          reg_write = '0;
		   end
		   
		   4'b0100 : begin //B-type
	          use_imm = '0;
	          branch_station = 1'b1;
	          execution_op = 2'b01;
	          imm_src = 3'b010;
	          rob_write = 1'b1;
	          
	          reg_write = '0;
	          branch = '1;
		   end
		   
		   4'b0101 : begin //LUI
	          imm_src = 3'b011;
	          rob_write = 1'b1;
	          is_lui = '1;
		   end
		   
		   4'b0111 : begin	//AUIPC
		      imm_src = 3'b011;
		      rob_write = '1;
			  is_auipc = 1'b1;
		   end
			   
		   4'b0110 : begin //JAL-type
		      imm_src = 3'b100;
			  is_jal = 1'b1;
			  rob_write = '1;
		   end
										
		   4'b1000 : begin //JALR-type
		      is_jalr= 1'b1;
			  jalr_station = 1'b1;
		   end
		   
		   4'b1001 : begin//Load-type
		      execution_op = 2'b10;
		      loadstore_station = '1;
			  rob_write = 1'b1;
			  is_load = '1;
		   end
		endcase
    end
    
    
            
endmodule
