
/*
Holds program instructions.

Implemented as simple dual port memory,
read first with synchronous
read on negative clock edge.

Loaded with a memory file with RISC-V
instructions - memory file can be
generated via C++/Python Script/
hardcoding if you're a maso.

*/
module instr_memory #(parameter WIDTH = 31, DEPTH = 1024)
                    (input logic[WIDTH:0] rd_address,
			         input logic clk,
			         output logic[WIDTH:0] instr); 
			         
			         logic[WIDTH:0] buffer[DEPTH:0]; 
			         
			         initial begin
			             $readmemb("/home/voidknight/RISCV/instr.txt",buffer);
			         end
			  
			         /*Synchronous read at negative clock edge with PC from
			         PCselect logic*/
			         always_ff @(negedge clk) begin
			             instr <= buffer[rd_address];
			         end 
			         
endmodule
