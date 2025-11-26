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
     output logic update_ghr
    );
    
    logic[I:0] ghr_recovered_next;
    logic reset_pipeline_next;
    logic reset_addr_next;
    logic conditional_taken_next;
    logic update_ghr_next;
    
    always_ff @(posedge clk)begin
        if(reset)begin
            reset_pipeline <= '0;
            conditional_taken <= '0;
            reset_addr <= '0;
            ghr_recovered <= '0;
            update_ghr <= '0;
        end
        
        else begin
            reset_pipeline <= reset_pipeline_next;
            conditional_taken <= conditional_taken_next;
            reset_addr <= reset_addr_next;
            ghr_recovered <= ghr_recovered_next;
            update_ghr <= update_ghr_next;
        end
    end
    
    /*Branch instruction in pipeline signals whether conditional
    was taken or not and updates ghr if no pipeline reset is
    required*/
    assign conditional_taken_next = taken_branch;
    assign update_ghr_next = !reset_pipeline_next & is_branch;
    always_comb begin
        /*Age comparisons between jalr instruction
        and branch instruction. Older one
        determines reset pc if pipeline reset is
        mandated*/
        ghr_recovered_next = branch_ghr_checkpoint;
        reset_pipeline_next = misprediction;
        reset_addr_next = branch_address;
        if(jalr_rob[$clog2(ROB)] == read_ptr[$clog2(ROB)])begin
            if((branch_rob[$clog2(ROB)] != jalr_rob[$clog2(ROB)]) || 
                (branch_rob[$clog2(ROB)-1:0] >= jalr_rob[$clog2(ROB) - 1:0]))begin
                    ghr_recovered_next = jalr_ghr_checkpoint;
                    /*Pipeline reset only matters if a jalr instruction
                    actually exists in pipeline*/
                    reset_pipeline_next = is_jalr;
                    reset_addr_next = jalr_address;            
            end
        end
        else begin
            if((branch_rob[$clog2(ROB)] == jalr_rob[$clog2(ROB)]) && 
                (branch_rob[$clog2(ROB)-1:0] >= jalr_rob[$clog2(ROB) - 1:0]))begin
                    ghr_recovered_next = jalr_ghr_checkpoint;
                    /*Pipeline reset only matters if a jalr instruction
                    actually exists in pipeline*/
                    reset_pipeline_next = is_jalr;
                    reset_addr_next = jalr_address;
            end
        end
    end
endmodule
