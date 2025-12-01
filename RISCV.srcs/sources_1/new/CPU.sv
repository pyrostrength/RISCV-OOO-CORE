/*
RISC-V CPU IMPLEMENTING RV32I ISA,
with execption of interrupt instructions.

How to use it in a useful way?
To drive a 7 seg?
*/

module CPU #(parameter W = 31, I = 7, ROB = 32, C = 3, R = 32) 
    (input logic clk,reset
    );
    
    logic freeze;
    logic reset_pipeline,fix;
    logic[W:0] reset_addr,fix_addr;
    
    
    logic[I:0] ghr_restore;
    logic update;
    logic branch_taken;
    logic [I:0] ghr_checkpoint, prediction_index;
    
    logic[1:0] updated_state;
    logic[I:0] wr_index;
    logic[W:0] update_addr;
    logic update_predictor;  
    
    logic [W:0] instr;
    logic prediction_state;
    logic[W:0] prediction_address;
    logic buffer_hit;
    logic[W:0] instr_pc;
    IFU instruction_fetch_unit(.*);
    
    
    logic reg_write;
    logic branch;

    logic[2:0] imm_src;
    logic[1:0] execution_op;
    logic ri_station,jalr_station,loadstore_station,branch_station;
    logic mem_write,is_jal,use_imm;
    logic is_jalr,rob_write;
    logic is_lui,is_auipc;
    logic is_load,is_store;
    
    logic[W:0] branch_addr,jal_addr;
    logic redirected;
    logic[W:0] pc,instruction;
    logic[W:0] predicted_addr;
    logic[I:0] table_index,ghr_snaps;
    logic[1:0] table_state;
    IDS1 instruction_decode_stage1(.*);
     
    logic[3:0] op_control;
    logic[I:0] rd_index,ghr_snapshot;
    logic[1:0] pht_state;
    logic[W:0] nxt_pc,pred_addr;
    logic ri_req,jalr_req,loadstore_req,branch_req;
    logic write_mem,jal,take_imm;
    logic jalr,write_rob;
    logic lui,auipc;
    logic load,store;
    logic is_branch,write_reg;
    logic prediction_taken;
    logic[4:0] rd,rs1,rs2;
    logic[W:0] imm_ext;
    IDS2 instruction_decode_stage2(.*);
    
    logic instr_commit,store_committed,instr_executed;
    logic commit_reg_write;
    logic[$clog2(R)-1:0] commit_reg;
    logic[$clog2(ROB):0] instr_rob,reset_rob,read_ptr;
    logic full_rob;
    logic[$clog2(ROB):0] commit_rob,execution_rob,committed_store_rob;
    logic[W:0] commit_result,execution_result;

    logic[$clog2(ROB):0] ri_rob;
    logic[W:0] ri_op1,ri_op2;
    logic[C:0] ri_mode;
    logic ri_selected;
    logic ri_full;
           
    logic[$clog2(ROB):0] jalr_rob;
    logic[W:0] jalr_op1,jalr_op2;
    logic[C:0] jalr_mode;
    logic[I:0] jalr_prediction_index,jalr_ghr;
    logic[W:0] jalr_seq_pc;
    logic jalr_selected;
    logic jalr_full;
           
    logic[$clog2(ROB):0] branch_rob;
    logic[W:0] branch_op1,branch_op2;
    logic[C+3:0] branch_mode;
    logic[I:0] branch_prediction_index,branch_ghr;
    logic[W:0] branch_seq_pc,branch_predicted_address;
    logic branch_selected;
    logic branch_full;
   
    logic[$clog2(ROB):0] load_rob;
    logic[W:0] load_op1,load_op2;
    logic[C:0] load_mode;
    logic load_selected;
    logic loadstore_full;
   
    logic[$clog2(ROB):0] store_rob;
    logic[W:0] store_op1,store_op2;
    logic[C:0] store_mode;
    logic[W:0] store_data;
    logic store_selected;
   
    logic jal_request;
    logic[$clog2(ROB):0] jal_rob;
    logic[W:0] jal_data;
    
    logic u_request;
    logic[$clog2(ROB):0] u_rob;
    logic[W:0] u_data;
  
    IW instruction_window(.*);
    
    
    logic cdb_broadcast;
    logic[$clog2(ROB):0] executed_rob;
    logic[W:0] data1,data2;
    logic[$clog2(R)-1:0] dest_address;
    assign dest_address = rd;
    logic[C+3:0] instr_control_info;
    assign instr_control_info = {op_control,branch,write_mem,write_reg};
    
    logic empty_rob;
    /*Instruction info of commiting instruction*/
    logic[C+3:0] commit_control_info;
    logic[$clog2(R)-1:0] commit_address;
    assign commit_reg = commit_address;
    assign commit_reg_write = commit_control_info[0];
    logic[W:0] commit_data1,commit_data2;
    assign commit_result = commit_data1;
    assign update_addr = commit_data2;
    //{wr_index,new_state,update_predictor}
    assign update_predictor = commit_data1[0];
    assign updated_state = commit_data1[2:1];
    assign wr_index = commit_data1[10:3];
    
    logic[$clog2(ROB):0] write_ptr;
    assign instr_rob = write_ptr;
    reorder_buffer rob(.*,
                       .full(full_rob),
                       .empty(empty_rob));
    
    
   
    /*Input signals specific to load store
    unit where committing instruction writes
    to memory*/
    logic[$clog2(ROB):0] commit_store_rob;
    assign commit_store_rob = commit_rob;
    logic is_commit_store;
    assign is_commit_store = commit_control_info[1];
    logic[W:0] commit_store_address, commit_store_data;
    assign commit_store_address = commit_data2;
    assign commit_store_data = commit_data1;
    logic[C:0] commit_store_mode;
    assign commit_store_mode = commit_control_info[C+3:C];
   
   /*Signals specific to alu*/
    logic[$clog2(ROB):0] alu_rob;
    logic ri_request;
    logic[W:0] ri_data;
   
   /*Signals specific to branch alu*/
    logic branch_request;
    logic[1:0] new_state;
    logic[$clog2(ROB):0] b_rob;
   
   /*Signals specific to jalr unit*/
    logic jalr_request;
    logic[W:0] jalr_data;
    logic[$clog2(ROB):0] j_rob;
   
   /*Signals specific to pipeline reset
   arbitration unit*/
    logic[I:0] ghr_recovered;
    assign ghr_restore = ghr_recovered;
    logic conditional_taken;
    assign branch_taken = conditional_taken;
    logic update_ghr;
    assign update = update_ghr;
   
   /*Signals specific to load store unit*/
    logic load_request;
    logic[W:0] retrieved_data;
    logic[$clog2(ROB):0] load_entry_rob;
    logic full_store_queue,full_load_queue;
   
    logic store_request;
    logic[$clog2(ROB):0] st_rob;
    logic[W:0] st_data,st_addr;
    
    EX execute_stage(.*);
    
    logic[W:0] broadcast_data,broadcast_address;
    logic[$clog2(ROB):0] broadcast_rob;
    assign data1 = broadcast_data;
    assign data2 = broadcast_address;
    assign executed_rob = broadcast_rob;
    assign instr_executed = cdb_broadcast;
    CDB databus_stage(.*);
    
    /*If the reorder buffer is full or if
    any of the reservation stations are full,
    freeze the CPU's backend*/
    assign freeze = full_rob | branch_full | loadstore_full | ri_full | jalr_full;
    
    
                               
endmodule
