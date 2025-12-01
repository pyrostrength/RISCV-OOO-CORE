/*
Reservation station for
JALR instructions.

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
in form {nxt_seq_pc,prediction_index,ghr_checkpoint}. 
Instruction writes into first open entry at 
the top of the reservation station.

An instruction selected for execution
marks its entry for clearing in the
subsequent cycle.

If a pipeline reset then no
new entry is allocated and appropriate entries 
are removed from reservation station.


*/

module jalr_rs #(parameter ROB = 32,RS = 4, W = 31, I = 7)
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
    /*Source operand values to choose from*/
    input logic[W:0] rs1, rs2, seq_pc,
    input logic[I:0] prediction_index,ghr_checkpoint,
    /*Execution and commit prefix are for executing
    and committing instruction*/
    input logic[$clog2(ROB):0] execution_rob,reset_rob,
    input logic[W:0] execution_result,
    /*instr_executed are control
    signals to indicate an instruction has written
    its results to CDB.*/
    input logic instr_executed,
    
    output logic[$clog2(ROB):0] jalr_rob,
    
    /*And operand values*/
    output logic[W:0] jalr_op1,jalr_op2,
    
    
    /*And signal to validate instr results when it writes
    on common data bus*/
    output logic jalr_selected,
    
    output logic[I:0] jalr_prediction_index,jalr_ghr,
    output logic[W:0] jalr_seq_pc,
    
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
    logic[2*I + 1:0] pht_storage[RS - 1:0];
    logic[W:0] seq_pc_storage[RS - 1:0];
    
    /*Find entries to remove upon pipeline reset*/
    logic[RS-1:0] remove_entry;
    always_comb begin
        remove_entry = '0;
        for(int i = 0; i < RS; i++)begin
            if(reset_pipeline) begin
                if(reset_rob[$clog2(ROB)] == read_ptr[$clog2(ROB)])begin
                    if((tag_storage[i][$clog2(ROB)] != reset_rob[$clog2(ROB)]) || 
                        (tag_storage[i][$clog2(ROB)-1:0] >= reset_rob[$clog2(ROB) - 1:0]))begin
                            remove_entry[i] = '1;
                    end
                end
                else begin
                    if((tag_storage[i][$clog2(ROB)] == reset_rob[$clog2(ROB)]) && 
                        (tag_storage[i][$clog2(ROB)-1:0] >= reset_rob[$clog2(ROB) - 1:0]))begin
                            remove_entry[i] = '1;
                    end
                end
            end
        end
    end
                        
    /*Select first open entry to write to*/
    logic[RS-1:0] first_open_entry;
    always_comb begin
        first_open_entry = '0;
        rs_full = '1;
        for(int i = 0; i < RS; i++)begin
            if(station_request & !valid_storage[i] &!full_rob)begin
                first_open_entry[i] = '1;
                rs_full = '0;
                break; 
            end
        end
    end
                        
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
                & (rob1_storage[i] == execution_rob);
            src2_result_ready[i] = instr_executed & !ready2_storage[i] 
                & (rob2_storage[i] == execution_rob); 
        end  
    end
    
    /*Select entry for execution*/
    logic[RS-1:0] selected_instr;
    logic instr_found;
                        
    /*Instr info*/
    logic[W:0] op1,op2,nxt_pc;
    logic[$clog2(ROB):0] rob;
    logic[I:0] p_index,ghr;
    
    always_comb begin
        selected_instr = '0;
        instr_found = '0;
        {p_index,ghr} = '0;
        rob = '0;
        {op1,op2,nxt_pc} = '0;
        for(int i = RS -1; i >= 0; i--)begin
            if(valid_storage[i] & ready1_storage[i] & ready2_storage[i])begin
                selected_instr[i] = '1;
                instr_found = '1;
                p_index = pht_storage[i][2*I+1:I+1];
                ghr = pht_storage[i][I:0];
                rob = tag_storage[i];
                op1 = value1_storage[i];
                op2 = value2_storage[i];
                nxt_pc = seq_pc_storage[i];
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
               pht_storage[i] <= '0;
               seq_pc_storage[i] <= '0;
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
                valid_storage[i] <= (remove_entry[i] | selected_instr[i]) ? '0 
                    : (first_open_entry[i]) ? '1 : valid_storage[i];
                    
                value1_storage[i] <= (src1_result_ready[i]) ? execution_result : 
                    (first_open_entry[i]) ? rs1 : value1_storage[i];
                
                value2_storage[i] <= (src2_result_ready[i]) ? execution_result : 
                    (first_open_entry[i]) ? rs1 : value2_storage[i];
                
                ready1_storage[i] <= (src1_result_ready[i]) ? '1 : 
                    (first_open_entry[i]) ? src1_booking[$clog2(ROB)+1] : ready1_storage[i];
                                        
                ready2_storage[i] <= (src2_result_ready[i]) ? '1 : 
                    (first_open_entry[i]) ? src2_booking[$clog2(ROB)+1] : ready2_storage[i];
                                    
                tag_storage[i] <= (first_open_entry[i]) ? rob_entry : tag_storage[i];
                                    
                rob1_storage[i] <= (first_open_entry[i]) ? src1_booking[$clog2(ROB):0] :
                    rob1_storage[i];
                                    
                rob2_storage[i] <= (first_open_entry[i]) ? src2_booking[$clog2(ROB):0] :
                    rob2_storage[i];
                    
                pht_storage[i] <= (first_open_entry[i]) ? {prediction_index, ghr_checkpoint} :
                    pht_storage[i];
                
                seq_pc_storage[i] <= (first_open_entry[i]) ? seq_pc : seq_pc_storage[i];
                  
            end
                        
        end
    end
    
    
    /*Selection Logic*/
    always_ff@(posedge clk) begin
        if(reset)begin
            {jalr_selected,jalr_prediction_index,jalr_ghr,jalr_seq_pc,jalr_op1} <= '0;
            {jalr_op2,jalr_rob} <= '0;  
        end
        
        else begin
            jalr_selected <= instr_found;
            jalr_prediction_index <= p_index;
            jalr_ghr <= ghr;
            jalr_seq_pc <= nxt_pc;
            jalr_op1 <= op1;
            jalr_op2 <= op2;
            jalr_rob <= rob;
        end 
    end

    
    
       
endmodule
