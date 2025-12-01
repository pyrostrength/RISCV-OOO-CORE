
/*
Data memory with synchronous
read and write on positive clock edge. 

Make it byte addressable in load-store unit
module.

Written to only by a committing instruction.
*/
module data_mem     #(parameter WIDTH = 31, DEPTH = 1024)
                    (input logic[WIDTH:0] rd_address,wr_address,wr_data,
                     input logic wr_en,rd_en,
			         input logic clk,
			         output logic[WIDTH:0] data); 
			         
			         logic[WIDTH:0] buffer[DEPTH-1:0]; // little-endian memory system.
			         
			         /*Data memory initialization*/	 
					 initial begin
                        for (int i=0; i<DEPTH; i=i+1) begin
                            buffer[i] = 0;
                        end
                     end
			  
			         /*Synchronous read at positive clock edge with PC from
			         PCselect logic*/
			         always_ff @(posedge clk) begin
			             if(rd_en) begin
			                 data <= buffer[rd_address];
			             end
			             if(wr_en) begin
			                 buffer[wr_address] <= wr_data;
			             end
			         end 
			         
endmodule
