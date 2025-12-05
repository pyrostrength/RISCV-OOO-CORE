/*
Unified reservation station for
R and I type instructions.

No forwarding is provided for instructions
that are ready to execute and writing
to the reservation station.

Station entry fields are ROB entry
of instruction,source operand values,
ready bits indicating if source operand are
valid, ROB entry of instruction
that writes to each source operand register, 
valid bit indicating validity of entry and
auxillary info for the execution and identification
in form {jal,is_lui,is_auipc}. Instruction writes
into first open entry at the top of the reservation
station.

When instruction completes execution and
writes to CDB its entry is marked for removal.
If a pipeline reset occurs due to branch misprediction
or resolving JALR target address then no
new entry is allocated and entries later in
program order than executed branch/jalr instruction
are marked for removal.

All entries, even those to be removed,
capture broadcasts on common data bus. This greatly
simplifies the design as removal amounts to zeroing
out the entry valid bit.

When all source operands are ready an instruction
requests execution and selection is on a last in
first out policy.

*/

module ri_rs #(parameter ROB = 32,RS = 16, W = 31,C = 3)
    (input clk,
    input reset,
    input reset_pipeline,full_rob,
    /*To determine position of instructions
    within program order in case of a pipeline
    flush*/
    input logic[$clog2(ROB):0] read_ptr,
    /*ROB entry of instruction*/
    input logic[$clog2(ROB):0] rob_entry,
    /*For instruction writing to reservation station*/
    /*ROB allocations for the source operands*/
    //+1 because rob entry has additional bit to
    //help determine relative position within fifo stack.
    input logic[$clog2(ROB)+1:0] src1_booking,src2_booking,
    /*Control signals to determine what functional unit
    to go to and what operation to perform in functional unit*/
    input logic station_request,
    input logic[C:0] op_control,
    /*Source operand values to choose from*/
    input logic[W:0] rs1, rs2,
    /*Execution and commit prefix are for executing
    and committing instruction*/
    input logic[$clog2(ROB):0] execution_rob,reset_rob,
    input logic[W:0] execution_result,
    /*instr_executed are control
    signals to indicate an instruction executed
    and wrote result to CDB*/
    input logic instr_executed,
    /*There are 5 selector buses attached to this
    reservation station, one for load/stores,
    one for. Instructions selected go out with
    their rob entries*/
    output logic[$clog2(ROB):0] ri_rob,
    
    /*And operand values*/
    output logic[W:0] ri_op1,ri_op2,
    
    /*And control values for operation*/
    output logic[3:0]ri_mode,
    
    /*And signal to validate instr results when it writes
    on common data bus*/
    output logic ri_selected,
    
    output logic rs_full
    );
    
    /*Store validity of rob entry*/
    logic valid_storage[RS - 1:0];
    
    /*Store rob entry of instruction*/
    logic[$clog2(ROB):0] tag_storage[RS - 1:0];
    
    /*Store the source operands rob entry*/
    logic[$clog2(ROB):0] rob1_storage[RS - 1:0];
    logic[$clog2(ROB):0] rob2_storage[RS - 1:0];
    
    /*Store readiness of source operand*/
    logic ready1_storage[RS - 1:0];
    logic ready2_storage[RS - 1:0];
    
    /*Store values*/
    logic[W:0] value1_storage[RS - 1:0];
    logic[W:0] value2_storage[RS - 1:0];
    
    /*Decoding info*/
    logic[C:0] decodeinfo_storage[RS - 1:0];
    
    /*Find entries to remove upon pipeline reset*/
    logic[RS-1:0] remove_entry;
    always_comb begin
        remove_entry = '0;
        for(int i = 0; i < RS; i++)begin
            if(reset_pipeline) begin
                if(reset_rob[$clog2(ROB)] == read_ptr[$clog2(ROB)])begin
                    if((tag_storage[i][$clog2(ROB)] != reset_rob[$clog2(ROB)]) || 
                    (tag_storage[i][$clog2(ROB)] == reset_rob[$clog2(ROB)]) &
                        (tag_storage[i][$clog2(ROB)-1:0] > reset_rob[$clog2(ROB) - 1:0]))begin
                            remove_entry[i] = '1;
                    end
                end
                else begin
                    if((tag_storage[i][$clog2(ROB)] == reset_rob[$clog2(ROB)]) && 
                        (tag_storage[i][$clog2(ROB)-1:0] > reset_rob[$clog2(ROB) - 1:0]))begin
                            remove_entry[i] = '1;
                    end
                end
            end
        end
    end
                        
    /*Select first open entry to write to iff
    reorder buffer isn't currently full, an
    instruction requested a station write and there
    exists an empty entry*/
    logic[RS-1:0] first_open_entry;
    
    always_comb begin
        first_open_entry = '0;
        rs_full = '1;
        for(int i = 0; i < RS; i++)begin
            if(!valid_storage[i])begin
                first_open_entry[i] = '1;
                rs_full = '0;
                break; 
            end
        end
    end
    
    /*Signal that indicates if conditions for writing
    exist*/
    logic can_write;
    assign can_write = !full_rob & station_request & !reset_pipeline;
                        
    /*Select entries for which execution result is
    ready and highlight respective operand to
    which result should go to*/
    logic[RS-1:0] src1_result_ready;
    logic[RS-1:0] src2_result_ready;
    always_comb begin
        src1_result_ready = '0;
        src2_result_ready = '0;
        for(int i = 0; i < RS; i++)begin
            src1_result_ready[i] = instr_executed & !ready1_storage[i] 
                & (rob1_storage[i] == execution_rob) & valid_storage[i];
            src2_result_ready[i] = instr_executed & !ready2_storage[i] 
                & (rob2_storage[i] == execution_rob) & valid_storage[i]; 
        end  
    end
    
    /*Select entry for execution*/
    logic[RS-1:0] selected_instr;
    logic instr_found;
                        
    /*Instr info*/
    logic[W:0] op1,op2;
    logic[$clog2(ROB):0] rob;
    logic[C:0] mode;
    
    always_comb begin
        selected_instr = '0;
        instr_found = '0;
        mode = '0;
        rob = '0;
        {op1,op2} = '0;
        for(int i = RS -1; i >= 0; i--)begin
            if(valid_storage[i] & ready1_storage[i] & ready2_storage[i] & !reset_pipeline)begin
                selected_instr[i] = '1;
                instr_found = '1;
                rob = tag_storage[i];
                op1 = value1_storage[i];
                op2 = value2_storage[i];
                mode = decodeinfo_storage[i];
                break;
            end
        end
    end
                        
    
    
    /*Write logic*/
    always_ff @(posedge clk)begin
        if(reset)begin
            for(int i = 0; i < RS ; i++)begin
               valid_storage[i] <= '0;
               tag_storage[i] <= '0;
               rob1_storage[i] <= '0;
               rob2_storage[i] <= '0;
               decodeinfo_storage[i] <= '0;
               value1_storage[i] <= '0;
               value2_storage[i] <= '0;
               ready1_storage[i] <= '0;
               ready2_storage[i] <= '0; 
            end
        end
        
        else begin
            /*In all cases entries in reservation station
            snip in values broadcast on CDB even if the
            entry is to be invalidated. So long as valid bit
            of entry is 0 whatever value snipped in doesn't matter
            and when instruction writes to reservation station entry
            it overrwrites all fields*/
            for(int i = 0; i < RS; i++)begin
                valid_storage[i] <= (remove_entry[i] | selected_instr[i] ) ? '0 
                    : (first_open_entry[i] & can_write) ? '1 : valid_storage[i];
                    
                value1_storage[i] <= (first_open_entry[i] & can_write) ? rs1 : 
                    (src1_result_ready[i]) ? execution_result : value1_storage[i];
                
                value2_storage[i] <= (first_open_entry[i] & can_write) ? rs2 : 
                    (src2_result_ready[i]) ? execution_result : value2_storage[i];
                    
                ready1_storage[i] <= (first_open_entry[i] & can_write) ? src1_booking[$clog2(ROB)+1] : 
                    (src1_result_ready[i]) ? '1 : ready1_storage[i];
                    
                ready2_storage[i] <= (first_open_entry[i] & can_write) ? src2_booking[$clog2(ROB)+1] : 
                    (src2_result_ready[i]) ? '1 : ready2_storage[i];
                                    
                tag_storage[i] <= (first_open_entry[i] & can_write) 
                    ? rob_entry : tag_storage[i];
                                    
                rob1_storage[i] <= (first_open_entry[i] & can_write) 
                    ? src1_booking[$clog2(ROB):0] :
                    rob1_storage[i];
                                    
                rob2_storage[i] <= (first_open_entry[i] & can_write) 
                    ? src2_booking[$clog2(ROB):0] :
                    rob2_storage[i];
                
                decodeinfo_storage[i] <= (first_open_entry[i] & can_write) 
                    ? op_control : decodeinfo_storage[i];
                  
            end
                        
        end
    end
    
    
    /*Selection Logic*/
    always_ff@(posedge clk) begin
        if(reset)begin
            {ri_selected,ri_mode,ri_rob} <= '0;
            {ri_op2,ri_op1} <= '0;  
        end
        
        else begin
            ri_selected <= instr_found;
            ri_mode <= mode;
            ri_op1 <= op1;
            ri_op2 <= op2;
            ri_rob <= rob;
        end 
    end
    
endmodule