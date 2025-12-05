/*

Stores rob entries of instructions
writing to a specific destination
register. This implicit renaming of
registers indicates the instruction
dependency and enables out of order
execution as younger instructions know
which instruction to wait for to
receive its operands.

A committing instruction must unmark
its destination register only if no other
younger instruction marked it.

In case of branch misprediction or
after resolving JALR jump address,
all instructions younger than the JALR or
branch instruction must have their dependencies
eliminated from the register status table.
Committing instructions are by default older
than the offending branch or JALR instruction
so commits are unaffected by the pipeline reset.

If no pipeline reset, all instructions 
will mark the destination register with
their ROB entry.
 */
module register_status_table #(parameter DEPTH = 32, ROB = 32) 
    (input logic clk,
    input logic reset,
    input logic reg_write,instr_commit,pipeline_reset,
    input logic [$clog2(DEPTH)-1:0] commit_reg, dest_reg, src1_reg, src2_reg,
    /*Read_ptr is for determining instruction age,
    reset_rob is rob entry of branch or jalr instruction
    requesting pipeline reset and instr_rob is rob entry
    of instruction accessing the register status table*/
    input logic [$clog2(ROB):0] instr_rob,reset_rob,read_ptr,
    output logic [$clog2(ROB)+1:0] src1_booking, src2_booking);

    /*Each entry stores {valid bit, rob entry} for
    32 registers*/
    logic [$clog2(ROB)+1:0] mem[DEPTH-1:0];
    
    /*In case of pipeline reset search
    through status table and eliminate markings of
    instructions older than the resetting instruction*/
    logic[DEPTH-1:0] remove_entry;
    always_comb begin
        remove_entry = '0;
        if(pipeline_reset)begin
            for(int i = 0; i < DEPTH;i++)begin
                if(reset_rob[$clog2(ROB)] == read_ptr[$clog2(ROB)])begin
                    if((mem[i][$clog2(ROB)] != reset_rob[$clog2(ROB)]) ||
                     (mem[i][$clog2(ROB)] == reset_rob[$clog2(ROB)]) 
                        & (mem[i][$clog2(ROB)-1:0] > reset_rob[$clog2(ROB) - 1:0]))begin
                            remove_entry[i] = '1;
                    end
                end
                else begin
                    if((mem[i][$clog2(ROB)] == reset_rob[$clog2(ROB)]) && 
                        (mem[i][$clog2(ROB)-1:0] > reset_rob[$clog2(ROB) - 1:0]))begin
                            remove_entry[i] = '1;
                    end
                end
            end
        end
    end
    
    /*Organizing writes to register
    status table*/
    always_ff @(posedge clk) begin
        if (reset) begin
            for (int i = 0; i < DEPTH; i++) begin
                mem[i] <= '0;
            end
        end 
        
        else begin
            for (int i = 0; i < DEPTH; i++)begin
                /*If entry is marked by instruction younger than 
                that requesting pipeline reset then no new writes
                occur. If no pipeline reset, then if entry corresponds
                to destination register of instruction in stage then
                entry is marked. Otherwise committing instruction
                unmarks the register and if none of the above
                entry remains the same*/
                mem[i] <= (remove_entry[i]) ? '0 : ((dest_reg == i) & reg_write & !pipeline_reset) ?
                    {1'b1,instr_rob} : ((commit_reg == i) & instr_commit) ? '0 : mem[i];
            end
       end
    end

    /*Asynchronous table reads with forwarding
    in case committing instruction unmarks its
    destination register when another instruction
    requires the same register for its operands*/
    always_comb begin
        src1_booking = mem[src1_reg];
        src2_booking = mem[src2_reg];  
    end
       
endmodule
