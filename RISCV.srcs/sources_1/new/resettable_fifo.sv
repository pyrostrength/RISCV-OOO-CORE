/*
This FIFO buffer has synchronous enabled
read and write but differs in that
it exposes its read pointer
and can have the write pointer reset
to a specific value.
*/

module resettable_fifo#(parameter DW = 31, SIZE = 32)
                   (input logic clk,reset,
                    input logic write,read,
                    /*New write pointer*/
                    input logic[$clog2(SIZE):0] reset_ptr,
                    /*Control signal to reset the write_ptr*/
                    input logic reset_write_ptr,
                    output logic full,empty,
                    input logic[DW:0] wr_data,
                    output logic[DW:0] rd_data,
                    output logic[$clog2(SIZE):0] read_ptr);
                    
                                       
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
                    
                    //Synchronous read and write                   
                    always_ff @(posedge clk) begin 
                        /*Only write to the buffer if buffer isn't full,
                        a write was requested and write pointer isn't
                        to be reset*/
                        if(write & !full &!reset_write_ptr) begin
                            mem_array[wr_ptr[$clog2(SIZE)-1:0]] <= wr_data;
                        end
                        
                        rd_data <= mem_array[rd_ptr[$clog2(SIZE)-1:0]];
                    end
                    
                    /*Determine next write pointer*/
                    always_comb begin
                        /*If write pointer reset is requested, reset the
                        write pointer accordingly. Otherwise increment write
                        pointer only if a write is requested*/
                        wr_ptr_next = (reset_write_ptr) ? reset_ptr : (write & !full) ?
                            wr_ptr + 1 : wr_ptr;
                        /*If wr_ptr equals rd_ptr with wr_ptr  having looped around the
                        memory then buffer must be full*/
                        full = (wr_ptr[$clog2(SIZE)-1:0] == rd_ptr[$clog2(SIZE)-1:0]) 
                            && (wr_ptr[$clog2(SIZE)] != rd_ptr[$clog2(SIZE)]);
                        
                        /*Since wr_ptr writes data and rd_ptr clears it if
                        rd_ptr equals wr_ptr, accounting for looping, then
                        the buffer is empty*/
                        empty = (wr_ptr == rd_ptr);
                        
                        //Only increment rd_ptr if a read was requested on non-empty buffer
                        rd_ptr_next = (read & !empty) ? rd_ptr + 1 : rd_ptr;
        
                        read_ptr = rd_ptr;     
                    end	
endmodule
