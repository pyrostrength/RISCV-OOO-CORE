/*
First instruction decode stage where
instruction type and
jal and branch jump addresses are
determined
*/

module IDS1 #(parameter I = 7, C = 3, W = 31)
    (input logic clk,reset,reset_pipeline,freeze,
    input logic[W:0] instr,prediction_address,instr_pc,
    input logic[I:0] prediction_index,ghr_checkpoint,
    input logic buffer_hit,
    input logic[1:0] prediction_state,
    
    output logic reg_write,
    output logic branch,

    output logic[2:0] imm_src,
    output logic[1:0] execution_op,
    output logic ri_station,jalr_station,loadstore_station,branch_station,
    output logic mem_write,is_jal,use_imm,
    output logic is_jalr,rob_write,
    output logic is_lui,is_auipc,
    output logic is_load,is_store,
    
    output logic[W:0] branch_addr,jal_addr,
    output logic redirected,
    output logic[W:0] pc,instruction,
    output logic[W:0] predicted_addr,
    output logic[I:0] table_index,ghr_snaps,
    output logic[1:0] table_state
    
    );
    
    logic[2:0] imm_src_next;
    logic[1:0] execution_op_next;
    logic ri_station_next,loadstore_station_next,branch_station_next;
    logic jalr_station_next;
    logic mem_write_next,is_jal_next,use_imm_next;
    logic is_jalr_next,rob_write_next,is_lui_next,is_auipc_next;
    logic is_load_next,is_store_next,reg_write_next,branch_next;
    logic[W:0] branch_addr_next,jal_addr_next;
    decode_stage1    decoder1(.clk(clk),
                              .reset(reset),
                              .reset_pipeline(reset_pipeline),
                              .imm(instr[W:7]),
                              .rd(instr[11:7]),
                              .opcode(instr[3:0]),
                              .imm_src(imm_src_next),
                              .execution_op(execution_op_next),
                              .ri_station(ri_station_next),
                              .loadstore_station(loadstore_station_next),
                              .branch_station(branch_station_next),
                              .jalr_station(jalr_station_next),
                              .mem_write(mem_write_next),
                              .is_jal(is_jal_next),
                              .use_imm(use_imm_next),
                              .is_jalr(is_jalr_next),
                              .rob_write(rob_write_next),
                              .is_lui(is_lui_next),
                              .is_auipc(is_auipc_next), 
                              .is_load(is_load_next),
                              .is_store(is_store_next),                             
                              .reg_write(reg_write_next),
                              .branch(branch_next),
                              .branch_addr(branch_addr_next),
                              .jal_addr(jal_addr_next));
                              
    
                                                    
    
    logic redirected_next;
    
    assign redirected_next = buffer_hit & prediction_state[1];
    

    always_ff @(posedge clk) begin
        if(reset | reset_pipeline) begin
           {mem_write,is_jal,is_jalr} <= '0;
           imm_src <= '0;
	       {ri_station,loadstore_station,branch_station,jalr_station} <= '0;
	       {use_imm,rob_write,execution_op} <= '0;
	       {is_lui,is_auipc} <= '0;
	       
	       {reg_write,branch} <= '0;
	       {branch_addr, jal_addr} <= '0;
	       
	       is_load <= '0;
	       is_store <= '0;
	       
	       redirected <= '0;
	       predicted_addr <= '0;
	       table_index <= '0;
	       ghr_snaps <= '0;
	       table_state <= '0;
	       pc <= '0;
	       instruction <= '0;
	    end
	    
	    else if(freeze) begin
	       mem_write <= mem_write;
	       is_jal <= is_jal;
	       is_jalr <= is_jalr;
	       
	       ri_station <= ri_station;
	       jalr_station <= jalr_station;
	       branch_station <= branch_station;
	       loadstore_station <= loadstore_station;
	       
	       imm_src <= imm_src;
	       use_imm <= use_imm;
	       rob_write <= rob_write;
	       
	       execution_op <= execution_op;
	       is_lui <= is_lui;
	       is_auipc <= is_auipc;
	       
	       reg_write <= reg_write;
	       branch <= branch;
	       branch_addr <= branch_addr;
	       jal_addr <= jal_addr;
	       
	       is_load <= is_load;
	       is_store <= is_store;
	       
	       redirected <= redirected;
	       predicted_addr <= predicted_addr;
	       table_index <= table_index;
	       ghr_snaps <= ghr_snaps;
	       table_state <= table_state;
	       pc <= pc;
	       instruction <= instruction;
	       
	    end
	    else begin
	       mem_write <= mem_write_next;
	       is_jal <= is_jal_next;
	       is_jalr <= is_jalr_next;
	       
	       imm_src <= imm_src_next;
	       use_imm <= use_imm_next;
	       rob_write <= rob_write_next;
	       execution_op <= execution_op_next;
	       is_lui <= is_lui_next;
	       is_auipc <= is_auipc_next;
	       is_load <= is_load_next;
	       is_store <= is_store_next;
	       reg_write <= reg_write_next;
	       branch <= branch_next;
	       branch_addr <= branch_addr_next;
	       jal_addr <= jal_addr_next;
	       
	       ri_station <= ri_station_next;
	       jalr_station <= jalr_station_next;
	       branch_station <= branch_station_next;
	       loadstore_station <= loadstore_station_next;
	       
	       redirected <= redirected_next;
	       predicted_addr <= prediction_address;
	       table_index <= prediction_index;
	       ghr_snaps <= ghr_checkpoint;
	       table_state <= prediction_state;
	       pc <= instr_pc;
	       instruction <= instr;
	       
	    end
	end
endmodule
