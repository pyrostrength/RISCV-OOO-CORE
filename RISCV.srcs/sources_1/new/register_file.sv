/* 
Register file with 32 registers
each holding 32 bit values.

Implemented as a simple dual port
memory with synchronous,enabled
write on positive clock edge and
asynchronous read.

As per RISC_V specification, register
x0 is hardwired to x0. But this rule
is enforced by the decoding stage(disabling
reg_write of all instructions that write
to registers) 
*/


module register_file #(parameter W = 31, R = 4, DEPTH = 32)
					  (input logic clk,reg_write,
					   input logic[R:0] rd_addr,wr_addr,
					   input logic[W:0] wr_data,
					   output logic[W:0] reg_data);
							 
					   logic[W:0] regFile[DEPTH - 1:0];
					   
					   /*Register file memory initialization*/	 
					   initial begin
                            for (int i=0; i<DEPTH; i=i+1) begin
                                regFile[i] = 0;
                            end
                       end
                       
                       /*Async read to allow forwarding during
                       instruction commits*/
				       assign reg_data = regFile[rd_addr];
				       
					   always @(posedge clk) begin
					       /*Register file is only written to by
				           commiting instruction*/
					       if(reg_write) begin
						      regFile[wr_addr] <= wr_data;
						   end
					   end
							 
endmodule
