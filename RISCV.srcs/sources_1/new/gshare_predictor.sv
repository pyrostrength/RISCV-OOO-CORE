
/*
Contains a global history register that stores the most
recent outcome of 8 conditionals. This outcomes are XORed with
lower 8 bits of instruction PC to produce index to retrieve
prediction from branch target buffer
*/
								
module gshare_predictor #(parameter I = 7, WIDTH = 31)
                        (input logic clk,reset,
                         input logic[I:0] pc_lowerbits,
                         /*Since CPU allows speculative updating
                         of ghr we need to checkpoint the GHR
                         use it for restoration in case our
                         speculative branch update is incorrect*/ 
                         input logic[I:0] ghr_restore,
                         /*Update GHR with new branch prediction or
                         restore the GHR because of wrong speculative
                         update*/
                         input logic update,restore,
                         /*Signal to indicate outcome of
                         recently executed branch instruction*/
                         input logic branch_taken,
                         /*Index used to access pattern history
                         table produced by XORING pc and ghr*/
                         output logic[I:0] index,
                         /*We always pass out the global history registers
                         info*/
                         output logic[I:0] ghr_checkpoint);
                         
                         logic[I:0] ghr_next,ghr;
                         
                         assign ghr_checkpoint = ghr;
                         
                         /*Produce index for branch target buffer*/
                         assign index = pc_lowerbits ^ ghr;
                         
                         /*Priority based determination of
                         global history register. Resetting a
                         speculative update is greater priority 
                         than updating GHR.*/
                         always_comb begin
                            case(restore)
                                1'b1: begin
                                    ghr_next = ghr_restore;
                                end
                                    
                                1'b0:begin
                                    ghr_next = (update) ? {ghr[I:1], branch_taken} : ghr;
                                end
                            endcase
                         end
                         
                         
                         //Register to store ghr
                         always_ff @(posedge clk) begin
                            if(reset)begin
                                ghr <= '0;
                            end
                            
                            else begin
                                ghr <= ghr_next;
                            end 
                         end
endmodule
