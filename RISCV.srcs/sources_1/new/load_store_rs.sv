/*
Unified reservation station for loads and stores.

Once source operands for address calculation
and data(in case of stores) are available,
instruction passes to respective functional
unit.Load instructions cannot proceed before
all prior stores(in program order) have
been released.
*/


module load_store_rs #(parameter ROB = 32,W = 31,C = 3,RS = 8 )
                        (input logic clk,reset,
                         input logic station_request,
                         /*Byte,half word,full word reads as
                         unsigned or signed binary value*/
                         input logic[C:0] op_control,
                         /*Is instruction a load or a store
                         instruction?*/
                         input logic is_load,
                         /*To track position of instruction in
                         reorder buffer for accurate pipeline
                         reset*/
                         input logic[$clog2(ROB):0] read_ptr,
                         /*ROB markings {valid,rob entry}
                         for rs2 which is used for
                         address calculation and rs1 which is used
                         as data value*/
                         input logic[$clog2(ROB)+1:0] src1_booking,src2_booking,
                         /*Rs1 and imm are for address calculations
                         for load and store instructions. Rs2
                         is what's stored in memory by store instructions*/
                         input logic[W:0] rs1,rs2,imm,
                         /*Instruction rob and commit instruction rob entry.
                         Not that the commit instruction rob entry only
                         allows stores to clear from buffer*/
                         input logic[$clog2(ROB):0] rob_entry,commit_rob,
                         /*If all prior stores in program order have 
                         committed then load instructions can proceed.
                         Store instructions need only have their
                         operands ready to proceed*/
                         input logic[$clog2(ROB):0] execution_rob,
                         /*Also account for pipeline reset*/
                         input logic[$clog2(ROB):0] reset_rob,
                         input logic reset_pipeline,instr_executed,instr_commit,
                         /*Result retrieved by load instruction and
                         broadcast on CDB and that obtained thru
                         instruction commit*/
                         input logic[W:0] execution_result,
                         //Load output
                         output logic[W:0] load_op1,load_op2,
                         output logic[$clog2(ROB):0] load_rob,
                         output logic load_selected,
                         output logic[C+1:0] load_mode,
                         
                         //Store output
                         output logic[W:0] store_op1,store_op2,store_data,
                         output logic[$clog2(ROB):0] store_rob,
                         output logic store_selected,
                         output logic[C+1:0] store_mode,
                         
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
                        logic[W:0] value3_storage[RS - 1:0];
    
                        /*Decoding info*/
                        logic[C+1:0] decodeinfo_storage[RS - 1:0];
    
                        
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
                        logic[RS:0] first_open_entry;
                        always_comb begin
                            first_open_entry = '0;
                            rs_full = '1;
                            for(int i = 0; i < RS; i++)begin
                                if(station_request & !valid_storage[i])begin
                                   first_open_entry[i] = '1;
                                   /*If any open entry can be found then
                                   reservation station isn't full*/
                                   rs_full = '0;
                                   break; 
                                end
                            end
                        end
                        
                            
                        
                        /*Select entries for which execution result is
                        ready and highlight respective operand to
                        which result should go to*/
                        logic[RS:0] src1_result_ready;
                        logic[RS:0] src2_result_ready;
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
                        
                        /*Select load instruction for execution. Remember
                        an instruction selected for execution deletes its
                        own entry in the subsequent clock cycle*/
                        logic[RS:0] selected_load_instr;
                        logic[RS:0] older_store_for_load;
                        logic load_found;
                        
                        /*Instr info*/
                        logic[W:0] ld_op1,ld_op2;
                        logic[$clog2(ROB):0] ld_rob;
                        logic[C:0] ld_mode;
                        always_comb begin
                            selected_load_instr = '0;
                            older_store_for_load = '0;
                            load_found = '0;
                            ld_mode = '0;
                            ld_rob = '0;
                            ld_op1 = '0;
                            ld_op2 = '0;
                            for(int i = RS -1; i >= 0; i++)begin
                                if(valid_storage[i] & ready1_storage[i] & ready2_storage[i]
                                    &decodeinfo_storage[i][C+1])begin
                                    older_store_for_load[i] = '0;
                                    /*Search thru RS to check for earlier store instructions*/
                                    for(int k = RS - 1; k >= 0; k--)begin
                                        if(tag_storage[k][$clog2(ROB)] == read_ptr[$clog2(ROB)])begin
                                            if((tag_storage[i][$clog2(ROB)] != tag_storage[k][$clog2(ROB)]) 
                                                ||(tag_storage[i][$clog2(ROB)-1:0] >= tag_storage[k][$clog2(ROB) - 1:0]))begin
                                                    if(!decodeinfo_storage[k][C+1] & valid_storage[k])begin
                                                        older_store_for_load[i] = '1;
                                                        break; 
                                                    end;
                                            end
                                         end
                                         else begin
                                            if((tag_storage[i][$clog2(ROB)] == tag_storage[k][$clog2(ROB)]) 
                                                &&(tag_storage[i][$clog2(ROB)-1:0] >= tag_storage[k][$clog2(ROB) - 1:0]))begin
                                                    if(!decodeinfo_storage[k][C+1] & valid_storage[k])begin
                                                        older_store_for_load[i] = '1;
                                                        break;
                                                    end
                                            end
                                         end 
                                     end
                                     /*Discovered if there's an older store*/
                                     if(older_store_for_load[i])begin
                                        continue;
                                     end
                                     /*No older store we have a valid load instruction*/
                                     else begin
                                        selected_load_instr[i] = '1;
                                        load_found = '1;
                                        ld_mode = decodeinfo_storage[i];
                                        ld_rob = tag_storage[i];
                                        ld_op1 = value1_storage[i];
                                        ld_op2 = value2_storage[i];
                                        break;
                                     end
                                end
                            end
                        end
                        
                        /*Selected store instruction for execution*/
                        logic[RS:0] selected_store_instr;
                        logic store_found;
                        
                        /*Instr info*/
                        logic[W:0] st_data,st_op1,st_op2;
                        logic[$clog2(ROB):0] st_rob;
                        logic[C:0] st_mode;
                        always_comb begin
                            selected_store_instr = '0;
                            store_found = '0;
                            st_mode = '0;
                            st_rob = '0;
                            {st_op1,st_op2,st_data} = '0;
                            for(int i = RS -1; i >= 0; i++)begin
                                if(valid_storage[i] & ready1_storage[i] & ready2_storage[i]
                                    &!decodeinfo_storage[i][C+1])begin
                                        selected_store_instr[i] = '1;
                                        store_found = '1;
                                        st_mode = decodeinfo_storage[i];
                                        st_rob = tag_storage[i];
                                        st_op1 = value1_storage[i];
                                        st_op2 = value3_storage[i];
                                        st_data = value2_storage[i];
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
                                    value3_storage[i] <= '0;
                                    ready1_storage[i] <= '0;
                                    ready2_storage[i] <= '0;
                                end
                            end
        
                            else begin
                                /*Reservation station fields snoop in on CDB 
                                and capture values broadcast regardless of any CPU events, including
                                pipeline resets*/ 
                                for(int i = 0; i < RS; i++)begin
                                    value1_storage[i] <= (src1_result_ready[i]) ? execution_result : 
                                        (first_open_entry[i]) ? rs1 : value1_storage[i];
                                    
                                    value2_storage[i] <= (src2_result_ready[i]) ? execution_result : 
                                        (first_open_entry[i]) ? rs2 : value2_storage[i];
                                        
                                    value3_storage[i] <= (src2_result_ready[i]) ? execution_result :
                                        (first_open_entry[i]) ? imm : value3_storage[i];
                                    
                                    ready1_storage[i] <= (src1_result_ready[i]) ? '1 : 
                                        (first_open_entry[i]) ? src1_booking[$clog2(ROB)+1] : ready1_storage[i];
                                        
                                    ready2_storage[i] <= (src2_result_ready[i]) ? '1 : 
                                        (first_open_entry[i]) ? src2_booking[$clog2(ROB)+1] : ready2_storage[i];
                                    
                                    tag_storage[i] <= (first_open_entry[i]) ? rob_entry : tag_storage[i];
                                    
                                    rob1_storage[i] <= (first_open_entry[i]) ? src1_booking[$clog2(ROB):0] :
                                        rob1_storage[i];
                                    
                                    rob2_storage[i] <= (first_open_entry[i]) ? src2_booking[$clog2(ROB):0] :
                                        rob2_storage[i];
                                        
                                    decodeinfo_storage[i] <= (first_open_entry[i]) ? {is_load,op_control} :
                                        decodeinfo_storage[i];
                                    
                                    /*Instruction is removed if store instruction has committed, load instruction
                                    has been selected for execution or if a pipeline reset demands it*/
                                    valid_storage[i] <= (remove_entry[i] | selected_load_instr[i] |
                                        (commit_rob == tag_storage[i]) & !decodeinfo_storage[i] & valid_storage[i]
                                        & instr_commit ) ? 
                                        '0 : (first_open_entry[i]) ? '1 :
                                            valid_storage[i];

                
                                   
                                end 
                            end
                        end
    
    
                        /*Pass selected instructions to functional units*/
                        logic older_store;
                        always_ff @(posedge clk) begin
                            if(reset)begin
                                {load_op1,load_op2} <= '0;
                                {load_rob,load_selected,load_mode} <= '0;
                                {store_op1,store_op2,store_data} <= '0;
                                {store_rob,store_selected,store_mode} <= '0;
                            end
        
                            else begin
                                load_op1 <= ld_op1;
                                load_op2 <= ld_op2;
                                load_rob <= ld_rob;
                                load_selected <= load_found;
                                load_mode <= ld_mode;
                                
                                store_op1 <= st_op1;
                                store_op2 <= st_op2;
                                store_data <= st_data;
                                store_rob <= st_rob;
                                store_selected <= store_found;
                                store_mode <= st_mode;
                            end
                        end
    
    
       
                         
endmodule
