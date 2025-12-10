/*
Fifo buffer implemented as a circular queue.
Has synchronous write and read, both with
enable signals.

Fifo buffers size and data width 
can be configured through the SIZE 
and DW parameters.
*/

module fifo_buffer#(parameter DW = 31, SIZE = 32)
                   (input logic clk,reset,
                    input logic write,read,
                    output logic full,empty,
                    input logic[DW:0] wr_data,
                    output logic[DW:0] rd_data);
                    
                                       
                    logic[DW:0] mem_array[SIZE-1:0]; /*16 entry mem array of logic vectors with 
                    width DW.*/
                    
                    /*Initialize buffer contents*/
					initial begin
                        for (int i=0; i<SIZE; i=i+1) begin
                            mem_array[i] = 0;
                        end
                    end
                    
                    /*Read and write pointers. The upper bits denote loop back
                    in the memory and are used to indicate when buffer is full or empty*/
                    logic[$clog2(SIZE):0] wr_ptr, wr_ptr_next;
                    logic[$clog2(SIZE):0] rd_ptr, rd_ptr_next;
                    
                    /*If data has been sent over to PC 
                    we clear the entry. For FIFO buffers
                    this requires reading the entry and incrementing
                    the read_ptr to point to new top of the stack
                    */                
                    
                                     
                    always_ff @(posedge clk)
                        if(reset) begin
                            rd_ptr <= '0;
                            wr_ptr <= '0;
                        end
                        
                        else begin
                            rd_ptr <= rd_ptr_next;
                            wr_ptr <= wr_ptr_next;
                        end
                    
                    //Synchronous write                   
                    always_ff @(posedge clk) begin 
                        /*Only write to the buffer if buffer isn't full and
                        a write was requested*/
                        if(write & !full) begin
                            mem_array[wr_ptr[$clog2(SIZE)-1:0]] <= wr_data;
                        end
                        rd_data <= mem_array[rd_ptr[$clog2(SIZE)-1:0]];
                    end	
                    
                    /*If wr_ptr equals rd_ptr with wr_ptr  having looped around the
                    memory then buffer must be full*/
                    assign full = (wr_ptr[$clog2(SIZE)-1:0] == rd_ptr[$clog2(SIZE)-1:0]) 
                        && (wr_ptr[$clog2(SIZE)] != rd_ptr[$clog2(SIZE)]);
                    
                    /*Since wr_ptr writes data and rd_ptr clears it if
                    rd_ptr equals wr_ptr, accounting for looping, then
                    the buffer is empty*/
                    assign empty = (wr_ptr == rd_ptr);
                                	
                    //Only increment rd_ptr if a read was requested on non-empty buffer            	
                    assign rd_ptr_next = (read & !empty) ? rd_ptr + 1 : rd_ptr;
                    
                    //Only increment wr_ptr if a write was requested on non-full buffer
                    assign wr_ptr_next = (write & !full) ? wr_ptr + 1 : wr_ptr;
endmodule
