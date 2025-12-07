/*
Second decode stage
where immediate field of
instruction is extended, precise
execution operation to be performed
by instruction and
instruction operand dependency
are determined and a signal for
pipeline fix in case of jal instruction
or misdirected branch is made
*/


module IDS2 #(parameter W = 31, I = 7, C = 3)
    (input logic clk,reset,reset_pipeline,freeze,
     input logic reg_write,
     input logic branch,

     input logic[2:0] imm_src,
     input logic[1:0] execution_op,
     input logic ri_station,jalr_station,loadstore_station,branch_station,
     input logic mem_write,is_jal,use_imm,
     input logic is_jalr,rob_write,
     input logic is_lui,is_auipc,
     input logic is_load,is_store,
    
     input logic[W:0] branch_addr,jal_addr,
     input logic redirected,
     input logic[W:0] pc,instruction,
     input logic[W:0] predicted_addr,
     input logic[I:0] table_index,ghr_snaps,
     input logic[1:0] table_state,
     
     
     
     output logic[3:0] op_control,
     
     output logic[I:0] rd_index,ghr_snapshot,
     output logic[1:0] pht_state,
     /*For JAL instruction which write to a register
     rd, for branch and jalr instruction for
     pipeline recovery*/
     output logic[W:0] nxt_pc,pred_addr,
     /*We fix pipeline here in case of JAL
     and branch instructions*/
     output logic fix,
     output logic[W:0] fix_addr,
     
     output logic ri_req,jalr_req,loadstore_req,branch_req,
     output logic write_mem,jal,take_imm,
     output logic jalr,write_rob,
     output logic lui,auipc,
     output logic load,store,
     output logic is_branch,write_reg,
    
     output logic prediction_taken,
     
     output logic[4:0] rd,rs1,rs2,
     output logic[W:0] imm_ext
    );
    
    logic[3:0] op_control_next;
    
    /*Determine execution operation*/
    execution_op opmaker(.funct7(instruction[30]),
                         .funct3(instruction[14:12]),
                         .execute_op(execution_op),
                         .op_control(op_control_next));
    
    /*Extend the immediate field for the instruction*/
    logic[W:0] immExt_next;
    extender extend(.imm(instruction[W:7]),
                    .immSrc(imm_src),
                    .immExt(immExt_next));
    
    /*Pipeline fix for JAL and branch instruction*/
    logic fix_next;
    logic[W:0] fix_addr_next;
    always_comb begin
        fix_next = (is_jal | ((branch_addr != predicted_addr) & redirected & branch));
        fix_addr_next = (is_jal) ? jal_addr : branch_addr;
    end
    
    logic fix_flush;
    fix_flush fixer(.clk(clk),
                    .reset(reset),
                    .freeze(freeze),
                    .reset_pipeline(reset_pipeline),
                    .fix(fix),
                    .fix_flush(fix_flush));
    
    
    /*Register values*/
    logic[4:0] rs1_next,rs2_next,rd_next;
    assign rs1_next = instruction[19:15];
    assign rs2_next = instruction[24:20];
    assign rd_next = instruction[11:7];
    
    logic prediction_taken_next;
    assign prediction_taken_next = redirected & branch;
    /*Output register*/
    always_ff @(posedge clk)begin
        if(reset | reset_pipeline | fix_flush)begin
            nxt_pc <= '0;
            op_control <= '0;
            rd_index <= '0;
            ghr_snapshot <= '0;
            pht_state <= '0;
            fix <= '0;
            fix_addr <= '0;
            ri_req <= '0;
            jalr_req <= '0;
            loadstore_req <= '0;
            branch_req <= '0;
            write_mem <= '0;
            jal <= '0;
            take_imm <= '0;
            jalr <= '0;
            write_rob <= '0;
            lui <= '0;
            auipc <= '0;
            load <= '0;
            store <= '0;
            prediction_taken <= '0;
            write_reg <= '0;
            is_branch <= '0;
            rd <= '0;
            rs1 <= '0;
            rs2 <= '0;
            imm_ext <= '0;
            pred_addr <= '0;
        end
        
        else if(freeze)begin
            nxt_pc <= nxt_pc;
            op_control <= op_control;
            rd_index <= rd_index;
            ghr_snapshot <= ghr_snapshot;
            pht_state <= pht_state;
            fix <= fix;
            fix_addr <= fix_addr;
            ri_req <= ri_req;
            jalr_req <= jalr_req;
            loadstore_req <= loadstore_req;
            branch_req <= branch_req;
            write_mem <= write_mem;
            jal <= jal;
            take_imm <= take_imm;
            jalr <= jalr;
            write_rob <= write_rob;
            lui <= lui;
            auipc <= auipc;
            load <= load;
            store <= store;
            prediction_taken <= prediction_taken;
            write_reg <= write_reg;
            is_branch <= is_branch;
            rd <= rd;
            rs1 <= rs1;
            rs2 <= rs2;
            imm_ext <= imm_ext;
            pred_addr <= pred_addr;
        end
        
        else begin
            nxt_pc <= pc;
            op_control <= op_control_next;
            rd_index <= table_index;
            ghr_snapshot <= ghr_snaps;
            pht_state <= table_state;
            fix <= fix_next;
            fix_addr <= fix_addr_next;
            ri_req <= ri_station;
            jalr_req <= jalr_station;
            loadstore_req <= loadstore_station;
            branch_req <= branch_station;
            write_mem <= mem_write;
            jal <= is_jal;
            take_imm <= use_imm;
            jalr <= is_jalr;
            write_rob <= rob_write;
            lui <= is_lui;
            auipc <= is_auipc;
            load <= is_load;
            store <= is_store;
            prediction_taken <= prediction_taken_next;
            write_reg <= reg_write;
            is_branch <= branch;
            rd <= rd_next;
            rs1 <= rs1_next;
            rs2 <= rs2_next;
            imm_ext <= immExt_next;
            pred_addr <= predicted_addr;
        end
    end
            
            
    
endmodule
