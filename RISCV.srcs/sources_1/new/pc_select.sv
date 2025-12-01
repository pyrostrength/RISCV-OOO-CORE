/*
Determines next instruction PC.
Priority is given to global
reset, then pipeline reset from
either JALR resolution,branch misprediction,
branch misdirection or JAL resolution, then
pipeline freezes then hits on BTB and
last of all next sequential PC.
*/

module pc_select #(parameter W = 31 , C = 2)
					  (input logic[W:0] reset_addr,fix_addr,
					   input logic[W:0] predicted_addr,
					   input logic clk,reset,
					   input logic reset_pipeline,
					   input logic fix,
					   input logic freeze,btb_hit,pht_hit,
					   output logic[W:0] PC);
					   
					   
					   logic[W:0] PC_next;
					   logic prediction;
					   assign prediction = pht_hit & btb_hit;
					   /*Computing next PC*/
					   always_comb begin
					       /*If any of the pipeline flush signals are high,
					       indicate pipeline needs flushing*/
					       if(reset_pipeline) begin
					           PC_next = reset_addr;
					       end
					       
					       else if(freeze)begin
					           PC_next = PC;
						   end
						   
						   else if(fix)begin
						      PC_next = fix_addr;
						   end
						   
						   /*If prediction is made*/
						   else if(prediction)begin
						      PC_next = predicted_addr;
						   end
						   
						   else begin
						      PC_next = PC + 1;
						   end

					   end

					   always_ff @(posedge clk) begin
					       if(reset)begin
					           PC <= '0;
					       end
					       else begin
					           PC <= PC_next;
					       end
					   end
endmodule
