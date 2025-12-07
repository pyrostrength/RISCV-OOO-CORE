

module jalr_rs_tb #(parameter W = 31,ROB = 32,RS = 4, I = 7)
    (

    );
     
     `timescale 1ns / 1ps;
     //Inputs of RS
     logic clk,reset,reset_pipeline,full_rob;
     logic[$clog2(ROB):0] read_ptr,rob_entry;
     logic[$clog2(ROB)+1:0] src1_booking,src2_booking;
     logic station_request;
     logic[W:0] rs1, rs2;
     logic[$clog2(ROB):0] execution_rob,reset_rob;
     logic[W:0] execution_result;
     logic instr_executed;
     
     logic[W:0] seq_pc, prediction_address;
     logic[I:0] ghr_checkpoint, prediction_index;
     
     //Outputs of RS
     logic[$clog2(ROB):0] jalr_rob;
     logic[W:0] jalr_op1,jalr_op2;
     logic jalr_selected;
     logic rs_full;
     
     logic[I:0] jalr_prediction_index, jalr_ghr;
     logic[W:0] jalr_predicted_address, jalr_seq_pc;
     
     jalr_rs jalr_station(.*);
     
     always begin
        #5; clk = ~clk;
     end
     
     /*Function to determine relative ages of entries in a circular
     buffer with a defined head*/
     function automatic int relative_age(input logic[$clog2(ROB):0] head,
        input logic[$clog2(ROB):0] rob1, input logic[$clog2(ROB):0]rob2);
        if(rob1 == rob2) begin
            return 1;
        end
        else begin
            if(rob1[$clog2(ROB)] == head[$clog2(ROB)])begin
                if((rob2[$clog2(ROB)] != rob1[$clog2(ROB)]) || (rob2[$clog2(ROB)] == rob1[$clog2(ROB)]) 
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
    
    class Rob_Entries;
        rand logic[$clog2(ROB)+1:0] src1_booking;
        rand logic[$clog2(ROB)+1:0] src2_booking;
        rand logic[$clog2(ROB):0] execution_rob;
        rand logic[$clog2(ROB):0] reset_rob;
        rand logic[$clog2(ROB):0] rob_entry;
        static rand logic[$clog2(ROB):0] read_ptr;
        
        logic[$clog2(ROB):0] rob_arrays[4] = '{src1_booking[$clog2(ROB):0],src2_booking[$clog2(ROB):0],
            execution_rob,reset_rob};
            
        constraint correct_ages{
            
            relative_age(read_ptr,read_ptr,rob_entry) == 2;
            
            relative_age(read_ptr,read_ptr,execution_rob) == 2;
            
            relative_age(read_ptr,read_ptr,reset_rob == 1) ||
            relative_age(read_ptr,read_ptr,reset_rob) == 2;
            
            
            relative_age(read_ptr,rob_entry,reset_rob) == 0;     
        }
        
    endclass
    
    /*Randomize the inputs subject to 
    constraints*/
    class Rand_Inputs;
        rand logic reset;
        rand logic full_rob;
        rand logic station_request;
        rand logic reset_pipeline;
        rand logic instr_executed;
        rand logic[W:0] rs1,rs2,execution_result;
        rand logic[W:0] seq_pc, prediction_address;
        rand logic[I:0] ghr_checkpoint, prediction_index;
    endclass
    
    /*Copy of internal memory arrays */
    logic valid_array[RS - 1:0];
    logic[$clog2(ROB):0] tag_array[RS - 1:0];
    logic[$clog2(ROB):0] rob1_array[RS - 1:0];
    logic[$clog2(ROB):0] rob2_array[RS - 1:0];
    logic ready1_array[RS - 1:0];
    logic ready2_array[RS - 1:0];
    logic[W:0] value1_array[RS - 1:0];
    logic[W:0] value2_array[RS - 1:0];
    
    logic[W:0] seqPC_array[RS - 1:0];
    logic[W:0] predictaddr_array[RS - 1:0];
    logic[I:0] ghr_array[RS - 1:0];
    logic[I:0] index_array[RS - 1:0];
    
    /*Initially filled with all zeroes*/
    logic[$clog2(ROB):0] rob;
    logic[W:0] op1,op2;
    logic selected;
    logic full;
    
    logic[W:0] nxt_pc, addr;
    logic[I:0] ghr_check, pht_index;
    
    initial begin
        for(int i = 0 ; i < RS ; i++)begin
            valid_array[i] = '0;
            tag_array[i] = '0;
            rob1_array[i] = '0;
            rob2_array[i] = '0;
            ready1_array[i] = '0;
            ready2_array[i] = '0;
            value1_array[i] = '0;
            value2_array[i] = '0;
            ghr_array[i] = '0;
            index_array[i] = '0; 
            seqPC_array[i] = '0;
            predictaddr_array[i] = '0; 
        end
    end
    
    /*About RS an invalidated instruction cannot be selected
    so we need to keep track of validated and invalidated
    instructions*/
    /*
    Correct model of RS device is created
    and randomized inputs are applied to both
    DUT and ideal model.
    */
    task automatic run_rs(output logic[$clog2(ROB):0] removed_items[$]);
        /*Randomize conditions*/
        Rob_Entries robs;
        Rand_Inputs inputs;
        int first_open_entry[$];
        int first_selected_entry[$];
        inputs = new();
        robs = new();
        inputs.randomize();
        robs.randomize();
        
        src1_booking = robs.src1_booking;
        src2_booking = robs.src2_booking;
        rob_entry = robs.rob_entry;
        execution_rob = robs.execution_rob;
        reset_rob = robs.reset_rob;
        read_ptr = robs.read_ptr;
        
        reset_pipeline = inputs.reset_pipeline;
        instr_executed = inputs.instr_executed;
        
        //reset = inputs.reset;
        reset = '0;
        full_rob = inputs.full_rob;
        station_request = inputs.station_request;
        rs1 = inputs.rs1;
        rs2 = inputs.rs2;
        execution_result = inputs.execution_result;
        
        seq_pc = inputs.seq_pc; 
        prediction_address = inputs.prediction_address;
        ghr_checkpoint = inputs.ghr_checkpoint;
        prediction_index = inputs.prediction_index;
        
        
        #2;
        
        /*Determine if reservation station is full
        and first entry to write to*/
        full = '1;
        for(int i = 0; i < RS ; i++)begin
            if(!valid_array[i])begin
                full = '0;
                first_open_entry.push_front(i);
                break;
            end
        end
        
        /*Selections are made based off instructions
        already in reservation station*/
        for(int i = RS - 1; i >= 0; i--)begin
            if(valid_array[i] & ready1_array[i] &
                ready2_array[i])begin
                first_selected_entry.push_front(i);
                break;
            end 
        end
        
        if(reset)begin
            for(int i = 0 ; i < RS ; i++)begin
                valid_array[i] = '0;
                tag_array[i] = '0;
                rob1_array[i] = '0;
                rob2_array[i] = '0;
                ready1_array[i] = '0;
                ready2_array[i] = '0;
                value1_array[i] = '0;
                value2_array[i] = '0;
                ghr_array[i] = '0;
                index_array[i] = '0; 
                seqPC_array[i] = '0;
                predictaddr_array[i] = '0;
            end
            /*No instruction is selected*/
            rob = '0;
            selected = '0;
            op1 = '0;
            op2 = '0;
            nxt_pc = '0; 
            addr = '0;
            ghr_check = '0; 
            pht_index = '0;
            #8;
        end
        
        /*
        If pipeline reset all instructions younger than
        resetting instruction are removed, no new writes
        occur and data on CDB is captured by reservation
        station*/
        else if(reset_pipeline)begin
            /*Remove entries from array. Find indices of
            entries to be removed*/
            foreach(tag_array[i])begin
                if(relative_age(read_ptr,reset_rob,tag_array[i])==2)begin
                    removed_items.push_back(tag_array[i]);
                    valid_array[i] = '0;
                end
            end
            
            /*Ensure data values are captured*/
            foreach(rob1_array[i])begin
                if((rob1_array[i] == execution_rob) & !ready1_array[i] & instr_executed)begin
                    ready1_array[i] = '1;
                    value1_array[i] = execution_result;  
                end
            end
            
            /*Ensure data values are captured*/
            foreach(rob2_array[i])begin
                if((rob2_array[i] == execution_rob) & !ready2_array[i] & instr_executed)begin
                    ready2_array[i] = '1;
                    value2_array[i] = execution_result;  
                end
            end
            
            /*No instruction is selected. Default output is
            all 0's*/
            rob = '0;
            selected = '0;
            op1 = '0;
            op2 = '0;  
            #8;
        end
        
        /*If no pipeline reset, writes fall thru given that
        rob isn't full*/
        else begin
            /*Writes to valid array*/
            for(int i = 0;i < RS - 1;i++)begin
                if((first_open_entry.size()>0) & (i == first_open_entry[0]) &
                   station_request & !full_rob)begin
                   valid_array[i] = '1;
                end
                
                else if((first_selected_entry.size()>0) & (i == first_selected_entry[0]))begin
                    valid_array[i] = '0; 
                end   
            end
            
            /*Writes to ready arrays and value arrays*/
            for(int i = 0; i < RS - 1; i++)begin
                if((first_open_entry.size()>0) & (i == first_open_entry[0]) &
                   station_request & !full_rob)begin
                   ready1_array[i] = src1_booking[$clog2(ROB)+1];
                   ready2_array[i] = src2_booking[$clog2(ROB)+1];
                   
                   value1_array[i] = rs1;
                   value2_array[i] = rs2;
                end
                
                else if(instr_executed) begin
                    if((rob1_array[i] == execution_rob) & !ready1_array[i])begin
                        ready1_array[i] = '1;
                        value1_array[i] = execution_result;
                    end
                    if((rob2_array[i] == execution_rob) & !ready2_array[i])begin
                        ready2_array[i] = '1;
                        value2_array[i] = execution_result;
                    end
                end
            end
            
            /*Writes to all other arrays*/
            if((first_open_entry.size()>0) & station_request & !full_rob)begin
                tag_array[first_open_entry[0]] = rob_entry;
                rob1_array[first_open_entry[0]] = src1_booking[$clog2(ROB):0];
                rob2_array[first_open_entry[0]] = src2_booking[$clog2(ROB):0];     
            end
            
            /*Output based on if selection was available*/
            if(first_selected_entry.size() > 0)begin
                op1 = value1_array[first_selected_entry[0]];
                op2 = value2_array[first_selected_entry[0]];
                rob = tag_array[first_selected_entry[0]];
                selected = '1;
                
                nxt_pc = seqPC_array[first_selected_entry[0]];
                ghr_check = ghr_array[first_selected_entry[0]];
                addr = predictaddr_array[first_selected_entry[0]];
                pht_index = index_array[first_selected_entry[0]];      
            end
            
            else if(first_selected_entry.size() == 0)begin
                op1 = '0;
                op2 = '0;
                rob = '0;
                selected = '0;
                
                nxt_pc = '0; 
                addr = '0;
                ghr_check = '0; 
                pht_index = '0;    
            end
            #8;
        end     
    endtask
    
    /*Do we have appropriate outputs?*/
    task automatic check_rs(input logic[$clog2(ROB):0] removed_items[$]);
        /*Only output that can be checked is selected
        instruction. If mismatch we have incorrect operation*/
        assert ((jalr_selected == selected) & (jalr_op1 == op1) 
            & (jalr_op2 == op2) & (jalr_rob == rob) & (rs_full == full) &
            (jalr_prediction_index == pht_index ) & (jalr_ghr == ghr_check ) 
            & (jalr_predicted_address == addr ) & (jalr_seq_pc == nxt_pc))
            
        else begin
            /*Determine mismatch condition*/
            if(full != rs_full)begin
                $display("RS doesn't signal when its full");
            end
            if(reset)begin
                $display("Global reset hasn't cleared out RS entries");
                $display($time);
            end
            else if(reset_pipeline) begin
                $display("No selection is made under pipeline reset");
                $display(ri_rob);
                $display($time);
            end
            else begin
                $display("Selected instruction isn't last ready instruction in RS or \
                RS is picking out non-ready instructions");
                $display($time);
            end
        end  
    endtask
        
     
    logic[$clog2(ROB):0] removed_items[$]; 
    initial begin
        #100;
        clk = '1;
        /*Verification begins*/
        while($time < 1000000)begin
            /*Run the register status table*/
            run_rs(removed_items);
            /*Check for correctness*/
            check_rs(removed_items);
        end
    end
endmodule
