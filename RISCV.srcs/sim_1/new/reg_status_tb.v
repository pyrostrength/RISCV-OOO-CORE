/*
Testbench for the register
status table
*/

module reg_status_tb #(parameter DEPTH = 32, ROB = 32)
    (

    );
    logic clk,reset,pipeline_reset,reg_write,instr_commit;
    logic [$clog2(DEPTH)-1:0] commit_reg, dest_reg, src1_reg, src2_reg;
    logic [$clog2(ROB):0] instr_rob,reset_rob,read_ptr;
    logic [$clog2(ROB)+1:0] src1_booking, src2_booking;
    
    
    register_status_table rst(.*);
    
    always begin
        #5 clk = ~clk;
    end
    
    
    
    `timescale 1ns/1ps;
    function automatic int relative_age(input logic[$clog2(ROB):0] head,
        input logic[$clog2(ROB):0] rob1, input logic[$clog2(ROB):0]rob2);
        if(rob1 == rob2) begin
            return 1;
        end
        else begin
            if(rob1[$clog2(ROB)] == head[$clog2(ROB)])begin
                if((rob2[$clog2(ROB)] != rob1[$clog2(ROB)]) | (rob2[$clog2(ROB)] == rob1[$clog2(ROB)]) 
                         & (rob2[$clog2(ROB)-1:0] > rob1[$clog2(ROB) - 1:0]))begin
                            return 2;
                end
            end
            else begin
                if((rob2[$clog2(ROB)] == rob1[$clog2(ROB)]) && 
                        (rob2[$clog2(ROB)-1:0] > rob1[$clog2(ROB) - 1:0]))begin
                            return 2;
                end
            end
        end    
        return 0;
    endfunction
    /*Head of ROB ,rob entry of instruction
    and committing instruction are constrained.
    Reset ROB is younger than or just as old as
    the current head of ROB, head of ROB is older
    than instr_rob*/
    class Rob_Entries;
        rand logic[$clog2(ROB):0] instr_rob;
        rand logic[$clog2(ROB):0] reset_rob;
        static rand logic[$clog2(ROB):0] read_ptr;
        
        constraint relative_ages {
            /*Reset rob has to be older than instruction rob &
            read_ptr cannot be younger than reser_rob*/
            (relative_age(read_ptr,reset_rob,instr_rob) == 2) &
            (relative_age(read_ptr,read_ptr,reset_rob) != 0);
        }
    endclass
    
    /*Randomize the inputs subject to 
    constraints*/
    class Rand_Inputs;
        rand logic reset;
        rand logic pipeline_reset;
        rand logic reg_write;
        rand logic instr_commit;
        rand logic[$clog2(DEPTH)-1:0] commit_reg,dest_reg,src1_reg,src2_reg;
        
        /*Implication operator for constraints*/
        /*If dest reg equals 0 ensure reg_write is 0*/
        constraint writing_registers {(dest_reg == 0) -> (reg_write == 0);}
        
    endclass
    
    /*Copy of internal memory array, remains static across
    task invocations*/
    logic[$clog2(ROB)+1:0] copy_array[DEPTH-1:0];
    /*Index of items to be removed as a result of pipeline reset*/
    int removed_items[$];
    /*Initially filled with all zeroes*/
    initial begin
        foreach(copy_array[i])begin
            copy_array[i] = '0;
        end
    end
    
    /*
    Correct model of RST device is created
    and randomized inputs are applied to both
    DUT and ideal model.
    */
    task automatic run_rst;
        /*Randomize conditions*/
        Rob_Entries robs;
        Rand_Inputs inputs;
        robs = new();
        inputs = new();
        robs.randomize();
        inputs.randomize();
        
        instr_rob = robs.instr_rob;
        reset_rob = robs.reset_rob;
        read_ptr = robs.read_ptr;
        
        reset = inputs.reset;
        pipeline_reset = inputs.pipeline_reset;
        reg_write = inputs.reg_write;
        instr_commit = inputs.instr_commit;
        commit_reg = inputs.commit_reg;
        dest_reg = inputs.dest_reg;
        src1_reg = inputs.src1_reg;
        src2_reg = inputs.src2_reg;
        
        /*Initialize removed items array with
        all zeros*/
        foreach(removed_items[i])begin
            removed_items[i] = '0;
        end
        
        #2;
        /*A global reset clears all entries of register
        status table*/
        if(reset)begin
            /*Clear copy array's entries*/
            foreach(copy_array[i])begin
                copy_array[i] = '0;
            end
            #8;
        end
        
        /*If pipeline reset all instructions younger than reset_rob are
        removed, no write occurs to buffer, committing
        instruction falls thru*/
        else if(pipeline_reset)begin
            /*Remove entries from copy array. Find indices of
            entries to be removed*/
            foreach(copy_array[i])begin
                if(relative_age(read_ptr,reset_rob,copy_array[i][$clog2(ROB):0])==2)begin
                    removed_items.push_back(i);
                    copy_array[i] = '0;
                end
                else if((i == commit_reg) & instr_commit)begin
                    copy_array[i] = '0;
                end
            end
            #8;
        end
        
        /*If no pipeline reset, writes fall thru*/
        else begin
            if(reg_write)begin
                copy_array[dest_reg] = {'1,instr_rob};
                if(instr_commit & (commit_reg != dest_reg))begin
                    copy_array[commit_reg] = '0;
                end
            end
            
            else begin
                if(instr_commit)begin
                    copy_array[commit_reg] = '0;
                end
            end
            #8;  
        end     
    endtask
    
    task automatic check_rst;
        /*Whatever the value for src1_reg or src2_reg are
        ensure that the value between ideal model and
        real model are equal*/
        assert(src1_booking == copy_array[src1_reg]) 
        else begin
            /*Determine mismatch condition*/
            if(reset)begin
                $display("Global reset hasn't cleared out markings");
            end
            else if(pipeline_reset) begin
                if (src1_reg inside removed_items)begin
                    $display("Pipeline reset hasn't cleared out entry");
                end
                else if(instr_commit & (commit_reg == src1_reg))begin
                    $display("Commit hasn't cleared out its markings under pipeline reset");
                end
                else begin
                    $display("Issue might be downstream of previous cycles");
                end    
            end
            
            else begin
                if(reg_write & (dest_reg == src1_reg))begin
                    $display("Instruction didn't mark its entry");
                end
                else if(instr_commit & (commit_reg == src1_reg))begin
                    $display("Commit hasn't cleared out its entry in absence of register write or pipeline reset");
                end
                else begin
                    $display("Might be an error downstream of prior cycles");
                end
            end
        end
            
        assert(src2_booking == copy_array[src2_reg]) 
        else begin
            /*Determine mismatch condition*/
            if(reset)begin
                $display("Global reset hasn't cleared out markings");
            end
            else if(pipeline_reset) begin
                if (src2_reg inside removed_items)begin
                    $display("Pipeline reset hasn't cleared out entry");
                end
                else if(instr_commit & (commit_reg == src2_reg))begin
                    $display("Commit hasn't cleared out its markings under pipeline reset");
                end
                else begin
                    $display("Issue might be downstream of previous cycles");
                end    
            end
            
            else begin
                if(reg_write & (dest_reg == src2_reg))begin
                    $display("Instruction didn't mark its entry");
                end
                else if(instr_commit & (commit_reg == src2_reg))begin
                    $display("Commit hasn't cleared out its entry in absence of register write or pipeline reset");
                end
                else begin
                    $display("Might be an error downstream of prior cycles");
                end
            end
        end  
    endtask
    
    initial begin
        /*Global reset initializes all synchronous
        elements to '0*/
        #100;
        clk = '1;
        /*Verification begins*/
        while($time < 10000)begin
            /*Run the register status table*/
            run_rst();
            /*Check for correctness*/
            check_rst();
        end
    end

    
endmodule
