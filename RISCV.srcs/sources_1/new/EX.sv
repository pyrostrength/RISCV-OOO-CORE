/*
Contains all the execution units for all
instruction types
*/
module EX #(parameter ROB = 32, R = 4, W = 31, I = 7, C = 3)
          (input logic clk,reset,
           input logic[$clog2(ROB):0] read_ptr,
    
           input logic[$clog2(ROB):0] riu_rob,
           input logic[W:0] riu_op1,riu_op2,
           input logic[C:0] riu_mode,
           input logic riu_selected,
           input logic riu_full,
     
     /*Signals specific to jalr reservation station*/
           input logic[$clog2(ROB):0] jalr_rob,
           input logic[W:0] jalr_op1,jalr_op2,
           input logic[C:0] jalr_mode,
           input logic[I:0] jalr_prediction_index,jalr_ghr,
           input logic[W:0] jalr_seq_pc,
           input logic jalr_selected,
           input logic jalr_full,
           
           /*Signals specific to branch reservation station*/
           input logic[$clog2(ROB):0] branch_rob,
           input logic[W:0] branch_op1,branch_op2,branch_predicted_address,
           input logic[C:0] branch_mode,
           input logic[I:0] branch_prediction_index,branch_ghr,
           input logic[W:0] branch_seq_pc,
           input logic branch_selected,
           input logic branch_full,
           
           /*Signals specific to load store reservation station*/
           input logic[$clog2(ROB):0] load_rob,
           input logic[W:0] load_op1,load_op2,
           input logic[C:0] load_mode,
           input logic load_selected,
           input logic loadstore_full,
           
           input logic[$clog2(ROB):0] store_rob,
           input logic[W:0] store_op1,store_op2,
           input logic[C:0] store_mode,
           input logic[W:0] store_data,
           input logic store_selected,
           
           /*Input signals specific to load store
           unit where committing instruction writes
           to memory*/
           input logic[$clog2(ROB):0] commit_store_rob,
           input logic is_commit_store,
           input logic[W:0] commit_store_address, commit_store_data,
           input logic[C:0] commit_store_mode,
           
           /*Signals specific to alu*/
           output logic[$clog2(ROB):0] alu_rob,
           output logic riu_request,
           output logic[W:0] riu_data,
           
           /*Signals specific to branch alu*/
           output logic branch_request,
           output logic[1:0] new_state,
           output logic[$clog2(ROB):0] b_rob,
           
           /*Signals specific to jalr unit*/
           output logic jalr_request,
           output logic[W:0] jalr_data,
           output logic[$clog2(ROB):0] j_rob,
           
           /*Signals specific to pipeline reset
           arbitration unit*/
           output logic reset_pipeline,
           output logic[I:0] ghr_recovered,
           output logic[W:0] reset_addr,
           output logic conditional_taken,
           output logic update_ghr,
           
           /*Signals specific to load store unit*/
           output logic load_request,
           output logic store_committed,
           output logic[$clog2(ROB):0] committed_store_rob,
           output logic[W:0] retrieved_data,
           output logic[$clog2(ROB):0] load_entry_rob,
           output logic full_store_queue,full_load_queue,
           
           output logic store_request,
           output logic[$clog2(ROB):0] st_rob,
           output logic[W:0] st_data,st_addr
           
                 
    );
    
    alu ALU(.is_riu_instr(riu_selected),
            .instr_rob(riu_rob),
            .op_control(riu_mode),
            .op1(riu_op1),
            .op2(riu_op2),
            .riu_rob(alu_rob),
            .riu_cdb_request(riu_request));
    
    logic misprediction;
    
    /*Use branch request and taken branch to
    update the gshare predictor*/
    logic taken_branch;
    logic[1:0] new_state_next;
    logic branch_request_next;
    logic[W:0] branch_address;
    branch_alu branchALU(.src1(branch_op1),
                         .src2(branch_op2),
                         .branch_predicted_address(branch_predicted_address),
                         .seq_pc(branch_seq_pc),
                         .redirect(branch_mode[C+1]),
                         .op_control(branch_mode[C:0]),
                         .original_state(branch_mode[C+3:C+2]),
                         .instr_rob(branch_rob),
                         .is_branch_instr(branch_selected),
                         .misprediction(misprediction),
                         .branch_cdb_request(branch_request),
                         .new_state(new_state_next),
                         .branch_rob(b_rob),
                         .taken_branch(taken_branch));
     
     logic[W:0] jalr_jump_address;
     assign j_rob = jalr_rob;
     jalr_unit(.is_jalr_instruction(jalr_selected),
               .op1(jalr_op1),
               .op2(jalr_op2),
               .seq_pc(jalr_seq_pc),
               .jalr_cdb_request(jalr_request),
               .store_pc(jalr_data),
               .jalr_jump_address(jalr_jump_address));
     
     /*Pipeline reset module decides the older
     between jalr or branch instruction in
     execute stage and initiates pipeline reset
     if necessary*/
     pipeline_reset_arbitrer reset_mod(.clk(clk),
                                      .reset(reset),
                                      .jalr_rob(jalr_rob),
                                      .branch_rob(branch_rob),
                                      .read_ptr(read_ptr),
                                      .is_jalr(jalr_selected),
                                      .is_branch(branch_selected),
                                      .branch_ghr_checkpoint(branch_ghr),
                                      .jalr_ghr_checkpoint(jalr_ghr),
                                      .taken_branch(taken_branch),
                                      .jalr_address(jalr_jump_address),
                                      .branch_address(branch_address),
                                      .misprediction(misprediction),
                                      .reset_addr(reset_addr),
                                      .ghr_recovered(ghr_recovered),
                                      .reset_pipeline(reset_pipeline),
                                      .conditional_taken(conditional_taken),
                                      .update_ghr(update_ghr));
      
      logic[W:0] load_address;
      load_address_gen ld_addr_gen(.load_op1(load_op1),
                                   .load_op2(load_op2),
                                   .load_addr(load_address));
      
      assign store_request = store_selected;
      assign st_data = store_data;
      assign st_rob = store_rob;                             
      store_address_gen st_addr_gen(.store_op1(store_op1),
                                    .store_op2(store_op2),
                                    .store_addr(st_addr));
                                    
      load_store_unit loadstore(.clk(clk),
                                .reset(reset),
                                .load_address(load_address),
                                .load_rob(load_rob),
                                .load_control(load_mode),
                                .execute_load(load_selected),
                                .load_complete(load_request),
                                .store_address(commit_store_address),
                                .store_data(commit_store_data),
                                .store_rob(commit_store_rob),
                                .store_control(commit_store_mode),
                                .is_commit_store(is_commit_store),
                                .store_committed(store_committed),
                                .committed_store_rob(committed_store_rob),
                                .retrieved_data(retrieved_data),
                                .entry_rob(load_entry_rob),
                                .full_load_queue(full_load_queue),
                                .full_store_queue(full_store_queue));
      
      
endmodule