/*
Reorder buffer holds instructions before
they permanently change the architectural
state - by writing to the register file or
writing to memory.

An instruction at the top of ROB 
can be selected in the same cycle that 
it writes its data and/or address
to the buffer.

Implemented as a set of FIFO buffers
holding relevant instruction info.
These FIFO buffers are simple
dual port with synchronous reads
and writes. 
*/

module reorder_buffer #(parameter W = 31,ROB = 32,C = 6,R=32)
                       (input logic clk,reset,reset_pipeline,cdb_broadcast,
                        /*Reset_rob is used to reset write pointer
                        of reorder buffer to control flow instruction 
                        inducing pipeline reset.Executed_rob is rob entry 
                        of instruction writing to the CDB */
                        input logic[$clog2(ROB):0] reset_rob,executed_rob,
                        input logic[W:0] data1,data2,
                        /*Destination register address*/
                        input logic[$clog2(R)-1:0] dest_address,
                        /*For instructions writing to the ROB*/
                        input logic[C:0] instr_control_info,
                        input logic write_rob,
                        
                        /*Signals a full/empty reorder buffer*/
                        output logic full,empty,
                        /*Instruction info of commiting instruction*/
                        output logic[C:0] commit_control_info,
                        output logic[$clog2(R)-1:0] commit_address,
                        output logic[$clog2(ROB):0] commit_rob,
                        output logic[W:0] commit_data1,commit_data2,
                        output logic instr_commit,
                        
                        output logic[$clog2(ROB):0] read_ptr,write_ptr);
                        
                        /*Holds result for instruction*/
                        logic[W:0] data1_array[ROB:0];
                        logic data1_rdy[ROB:0];
                        
                        /*Holds addresses for store instruction,
                        may find other uses later*/
                        logic[W:0] data2_array[ROB:0];
                        logic data2_rdy[ROB:0];
                        
                        /*Destination register address for
                        instructions that write to a register*/
                        logic[$clog2(R)-1:0] address_array[ROB:0];
                        
                        /*Holds operation info. 
                        {operation,memwrite,regwrite,branch}*/
                        logic[C:0] control_array[ROB:0];
                        
                        
                        /*Read and write pointers for the
                        FIFO buffers*/
                        logic[$clog2(ROB):0] wr_ptr, wr_ptr_next;
                        logic[$clog2(ROB):0] rd_ptr, rd_ptr_next;
                         
                        
                        /*Reorder buffer needs to expose its stack head
                        and tail pointer for pipeline reset and for 
                        register renaming*/
                        assign read_ptr = rd_ptr;
                        assign write_ptr = wr_ptr;
                        
                        logic data1_available,data2_available;
                        /*Commits are valid if there exists instructions
                        with its destination known and result available*/
                        logic instr_commit_next;
                        
                        /*run out of names. bare with me*/
                        logic dat1,dat2;
                        logic[W:0] commit_data1_next,commit_data2_next;
                        logic[$clog2(R)-1:0] commit_address_next;
                        logic[$clog2(ROB):0] commit_rob_next;
                        logic[C:0] commit_control_info_next;
                        
                        /*Forwarding results for same cycle write
                        and commit*/
                        always_comb begin
                            data1_available = dat1;
                            data2_available = dat2;
                            /*Forwarding if instruction uploading
                            results to ROB is also head of stack*/
                            if((executed_rob == rd_ptr) & cdb_broadcast) begin
                                data1_available = '1;
                                data2_available = '1;
                            end      
                        end
                        assign instr_commit_next =!empty & data1_available & data2_available;
                        
                        /*Update read and write pointers*/
                        always_comb begin
                            /*Point to next instruction iff we have a commit for
                            next cycle*/            	
                            rd_ptr_next = (instr_commit_next) ? rd_ptr + 1 : rd_ptr;
                            full = (wr_ptr[$clog2(ROB)-1:0] == rd_ptr[$clog2(ROB)-1:0]) 
                                && (wr_ptr[$clog2(ROB)] != rd_ptr[$clog2(ROB)]);
                            empty = (wr_ptr == rd_ptr);
                            /*If a pipeline reset is signalled new write_ptr
                            is at reset_rob + 1. If no pipeline reset increment
                            write_ptr as usual if buffer isn't full and write
                            was requested*/
                            wr_ptr_next = (reset_pipeline) ? reset_rob + 1 :
                                (!full & write_rob) ? wr_ptr + 1: wr_ptr;
                        end
                            
                        always_ff @(posedge clk)begin
                            /*Synchronous reads on memory*/
                            dat1 <= data1_rdy[rd_ptr];
                            dat2 <= data2_rdy[rd_ptr];
                            commit_address_next <= address_array[rd_ptr];
                            commit_data1_next <= data1_array[rd_ptr];
                            commit_data2_next <= data2_array[rd_ptr];
                            commit_rob_next <= rd_ptr;
                            commit_control_info_next <= control_array[rd_ptr];
                            
                            if(reset)begin
                                rd_ptr <= '0;
                                wr_ptr <= '0;
                                
                                /*Final output register to send committed
                                instructions to the rest of the CPU*/
                                instr_commit <= '0;
                                commit_address <= '0;
                                commit_data1 <= '0;
                                commit_data2 <= '0; 
                                commit_rob <= '0;
                                commit_control_info <= '0; 
                            end
                            
                            else begin
                                /*Update read and write pointers
                                for buffer*/
                                rd_ptr <= rd_ptr_next;
                                wr_ptr <= wr_ptr_next;
                                
                                instr_commit <= instr_commit_next;
                                commit_address <= commit_address_next;
                                commit_data1 <= ((executed_rob == rd_ptr)& cdb_broadcast & !dat2) 
                                    ? data1 : commit_data1_next; 
                                commit_data2 <= ((executed_rob == rd_ptr)& cdb_broadcast & !dat2) 
                                    ? data2 : commit_data2_next; 
                                commit_rob <= commit_rob_next;
                                commit_control_info <= commit_control_info_next;
                            end
                        end
                        
                        /*Instruction writing itself into the
                        reorder buffer or writing result into
                        buffer after broadcasting on CDB*/
                        always_ff @(posedge clk)begin
                            if(write_rob)begin
                                control_array[wr_ptr] <= instr_control_info;
                                address_array[wr_ptr] <= dest_address;  
                            end
                            
                            if(cdb_broadcast)begin
                                data1_array[executed_rob] <= data1;
                                data2_array[executed_rob] <= data2;
                            end
                        end
                        
                        /*writes to data arrays to signal
                        instruction readiness*/
                        always_ff @(posedge clk)begin
                            if(write_rob)begin
                                data1_rdy[wr_ptr] <= '0;
                                data2_rdy[wr_ptr] <= '0;        
                            end
                            if(cdb_broadcast) begin
                                 data1_rdy[executed_rob] <= '1;
                                 data2_rdy[executed_rob] <= '1;    
                            end
                        end
                            
                                          
endmodule
