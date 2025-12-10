/*
Pipeline reset_arbitrer considers pipeline
reset requests from branch instructions and
jalr instructions. When branch and jalr 
instructions are sent to their execution
units, the pipeline_reset_arbitrer picks
up their rob entries and determines which
one is older. If branch was mispredicted
then it can only reset the pipeline if the
jalr instruction in pipeline is
younger than it. If the jalr instruction 
was older then it resets the pipeline
instead.

Since global history register is updated
prior to instruction commit,reflects
the outcome of the most recent n branches,
and is reset in case of branch misprediction,
we use this module to organize updates to the
ghr.

Note once a pipeline reset is determined as
required the signal is sent out in next cycle.
This signal prevents removes entries from
reservations stations, adjusts the reorder
buffers write pointer to clear out recent
writes, removes register markings and prevents
any new instruction from being selected. However an
instruction may have been selected for execution in
the cycle it was determined that a pipeline reset
is needed. Thus if a pipeline reset is sent out
in a prior cycle, we must store the resetting rob
so as to determine if a new reset is justified 
*/

module pipeline_reset_arbitrer #(parameter W = 31,ROB = 32,I = 7)
    (input logic[$clog2(ROB):0] jalr_rob,branch_rob,read_ptr,
     /*Are there branch or jalr instructions currently
     being executed*/
     input logic is_jalr,is_branch,
     input logic clk,reset,
     /*Ghr checkpoints for branch and jalr instructions*/
     input logic[I:0] branch_ghr_checkpoint,jalr_ghr_checkpoint,
     input logic taken_branch,
     /*Jalr instruction computes jump address
     in its execution unit and provides result to
     pipeline_reset_arbiter. Thus pipeline_reset_arbiter
     lengthens the critical path by the addition
     of a multiplexer at the end stage to
     determine reset address*/
     input logic[W:0] jalr_address,branch_address,
     /*Branch instructions alter control flow if
     condition is taken. Jump instructions jal,jalr
     always alter control flow*/
     input logic misprediction,
     output logic[W:0] reset_addr,
     /*GHR checkpoint is updated before instruction
     commit, in case of incorrect branch */
     output logic[I:0] ghr_recovered,
     
     /*Signal to reset the pipeline*/
     output logic reset_pipeline,
     /*Update ghr with result of conditional
     instruction*/
     output logic conditional_taken,
     /*GHR can only be updated by branch instruction
     that's executed and in absence of pipeline
     reset*/
     output logic update_ghr,
     /*ROB entry of instruction requesting
     pipeline reset*/
     output logic[$clog2(ROB):0] reset_rob
    );
    
    logic[I:0] ghr_recovered_next;
    logic reset_pipeline_next;
    logic[W:0] reset_addr_next;
    logic conditional_taken_next;
    logic update_ghr_next;
    
    typedef enum{base,active} state_type;
    (* keep = "true" *) state_type state, state_next;
    
    logic[$clog2(ROB):0] rob,rob_next,reset_rob_next;
    
    always_ff @(posedge clk)begin
        if(reset)begin
            reset_pipeline <= '0;
            conditional_taken <= '0;
            reset_addr <= '0;
            ghr_recovered <= '0;
            update_ghr <= '0;
            
            state <= base;
            rob <= '0;
            reset_rob <= '0;
        end
        
        else begin
            reset_pipeline <= reset_pipeline_next;
            conditional_taken <= conditional_taken_next;
            reset_addr <= reset_addr_next;
            ghr_recovered <= ghr_recovered_next;
            update_ghr <= update_ghr_next;
            
            state <= state_next;
            rob <= rob_next;
            reset_rob <= reset_rob_next;
        end
    end
    
    logic is_jalr_older,is_branch_older;
    
    /*Check to see if current branch instruction
    is older than previous resetting instruction*/
    always_comb begin
        is_jalr_older = is_jalr;
        if(rob[$clog2(ROB)] == read_ptr[$clog2(ROB)])begin
            if((jalr_rob[$clog2(ROB)] != rob[$clog2(ROB)]) ||
                (jalr_rob[$clog2(ROB)] == rob[$clog2(ROB)]) &  
                    (jalr_rob[$clog2(ROB)-1:0] > rob[$clog2(ROB) - 1:0]))begin
                            is_jalr_older = '0;           
            end
        end
        else begin
            if((jalr_rob[$clog2(ROB)] == jalr_rob[$clog2(ROB)]) && 
                (jalr_rob[$clog2(ROB)-1:0] >  jalr_rob[$clog2(ROB) - 1:0]))begin
                    is_jalr_older = '0;
            end
        end        
    end
    
    /*Check to see if current branch instruction
    is older than previous resetting instruction*/
    always_comb begin
        is_branch_older = is_branch;
        if(rob[$clog2(ROB)] == read_ptr[$clog2(ROB)])begin
            if((branch_rob[$clog2(ROB)] != rob[$clog2(ROB)]) ||
                (branch_rob[$clog2(ROB)] == rob[$clog2(ROB)]) &  
                    (branch_rob[$clog2(ROB)-1:0] > rob[$clog2(ROB) - 1:0]))begin
                            is_branch_older = '0;           
            end
        end
        else begin
            if((branch_rob[$clog2(ROB)] == branch_rob[$clog2(ROB)]) && 
                (branch_rob[$clog2(ROB)-1:0] >  branch_rob[$clog2(ROB) - 1:0]))begin
                    is_branch_older = '0;
            end
        end        
    end
    
    /*Compare current branch instruction and jalr instruction
    to see which one is older*/
    logic branch_over_jalr;
    always_comb begin
        branch_over_jalr = '0;
        if(branch_rob[$clog2(ROB)] == read_ptr[$clog2(ROB)])begin
            if((jalr_rob[$clog2(ROB)] != branch_rob[$clog2(ROB)]) ||
                (jalr_rob[$clog2(ROB)] == branch_rob[$clog2(ROB)]) &  
                    (jalr_rob[$clog2(ROB)-1:0] > branch_rob[$clog2(ROB) - 1:0]))begin
                        branch_over_jalr = '1;                     
            end
        end
        else begin
            if((jalr_rob[$clog2(ROB)] == branch_rob[$clog2(ROB)]) && 
                (jalr_rob[$clog2(ROB)-1:0] >  branch_rob[$clog2(ROB) - 1:0]))begin
                    branch_over_jalr = '1;           
            end
        end    
    end
    
    /*Branch instruction in pipeline signals whether conditional
    was taken or not and updates ghr if no pipeline reset is
    required*/
    assign conditional_taken_next = taken_branch;
    always_comb begin
        update_ghr_next = '0;
        state_next = state;
        ghr_recovered_next = jalr_ghr_checkpoint;
        reset_pipeline_next = '0;
        reset_addr_next = jalr_address;
        rob_next = jalr_rob; 
        reset_rob_next = rob_next;
        case(state)
            /*Compare branch and jalr instruction
            and signal appropriate pipeline reset*/
            base:begin
                ghr_recovered_next = (branch_over_jalr & misprediction & is_branch) 
                    ? branch_ghr_checkpoint : jalr_ghr_checkpoint;
                reset_addr_next = (branch_over_jalr & misprediction & is_branch) ? branch_address 
                    : jalr_address;
                reset_pipeline_next = (branch_over_jalr & misprediction & is_branch) ? '1 : 
                    is_jalr;
                rob_next = (branch_over_jalr & misprediction & is_branch) ? branch_rob : jalr_rob;
                state_next = (is_jalr | is_branch & misprediction) ? active : base;
                update_ghr_next = (is_branch) ? '1 : '0; 
             end
             
             /*After previous pipeline reset, compare stored rob
             with new entrant to determine oldest.*/ 
             active:begin
                /*Neither of the new entrants is older. No new reset
                is signalled. Current instructions do nothing*/
                case({is_jalr_older,is_branch_older})
                    /*Neither jalr nor branch are older
                    than previous instruction*/
                    2'b00:begin
                        state_next = base;
                        reset_pipeline_next = '0;
                        update_ghr_next = '0; 
                    end
                    
                    /*Branch is older*/
                    2'b01:begin
                        state_next = (misprediction) ? active : base;
                        rob_next = branch_rob;
                        reset_pipeline_next = misprediction;
                        ghr_recovered_next = branch_ghr_checkpoint;
                        reset_addr_next = branch_address;
                        update_ghr_next = '1; 
                    end
                    
                    /*Jalr is older*/
                    2'b10:begin
                        state_next = active;
                        rob_next = jalr_rob;
                        reset_pipeline_next = '1;
                        ghr_recovered_next = jalr_ghr_checkpoint;
                        reset_addr_next = jalr_address;
                        update_ghr_next = '0;   
                    end
                    
                    /*Jalr and branch compete*/
                    2'b11:begin
                        state_next = (branch_over_jalr & is_branch & misprediction | is_jalr) ? active 
                            : base;
                        rob_next = (branch_over_jalr & is_branch & misprediction) ? branch_rob : jalr_rob;
                        reset_pipeline_next = (branch_over_jalr & is_branch & misprediction) ? '1 
                            : is_jalr;
                        ghr_recovered_next = (branch_over_jalr & is_branch & misprediction) ? 
                            branch_ghr_checkpoint : jalr_ghr_checkpoint;
                        reset_addr_next = (branch_over_jalr & is_branch & misprediction) ? 
                            branch_address : jalr_address;
                        update_ghr_next = is_branch;
                    end
                    
                    /*default*/
                    default:begin
                        state_next = base;
                        reset_pipeline_next = '0;
                        update_ghr_next = '0;
                        rob_next = jalr_rob;  
                    end
                endcase  
             end
             
             default:begin
                update_ghr_next = '0;
                state_next = state;
                ghr_recovered_next = jalr_ghr_checkpoint;
                reset_pipeline_next = '0;
                reset_addr_next = jalr_address;
                rob_next = jalr_rob;   
             end
        endcase
    end
endmodule
