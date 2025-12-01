/*
Instruction window stage
holds the reservation station
and register status table for
register rename, instruction holding
until operands become available
and selection and dispatch of instructions
to their respective functional units
*/

module IW #(parameter W = 31, I = 7, C = 3, ROB = 32, R = 32)
          (input logic clk,reset,reset_pipeline,instr_commit,instr_executed,
           input logic[3:0] op_control,
           input logic commit_reg_write,
           
           /*2 instruction commits, one generic, the other
           for clearing stores after they've written to
           memory*/
           input logic store_committed,
           input logic[$clog2(ROB):0] committed_store_rob,
     
           input logic[I:0] rd_index,ghr_snapshot,
           input logic[1:0] pht_state,
           input logic[W:0] nxt_seq_pc,imm_ext,pred_addr,
     
           input logic riu_req,jalr_req,loadstore_req,branch_req,
           input logic write_mem,jal,take_imm,
           input logic jalr,write_rob,
           input logic lui,auipc,
           input logic load,store,
           input logic write_reg, is_branch,
           input logic prediction_taken,
           
           input logic[$clog2(R)-1:0] commit_reg,rd,rs1,rs2,
           input logic[$clog2(ROB):0] instr_rob,reset_rob,read_ptr,
           input logic full_rob,
           input logic[$clog2(ROB):0] commit_rob,execution_rob,
           input logic[W:0] commit_result,execution_result,
           
           /*Signals specific to riu reservation station*/
           output logic[$clog2(ROB):0] riu_rob,
           output logic[W:0] riu_op1,riu_op2,
           output logic[C:0] riu_mode,
           output logic riu_selected,
           output logic riu_full,
           
           /*Signals specific to jalr reservation station*/
           output logic[$clog2(ROB):0] jalr_rob,
           output logic[W:0] jalr_op1,jalr_op2,
           output logic[C:0] jalr_mode,
           output logic[I:0] jalr_prediction_index,jalr_ghr,
           output logic[W:0] jalr_seq_pc,
           output logic jalr_selected,
           output logic jalr_full,
           
           /*Signals specific to branch reservation station*/
           output logic[$clog2(ROB):0] branch_rob,
           output logic[W:0] branch_op1,branch_op2,
           output logic[C+3:0] branch_mode,
           output logic[I:0] branch_prediction_index,branch_ghr,
           output logic[W:0] branch_seq_pc,branch_predicted_address,
           output logic branch_selected,
           output logic branch_full,
           
           /*Signals specific to load store reservation station*/
           output logic[$clog2(ROB):0] load_rob,
           output logic[W:0] load_op1,load_op2,
           output logic[C:0] load_mode,
           output logic load_selected,
           output logic loadstore_full,
           
           output logic[$clog2(ROB):0] store_rob,
           output logic[W:0] store_op1,store_op2,
           output logic[C:0] store_mode,
           output logic[W:0] store_data,
           output logic store_selected,
           
           /*Jal instruction writes directly into its
           arbitration buffer*/
           output logic jal_request,
           output logic[$clog2(ROB):0] jal_rob,
           output logic[W:0] jal_data
          
          );
          logic[$clog2(ROB)+1:0] src1_booking,src2_booking; 
          /*Register status tables*/
          register_status_table rst(.clk(clk),
                                    .reset(reset),
                                    .regwrite(write_reg),
                                    .instr_commit(instr_commit),
                                    .pipeline_reset(reset_pipeline),
                                    .commit_reg(commit_reg),
                                    .dest_reg(rd),
                                    .src1_reg(rs1),
                                    .src2_reg(rs2),
                                    .instr_rob(instr_rob),
                                    .reset_rob(reset_rob),
                                    .read_ptr(read_ptr),
                                    .src1_booking(src1_booking),
                                    .src2_booking(src2_booking));
          
          logic[W:0] reg_src1, reg_src2;
          register_file regFile1(.clk(clk),
                                 .reg_write(commit_reg_write),
                                 .rd_addr(rs1),
                                 .wr_addr(commit_reg),
                                 .wr_data(commit_result),
                                 .reg_data(reg_src1));
          
          register_file regFile2(.clk(clk),
                                 .reg_write(commit_reg_write),
                                 .rd_addr(rs1),
                                 .wr_addr(commit_reg),
                                 .wr_data(commit_result),
                                 .reg_data(reg_src2));
                                 
          /*
          With asynchronous read on register
          status file we have write-through behaviour for
          reads. At input stage of reservation station
          the reservation station checks to see if there
          exists an instruction about to commit for which
          current instruction's operands were dependent on
          */
          riu_rs riu_station(.clk(clk),
                             .reset(reset),
                             .reset_pipeline(reset_pipeline),
                             .read_ptr(read_ptr),
                             .rob_entry(instr_rob),
                             .src1_booking(src1_booking),
                             .src2_booking(src2_booking),
                             .is_lui(lui),
                             .is_auipc(auipc),
                             .station_request(riu_req),
                             .op_control(op_control),
                             .rs1(reg_src1),
                             .rs2(reg_src2),
                             .commit_rob(commit_rob),
                             .execution_rob(execution_rob),
                             .reset_rob(reset_rob),
                             .commit_result(commit_result),
                             .execution_result(execution_result),
                             .instr_commit(instr_commit),
                             .instr_executed(instr_executed),
                             .riu_rob(riu_rob),
                             .riu_op1(riu_op1),
                             .riu_op2(riu_op2),
                             .riu_mode(riu_mode),
                             .riu_selected(riu_selected),
                             .rs_full(riu_full));
          
          jalr_rs jalr_station(.clk(clk),
                             .reset(reset),
                             .reset_pipeline(reset_pipeline),
                             .full_rob(full_rob),
                             .read_ptr(read_ptr),
                             .rob_entry(instr_rob),
                             .src1_booking(src1_booking),
                             .src2_booking(src2_booking),
                             .station_request(jalr_req),
                             .rs1(reg_src1),
                             .rs2(imm_ext),
                             .seq_pc(nxt_seq_pc),
                             .prediction_index(rd_index),
                             .ghr_checkpoint(ghr_snapshot),
                             
                             .execution_rob(execution_rob),
                             .reset_rob(reset_rob),
                             .execution_result(execution_result),
                             .instr_executed(instr_executed),
                             .jalr_rob(jalr_rob),
                             .jalr_op1(jalr_op1),
                             .jalr_op2(jalr_op2),
                             .jalr_mode(jalr_mode),
                             .jalr_selected(jalr_selected),
                             .jalr_prediction_index(jalr_prediction_index),
                             .jalr_ghr(jalr_ghr),
                             .jalr_seq_pc(jalr_seq_pc),
                             .rs_full(jalr_full));
         
         branch_rs branch_station(.clk(clk),
                             .reset(reset),
                             .reset_pipeline(reset_pipeline),
                             .full_rob(full_rob),
                             .read_ptr(read_ptr),
                             .rob_entry(instr_rob),
                             .src1_booking(src1_booking),
                             .src2_booking(src2_booking),
                             .station_request(branch_req),
                             .op_control({pht_state,prediction_taken,op_control}),
                             .rs1(reg_src1),
                             .rs2(reg_src2),
                             .seq_pc(nxt_seq_pc),
                             .prediction_address(pred_addr),
                             .prediction_index(rd_index),
                             .ghr_checkpoint(ghr_snapshot),
                             
                             .execution_rob(execution_rob),
                             .reset_rob(reset_rob),
                             .execution_result(execution_result),
                             .instr_executed(instr_executed),
                             .branch_rob(branch_rob),
                             .branch_op1(branch_op1),
                             .branch_op2(branch_op2),
                             .branch_mode(branch_mode),
                             .branch_selected(branch_selected),
                             .branch_prediction_index(branch_prediction_index),
                             .branch_ghr(branch_ghr),
                             .branch_seq_pc(branch_seq_pc),
                             .branch_predicted_address(branch_predicted_address),
                             .rs_full(branch_full));
        
         load_store_rs loadstore_station(.clk(clk),
                             .reset(reset),
                             .reset_pipeline(reset_pipeline),
                             .full_rob(full_rob),
                             .read_ptr(read_ptr),
                             .rob_entry(instr_rob),
                             .src1_booking(src1_booking),
                             .src2_booking(src2_booking),
                             .station_request(loadstore_req),
                             .op_control(op_control),
                             .rs1(reg_src1),
                             .rs2(reg_src2),
                             .imm(imm_ext),
                             .seq_pc(nxt_seq_pc),
                             .prediction_index(rd_index),
                             .ghr_checkpoint(ghr_snapshot),
                             
                             .commit_rob(committed_store_rob),
                             .execution_rob(execution_rob),
                             .reset_rob(reset_rob),
                             .execution_result(execution_result),
                             .instr_commit(store_committed),
                             .instr_executed(instr_executed),
                             .load_rob(load_rob),
                             .load_op1(load_op1),
                             .load_op2(load_op2),
                             .load_mode(load_mode),
                             .load_selected(load_selected),
                             .rs_full(loadstore_full),
                             
                             .store_rob(store_rob),
                             .store_op1(store_op1),
                             .store_op2(store_op2),
                             .store_data(store_data),
                             .store_mode(store_mode),
                             .store_selected(store_selected));
                             
        assign jal_request = jal;
        assign jal_rob = instr_rob;
        assign jal_data = nxt_seq_pc;                    
                             
          
          
endmodule