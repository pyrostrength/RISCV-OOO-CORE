

module loadstore_rs_tb #(parameter W = 31,ROB = 32, C = 3, RS = 8)
    (

    );
     
     `timescale 1ns / 1ps;
     //Inputs of RS
     logic clk,reset,reset_pipeline,full_rob;
     logic[$clog2(ROB):0] read_ptr,rob_entry;
     logic[$clog2(ROB)+1:0] src1_booking,src2_booking;
     logic station_request;
     logic[C:0] op_control;
     logic[W:0] rs1, rs2;
     logic[$clog2(ROB):0] execution_rob,reset_rob;
     logic[W:0] execution_result;
     logic instr_executed;
     
     logic is_load, instr_commit;
     logic[W:0] imm;
     logic[$clog2(ROB):0] commit_rob;
     
     
     //Outputs of RS
     logic[$clog2(ROB):0] load_rob;
     logic[W:0] load_op1,load_op2;
     logic[C+1:0]load_mode;
     logic load_selected;
     logic rs_full;
     
     logic[W:0] store_op1,store_op2,store_data;
     logic[$clog2(ROB):0] store_rob;
     logic store_selected;
     logic[C+1:0] store_mode;
     
     load_store_rs load_station(.*);
     
     always begin
        #5; clk = ~clk;
     end
     
     /*Function to determine relative ages of entloades in a circular
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
        rand logic[$clog2(ROB):0] commit_rob;
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
        rand logic reset_pipeline;
        rand logic instr_executed;
        rand logic station_request;
        rand logic[C:0] op_control;
        rand logic[W:0] rs1,rs2,execution_result;
        
        rand logic is_load,instr_commit;
        rand logic[W:0] imm;
        
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
    /*Decoding info*/
    logic[C+1:0] decodeinfo_array[RS - 1:0];
    
    logic[W:0] value3_array[RS - 1:0];
     
    
    
    /*Initially filled with all zeroes*/
    logic[$clog2(ROB):0] rob;
    logic[W:0] op1,op2;
    logic[C+1:0]mode;
    logic selected;
    logic full;
    
    logic[$clog2(ROB):0] s_rob;
    logic[W:0] s_op1,s_op2, s_data;
    logic[C+1:0] s_mode;
    logic s_selected;
    
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
            decodeinfo_array[i] = '0;
            
            value3_array[i] = '0;
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
        logic[RS-1:0] older_store;
        Rob_Entries robs;
        Rand_Inputs inputs;
        int first_open_entry[$];
        int first_selected_load[$];
        
        int first_selected_store[$];
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
        commit_rob = robs.commit_rob;
        
        reset_pipeline = inputs.reset_pipeline;
        instr_executed = inputs.instr_executed;
        
        //reset = inputs.reset;
        reset = '0;
        full_rob = inputs.full_rob;
        station_request = inputs.station_request;
        op_control = inputs.op_control;
        rs1 = inputs.rs1;
        rs2 = inputs.rs2;
        execution_result = inputs.execution_result;
        
        is_load = inputs.is_load;
        instr_commit = inputs.instr_commit;
        imm = inputs.imm;
        older_store = '0;
        
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
        
        /*Store selections are made based off instructions
        already in reservation station*/
        for(int i = RS - 1; i >= 0; i--)begin
            if(valid_array[i] & ready1_array[i] &
                ready2_array[i] & !decodeinfo_array[i][C+1])begin
                first_selected_store.push_front(i);
                break;
            end 
        end
        
        
        /*Loads are selected iff there are no older stores*/
        for(int i = RS - 1; i >= 0; i--)begin
            if(valid_array[i] & ready1_array[i] &
                ready2_array[i] & decodeinfo_array[i][C+1])begin
                for(int k = RS - 1; k >= 0; k --)begin
                    /*If there exists a store in reservation station*/
                    if(!decodeinfo_array[k][C+1] & valid_array[k])begin
                        /*If store is older than load instruction*/
                        if(relative_age(read_ptr,tag_array[k],tag_array[i])==2)begin
                            older_store[i] = '1;
                            break;   
                        end
                    end
                end
                /*If exists an older store for load
                under consideration, consider a new load
                instruction for selection*/
                if(older_store[i])begin
                    continue;
                end
                
                /*Found our load*/
                else begin   
                    first_selected_load.push_front(i);
                    break;
                end
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
                decodeinfo_array[i] = '0;
                
                value3_array[i] = '0;
            end
            /*No instruction is selected*/
            rob = '0;
            mode = '0;
            selected = '0;
            op1 = '0;
            op2 = '0;
            
            s_rob = '0;
            s_mode = '0;
            s_selected = '0;
            s_op1 = '0;
            s_op2 = '0;
            s_data = '0;
            #8;
        end
        
        /*
        If pipeline reset all instructions younger than
        resetting instruction are removed, no new wloadtes
        occur and data on CDB is captured by reservation
        station*/
        else if(reset_pipeline)begin
            /*Remove entloades from array. Find indices of
            entloades to be removed*/
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
            mode = '0;
            selected = '0;
            op1 = '0;
            op2 = '0;
            
            s_rob = '0;
            s_mode = '0;
            s_selected = '0;
            s_op1 = '0;
            s_op2 = '0;
            s_data = '0;  
            #8;
        end
        
        /*If no pipeline reset, wloadtes fall thru given that
        rob isn't full*/
        else begin
            /*Writes to valid array*/
            for(int i = 0;i < RS - 1;i++)begin
                if((first_open_entry.size()>0) & (i == first_open_entry[0]) &
                   station_request & !full_rob)begin
                   valid_array[i] = '1;
                end
                
                /*Load instruction has been selected*/
                else if((first_selected_load.size()>0) & (i == first_selected_load[0]))begin
                        valid_array[i] = '0;
                end
                
                /*Store instruction has committed*/
                else if((tag_array[i] == commit_rob) & instr_commit)begin
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
                decodeinfo_array[first_open_entry[0]] = {is_load,op_control};
                tag_array[first_open_entry[0]] = rob_entry;
                rob1_array[first_open_entry[0]] = src1_booking[$clog2(ROB):0];
                rob2_array[first_open_entry[0]] = src2_booking[$clog2(ROB):0];
                value3_array[first_open_entry[0]] = imm;     
            end
            
            /*Output based on if load selection was available*/
            if(first_selected_load.size() > 0)begin
                mode = decodeinfo_array[first_selected_load[0]];
                op1 = value1_array[first_selected_load[0]];
                op2 = value2_array[first_selected_load[0]];
                rob = tag_array[first_selected_load[0]];
                selected = '1;     
            end
            
            else if(first_selected_load.size() == 0)begin
                mode = '0;
                op1 = '0;
                op2 = '0;
                rob = '0;
                selected = '0;    
            end
            
            /*Output based on if store selection was available*/
            if(first_selected_store.size() > 0)begin
                s_mode = decodeinfo_array[first_selected_store[0]];
                s_op1 = value1_array[first_selected_store[0]];
                s_op2 = value3_array[first_selected_store[0]];
                s_data = value2_array[first_selected_store[0]];
                s_rob = tag_array[first_selected_store[0]];
                s_selected = '1;     
            end
            
            else if(first_selected_store.size() == 0)begin
                s_mode = '0;
                s_op1 = '0;
                s_op2 = '0;
                s_data = '0;
                s_rob = '0;
                s_selected = '0;    
            end            
            #8;
        end     
    endtask
    
    /*Do we have approploadate outputs?*/
    task automatic check_rs(input logic[$clog2(ROB):0] removed_items[$]);
        /*Only output that can be checked is selected
        instruction. If mismatch we have incorrect operation*/
        assert ((load_mode == mode) & (load_selected == selected) & (load_op1 == op1) 
            & (load_op2 == op2) & (load_rob == rob) & (rs_full == full))
        else begin
            /*Determine mismatch condition*/
            if(full != rs_full)begin
                $display("RS doesn't signal when its full");
            end
            if(reset)begin
                $display("Global reset hasn't cleared out RS entloades");
                $display($time);
            end
            else if(reset_pipeline) begin
                $display("No selection is made under pipeline reset");
                $display(load_rob);
                $display($time);
            end
            else begin
                $display("Selected instruction isn't last ready instruction in RS or \
                RS is picking out non-ready instructions");
                $display($time);
            end
        end
        
        /*Do the same for store instructions*/
        assert ((store_mode == s_mode) & (store_selected == s_selected) & (store_op1 == s_op1) 
            & (store_op2 == s_op2) & (store_rob == s_rob) & (rs_full == full) & (store_data = s_data))
        else begin
            if(reset)begin
                $display("Global reset hasn't cleared out RS entries(store)");
                $display($time);
            end
            else if(reset_pipeline) begin
                $display("No selection is made under pipeline reset(store)");
                $display(store_rob);
                $display($time);
            end
            else begin
                $display("Selected store instruction isn't last ready instruction in RS or \
                RS is picking out non-ready instructions(store)");
                $display($time);
            end
        end    
    endtask
        
     
    logic[$clog2(ROB):0] removed_items[$]; 
    initial begin
        #100;
        clk = '1;
        /*Veloadfication begins*/
        while($time < 1000000)begin
            /*Run the register status table*/
            run_rs(removed_items);
            /*Check for correctness*/
            check_rs(removed_items);
        end
    end
endmodule
