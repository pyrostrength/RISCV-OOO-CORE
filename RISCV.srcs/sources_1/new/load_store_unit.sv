/*
Executes load and store instructions with
support for misaligned memory access.
If memory access is misaligned, it's assumed
that base address is the lowest byte address.

RAM holding data has a single write and read port
therefore to support misaligned memory accesses
loads and stores take more than 1 clock cycle
*/


module load_store_unit #(parameter W = 31, C = 3, ROB = 32)
                       (input logic clk,reset,
                        input logic[W:0] load_address,
                        input logic[$clog2(ROB):0] load_rob,
                        /*Load_control is load operation to be performed*/
                        input logic[C+1:0] load_control,
                        /*Is this a load instruction selected for execution?*/
                        input logic execute_load,
                        output logic load_complete,
                        
                        /*Stores only write to memory when
                        commiting*/
                        input logic [W:0] store_address,store_data,
                        input logic [C+1:0] store_control,
                        input logic[$clog2(ROB):0] store_rob,
                        
                        input logic is_commit_store,
                        /*Store instruction has to write to memory first 
                        to be committed. These signals will eliminate corresponding
                        entry from load store reservation station.*/
                        output logic store_committed,
                        output logic[$clog2(ROB):0] committed_store_rob,
                        /*Retrieved data is for load instructions
                        sent out from their reservation station*/
                        output logic[W:0] retrieved_data,
                        output logic[$clog2(ROB):0] entry_rob,
                        
                        output logic full_store_queue,full_load_queue);
                        
                        
                        /*Choose either a store or load*/
                        logic store_chosen, load_chosen;
                        
                        /*Let all commiting store and selected load instructions
                        write into FIFO buffers*/
                        logic[W:0] selected_load_address;
                        fifo_buffer load_addr_buffer(.clk(clk),
                                                     .reset(reset),
                                                     .write(execute_load),
                                                     .read(load_chosen),
                                                     .full(),
                                                     .empty(),
                                                     .rd_data(selected_load_address),
                                                     .wr_data(load_address));
                        
                        logic[C+1:0] selected_load_op_mode;                      
                        fifo_buffer #(.DW(C+1)) load_control_buffer(.clk(clk),
                                                .reset(reset),
                                                .write(execute_load),
                                                .read(load_chosen),
                                                .full(),
                                                .empty(),
                                                .rd_data(selected_load_op_mode),
                                                .wr_data(load_control));
                        
                        logic[$clog2(ROB):0] selected_load_rob;
                        logic empty_load_rob_buffer, full_load_rob_buffer;
                        
                        fifo_buffer #(.DW($clog2(ROB))) load_rob_buffer(.clk(clk),
                                                .reset(reset),
                                                .write(execute_load),
                                                .read(load_chosen),
                                                .full(full_load_rob_buffer),
                                                .empty(empty_load_rob_buffer),
                                                .rd_data(selected_load_rob),
                                                .wr_data(load_rob));
                        
                        /*Let all commiting store and selected load instructions
                        write into FIFO buffers*/
                        logic[W:0] selected_store_address;
                        fifo_buffer store_addr_buffer(.clk(clk),
                                                     .reset(reset),
                                                     .write(is_commit_store),
                                                     .read(store_chosen),
                                                     .full(),
                                                     .empty(),
                                                     .rd_data(selected_store_address),
                                                     .wr_data(store_address));
                        
                        logic[C+1:0] selected_store_op_mode;                  
                        fifo_buffer #(.DW(C+1)) store_control_buffer(.clk(clk),
                                                .reset(reset),
                                                .write(is_commit_store),
                                                .read(store_chosen),
                                                .full(),
                                                .empty(),
                                                .rd_data(selected_store_op_mode),
                                                .wr_data(store_control));
                        
                        logic[$clog2(ROB):0] selected_store_rob;
                        logic empty_store_rob_buffer;
                        logic full_store_rob_buffer;
                        fifo_buffer #(.DW($clog2(ROB))) store_rob_buffer(.clk(clk),
                                                .reset(reset),
                                                .write(is_commit_store),
                                                .read(store_chosen),
                                                .full(full_store_rob_buffer),
                                                .empty(empty_store_rob_buffer),
                                                .rd_data(selected_store_rob),
                                                .wr_data(store_rob));
                        
                        logic[W:0] selected_store_data;                       
                        fifo_buffer store_data_buffer(.clk(clk),
                                                     .reset(reset),
                                                     .write(is_commit_store),
                                                     .read(store_chosen),
                                                     .full(),
                                                     .empty(),
                                                     .rd_data(selected_store_data),
                                                     .wr_data(store_data));
                                                
                        typedef enum{idle,load1,load2,store1,store2,store3} state_type;
                        (* keep = "true" *) state_type state,state_next;
                        
                        logic count,count_next;
                        
                        /*Registers to hold data necessary for
                        operation by state machine*/
                        logic[$clog2(ROB):0] hold_rob,hold_rob_next;
                        logic[W:0] hold_address,hold_address_next;
                        logic[C+1:0] hold_ctrl_info,hold_ctrl_info_next;
                        logic[2*W+1:0] hold_data,hold_data_next;
                        
                        logic read_mem, write_mem;
                        /*Whats read from data memory*/
                        logic[W:0] mem_rd_address,mem_wr_address;
                        logic[W:0] mem_data,mem_wr_data;
                        /*Data memory*/
                        data_mem memory(.clk(clk),
                                        .rd_en(read_mem),
                                        .wr_en(write_mem),
                                        .data(mem_data),
                                        .rd_address(mem_rd_address),
                                        .wr_address(mem_wr_address),
                                        .wr_data(mem_wr_data));                                       
                        
                        logic[W:0] retrieved_data_next;
                        logic load_complete_next,store_committed_next;
                        logic[$clog2(ROB):0] entry_rob_next,committed_store_rob_next;
                        
                      
                        assign full_store_queue = full_store_rob_buffer;
                        assign full_load_queue = full_load_rob_buffer;
                        
                        always_ff @(posedge clk)begin
                            if(reset)begin
                                hold_rob <= '0;
                                hold_address <= '0;
                                hold_ctrl_info <= '0;
                                hold_data <= '0;
                                hold_data <= '0;
                                state <= idle;
                                
                                retrieved_data <= '0;
                                load_complete <= '0;
                                entry_rob <= '0;
                                committed_store_rob <= '0;
                                store_committed <= '0;
                            end
                            else begin
                                hold_rob <= hold_rob_next;
                                hold_address <= hold_address_next;
                                hold_ctrl_info <= hold_ctrl_info_next;
                                hold_data <= hold_data_next;
                                state <= state_next;
                                
                                retrieved_data <= retrieved_data_next;
                                load_complete <= load_complete_next;
                                entry_rob <= entry_rob_next;
                                committed_store_rob <= committed_store_rob_next;
                                store_committed <= store_committed_next;
                            end
                        end
                        
                        /*Simple round robin arbiter that
                        shifts between selecting loads and
                        selecting stores*/
                        always_ff @(posedge clk)begin
                            if(reset)begin
                                count <= '0;
                            end
                            
                            else begin
                                count <= count_next;
                            end
                        end
                        
                        always_comb begin
                            store_chosen = '0;
                            load_chosen = '0;
                            state_next = state;
                            count_next = count + 1;
                            hold_address_next = hold_address;
                            hold_data_next = hold_data;
                            hold_rob_next = hold_rob;
                            hold_ctrl_info_next = hold_ctrl_info;
                            
                            {read_mem,write_mem} = '0;
                            {mem_rd_address, mem_wr_address, mem_wr_data} = '0;
                            
                            retrieved_data_next = retrieved_data;
                            load_complete_next = '0;
                            entry_rob_next = entry_rob;
                            committed_store_rob_next = committed_store_rob;
                            store_committed_next = '0;
                            case(state)
                                idle:begin
                                   /*Setup store. Read from first data word then
                                   make appropriate adjustments to the data*/
                                   if((count == 0) & !empty_store_rob_buffer)begin
                                        store_chosen = '1; /*Move onto next store instruction in store queue*/
                                        /*Store important instruction information*/
                                        hold_address_next = selected_store_address;
                                        hold_data_next = {32'b0,selected_store_data};
                                        hold_rob_next = selected_store_rob;
                                        hold_ctrl_info_next = selected_store_op_mode;
                                        /*Setup store instruction read*/
                                        read_mem = '1;
                                        mem_rd_address = selected_store_address[W:2];
                                        state_next = store1;
                                   end
                                   else if((count == 1) & !empty_load_rob_buffer)begin
                                        /*Move onto next load instruction in load queue*/
                                        load_chosen = '1;
                                        /*Store important load instruction info*/
                                        hold_address_next = selected_load_address;
                                        hold_ctrl_info_next = selected_load_op_mode;
                                        hold_rob_next = selected_load_rob;
                                        state_next = load1;
                                        /*Setup load instruction*/
                                        read_mem = '1;
                                        mem_rd_address = selected_load_address[W:2];
                                   end 
                                end
                                
                                load1:begin
                                   read_mem = '0;
                                   /*Process and send out data in next cycle if only
                                   a single data word was needed*/
                                   if(selected_load_op_mode[C+1] == '0)begin
                                       state_next = idle;
                                       load_complete_next = '1;
                                       entry_rob_next = hold_rob;
                                       case(hold_ctrl_info[C:0])
                                            /*Load byte*/
                                            4'b0001:begin
                                                retrieved_data_next = {24*{mem_data[7]},mem_data[7:0]};
                                                case(hold_address[1:0])
                                                    2'b00:begin
                                                        retrieved_data_next = {24*{mem_data[7]},mem_data[7:0]};
                                                    end
                                                    2'b01:begin
                                                        retrieved_data_next = {24*{mem_data[15]},mem_data[15:8]};
                                                    end
                                                    2'b10:begin
                                                        retrieved_data_next = {24*{mem_data[23]},mem_data[23:16]};
                                                    end
                                                    2'b11:begin
                                                        retrieved_data_next = {24*{mem_data[31]},mem_data[31:24]};
                                                    end
                                                    default:begin
                                                        retrieved_data_next = '0;    
                                                    end
                                                endcase  
                                            end
                                            
                                            /*Load byte unsigned*/
                                            4'b1001:begin
                                                retrieved_data_next = {24*{1'b0},mem_data[7:0]};
                                                case(hold_address[1:0])
                                                    2'b00:begin
                                                        retrieved_data_next = {24*{1'b0},mem_data[7:0]};
                                                    end
                                                    2'b01:begin
                                                        retrieved_data_next = {24*{1'b0},mem_data[15:8]};
                                                    end
                                                    2'b10:begin
                                                        retrieved_data_next = {24*{1'b0},mem_data[23:16]};
                                                    end
                                                    2'b11:begin
                                                        retrieved_data_next = {24*{1'b0},mem_data[31:24]};
                                                    end
                                                    default:begin
                                                        retrieved_data_next = '0;   
                                                    end
                                                endcase  
                                            end
                                            
                                            /*Load half-word*/
                                            4'b0010:begin
                                                retrieved_data_next = {16*{mem_data[31]},mem_data[31:24],
                                                            mem_data[23:16]};
                                                case(hold_address[1:0])
                                                    2'b00:begin
                                                        retrieved_data_next = {16*{mem_data[16]},mem_data[15:8],
                                                            mem_data[7:0]};    
                                                    end
                                                    2'b01:begin
                                                        retrieved_data_next = {16*{mem_data[23]},mem_data[23:16],
                                                            mem_data[15:8]};
                                                    end
                                                    2'b10:begin
                                                        retrieved_data_next = {16*{mem_data[31]},mem_data[31:24],
                                                            mem_data[23:16]}; 
                                                    end
                                                    /*Half word with starting address 2'b11 and none 2 word read is
                                                    impossible. If statement guarantees default doesn't execute*/
                                                    default:begin
                                                        retrieved_data_next = '0;   
                                                    end
                                                endcase  
                                            end
                                            
                                            /*Load half-word unsigned*/
                                            4'b1010:begin
                                                retrieved_data_next = {16*{1'b0},mem_data[31:24],
                                                            mem_data[23:16]};
                                                case(hold_address[1:0])
                                                    2'b00:begin
                                                        retrieved_data_next = {16*{1'b0},mem_data[15:8],
                                                            mem_data[7:0]};    
                                                    end
                                                    2'b01:begin
                                                        retrieved_data_next = {16*{1'b0},mem_data[23:16],
                                                            mem_data[15:8]};
                                                    end
                                                    2'b10:begin
                                                        retrieved_data_next = {16*{1'b0},mem_data[31:24],
                                                            mem_data[23:16]}; 
                                                    end
                                                    /*Half word with starting address 2'b11 and no 2 word read is
                                                    impossible twin*/
                                                    default:begin
                                                        retrieved_data_next = '0;   
                                                    end
                                                endcase  
                                            end
                                             
                                            /*Load full word*/
                                            4'b0100:begin
                                                retrieved_data_next = mem_data;
                                            end
                                            
                                            default:begin
                                                retrieved_data_next = '0;    
                                            end
                                       endcase
                                   end
                                   
                                   /*Check for misaligned load instruction. If load
                                   instruction is misaligned read from next data word
                                   in memory*/ 
                                   else begin
                                        state_next = load2;
                                        read_mem = '1;
                                        /*Read from next data word in memory*/
                                        mem_rd_address = hold_address[W:2] + 1;
                                        /*Store read data for manipulation in the next clock cycle*/
                                        hold_data_next = {hold_data[63:32],mem_data}; 
                                   end 
                                end
                                
                                load2:begin
                                    /*With data words from both address lines retrieve the
                                    correct data*/
                                    read_mem = '0;
                                    state_next = idle;
                                    load_complete_next = '1;
                                    entry_rob_next = hold_rob;
                                    /*Note that byte loads cannot cross word address lines. Only
                                    for starting byte 4 can half-word access cross an address line and
                                    all starting byte addresses except 00 cross a word address line
                                    for load word instruction*/
                                    case(hold_ctrl_info[C:0])
                                            /*Load full-word*/
                                            4'b0100:begin
                                                retrieved_data_next = {mem_data[7:0],hold_data[31:8]};
                                                case(hold_address[1:0])
                                                    2'b01:begin
                                                        retrieved_data_next = {mem_data[7:0],hold_data[31:8]};
                                                    end
                                                    2'b10:begin
                                                        retrieved_data_next = {mem_data[15:0],hold_data[31:16]};
                                                    end
                                                    2'b11:begin
                                                        retrieved_data_next = {mem_data[23:0],hold_data[31:24]};
                                                    end
                                                    default:begin
                                                        retrieved_data_next = '0;   
                                                    end
                                                endcase  
                                            end
                                            
                                            /*Load half-word signed*/
                                            4'b0010:begin
                                                retrieved_data_next = {16*{mem_data[7]},mem_data[7:0]
                                                    ,hold_data[31:23]};  
                                            end
                                            
                                            /*Load half-word unsigned*/
                                            4'b1010:begin
                                                 retrieved_data_next = {16*{1'b0},mem_data[7:0]
                                                    ,hold_data[31:23]};  
                                            end
                                            
                                            default:begin
                                                retrieved_data_next = '0;   
                                            end
                                             
                                       endcase
                                end
                                
                                store1:begin
                                   read_mem = '0;
                                   write_mem = '1;
                                   mem_wr_address = hold_address[W:2];
                                   /*If store takes place across 1 word address line,
                                   create write data and set up the write*/
                                   if(selected_store_op_mode[C+1] == '0)begin
                                       state_next = idle;
                                       store_committed_next = '1;
                                       committed_store_rob_next = hold_rob;
                                       case(hold_ctrl_info[C:0])
                                            /*Store byte*/
                                            4'b0001:begin
                                                mem_wr_data = {mem_data[31:8],hold_data[7:0]};
                                                case(hold_address[1:0])
                                                    2'b00:begin
                                                        mem_wr_data = {mem_data[31:8],hold_data[7:0]};
                                                    end
                                                    2'b01:begin
                                                        mem_wr_data = {mem_data[31:16],hold_data[7:0],
                                                            mem_data[7:0]};
                                                    end
                                                    2'b10:begin
                                                        mem_wr_data = {mem_data[31:24],hold_data[7:0],
                                                            mem_data[15:0]};
                                                    end
                                                    2'b11:begin
                                                        mem_wr_data = {hold_data[7:0],mem_data[23:0]};
                                                    end
                                                    default:begin
                                                        mem_wr_data = '0;   
                                                    end
                                                endcase  
                                            end
                                            
                                            
                                            /*Store half-word*/
                                            4'b0010:begin
                                                mem_wr_data = {mem_data[31:16],hold_data[15:0]};  
                                                case(hold_address[1:0])
                                                    2'b00:begin
                                                        mem_wr_data = {mem_data[31:16],hold_data[15:0]};    
                                                    end
                                                    2'b01:begin
                                                        mem_wr_data = {mem_data[31:24],hold_data[15:0],
                                                            mem_data[7:0]};
                                                    end
                                                    2'b10:begin
                                                       mem_wr_data = {hold_data[15:0],mem_data[15:0]}; 
                                                    end
                                                    default:begin
                                                       mem_wr_data = '0;   
                                                    end
                                                endcase  
                                            end
                                            
                                            
                                            /*Store full word*/
                                            4'b0100:begin
                                                mem_wr_data = hold_data[31:0];
                                            end
                                            
                                            default:begin
                                                mem_wr_data = '0;    
                                            end
                                       endcase
                                   end
                                   
                                   /*If store instruction is misaligned we read from
                                   next data word in memory*/ 
                                   else begin
                                        state_next = store2;
                                        /*Read the next data word*/
                                        read_mem = '1;
                                        /*Complete write on current address line*/
                                        /*Read from next data word in memory*/
                                        mem_rd_address = hold_address[W:2] + 1;
                                        /*Store read data for manipulation in the next clock cycle*/
                                        case(hold_ctrl_info[C:0])
                                            4'b0010:begin
                                                mem_wr_data = {hold_data[7:0], mem_data[23:0]};
                                            end
                                            4'b0100:begin
                                                case(hold_address[1:0])
                                                    2'b01:begin
                                                        mem_wr_data = {hold_data[23:0],mem_data[7:0]};
                                                    end
                                                    
                                                    2'b10:begin
                                                        mem_wr_data = {hold_data[15:0],mem_data[15:0]};
                                                    end
                                                    
                                                    2'b11:begin
                                                        mem_wr_data = {hold_data[7:0],mem_data[23:0]};
                                                    end
                                                    default:begin
                                                        mem_wr_data = '0;   
                                                    end
                                                endcase
                                            end
                                            
                                            default:begin
                                                mem_wr_data = '0;    
                                            end
                                        endcase 
                                   end         
                                end
                                
                                store2:begin
                                    read_mem = '0;
                                    write_mem = '1;
                                    state_next = idle;
                                    committed_store_rob_next = hold_rob;
                                    store_committed_next = '1;
                                    case(hold_ctrl_info[C:0])
                                        4'b0010:begin
                                            mem_wr_data = {mem_data[31:8],hold_data[15:8]};
                                        end
                                        
                                        4'b0100:begin
                                            case(hold_address[1:0])
                                                2'b01:begin
                                                    mem_wr_data = {mem_data[31:8],hold_data[31:24]};
                                                end
                                                2'b10:begin
                                                    mem_wr_data = {mem_data[31:16],hold_data[31:16]};
                                                end
                                                2'b11:begin
                                                    mem_wr_data = {mem_data[31:24],hold_data[31:8]};
                                                end
                                                default:begin
                                                    mem_wr_data = '0;
                                                end 
                                            endcase
                                        end
                                        
                                        default:begin
                                            mem_wr_data = '0 ;
                                        end
                                    endcase
                                end
                                
                                /*
                                default:begin
                                    store_chosen = '0;
                                    load_chosen = '0;
                                    state_next = idle;
                                    count_next = count + 1;
                                    hold_address_next = hold_address;
                                    hold_data_next = hold_data;
                                    hold_rob_next = hold_rob;
                                    hold_ctrl_info_next = hold_ctrl_info;
                            
                                    {read_mem,write_mem} = '0;
                                    {mem_rd_address, mem_wr_address, mem_wr_data} = '0;
                            
                                    retrieved_data_next = '0;
                                    load_complete_next = '0;
                                    entry_rob_next = '0;
                                    committed_store_rob_next = '0;
                                    store_committed_next = '0;
                       
                                end */  
                            endcase
                        end      
endmodule
