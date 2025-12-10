/* 
   Branch ALU is the execution unit for branch instructions.
   
   It determines whether a branch should be taken or not
   taken,signals a pipeline reset in case of incorrect
   branch prediction and provides new state for entry
   in PHT table.
   
*/

module branch_alu #(parameter W = 31, C = 3,ROB = 32)
                  /*Source operands for branch instruction*/
                  (input logic signed[W:0] src1,src2,branch_predicted_address,seq_pc,
                  /*Was instruction PC redirected according to a branch
                  prediction?*/
                   input logic redirect,
                  /*What specific conditional statement is being evaluated*/
                   input logic[C:0] op_control,
                   input logic[1:0] original_state,
                  /*Branch related info*/
                   input logic[$clog2(ROB):0] instr_rob,
                   input logic is_branch_instr,
                   output logic misprediction,
                   //Branch_cdb_request is our update signal for the cpu
                   output logic branch_cdb_request,
                  /*New entry on PHT*/
                   output logic[1:0] new_state,
                   //Just write to the arbitration buffer
                   output logic[$clog2(ROB):0] branch_rob,
                   output logic[W:0] branch_address,
                   /*Indicates whether condition was
                   taken or not taken. Necessary for updating
                   the ghr*/
                   output logic taken_branch);
                   
                   assign branch_cdb_request = is_branch_instr;
                   assign branch_rob = instr_rob;
                   
                   always_comb begin
                        misprediction = '0;
                        new_state = original_state;
                        taken_branch = '1;
                        case(op_control)
                            /*Branch if equal*/
                            4'b0000:begin
                                misprediction = ((src1 != src2) & redirect) | (!redirect & (src1 == src2));
                                taken_branch = (src1 == src2);
                                case(original_state)
                                    2'b00:begin
                                        new_state = (src1 == src2) ? 2'b01:2'b00;
                                    end
                                    2'b01:begin
                                        new_state = (src1 == src2) ? 2'b10:2'b00;
                                    end
                                    2'b10:begin
                                        new_state = (src1 == src2) ? 2'b11:2'b01;
                                    end
                                    2'b11:begin
                                        new_state = (src1 == src2) ? 2'b11:2'b10;
                                    end
                                endcase  
                            end
                            
                            /*Branch if not equal*/
                            4'b0001:begin
                                misprediction = ((src1 == src2) & redirect) | (!redirect & (src1 != src2));
                                taken_branch = (src1 != src2);
                                case(original_state)
                                    2'b00:begin
                                        new_state = (src1 != src2) ? 2'b01:2'b00;
                                    end
                                    2'b01:begin
                                        new_state = (src1 != src2) ? 2'b10:2'b00;
                                    end
                                    2'b10:begin
                                        new_state = (src1 != src2) ? 2'b11:2'b01;
                                    end
                                    2'b11:begin
                                        new_state = (src1 != src2) ? 2'b11:2'b10;
                                    end
                                endcase  
                            end
                            
                            /*Branch if less than*/
                            4'b0010:begin
                                misprediction = ((src1 >= src2) & redirect) | (!redirect & (src1 < src2));
                                taken_branch = (src1 < src2);
                                case(original_state)
                                    2'b00:begin
                                        new_state = (src1 < src2) ? 2'b01:2'b00;
                                    end
                                    2'b01:begin
                                        new_state = (src1 < src2) ? 2'b10:2'b00;
                                    end
                                    2'b10:begin
                                        new_state = (src1 < src2) ? 2'b11:2'b01;
                                    end
                                    2'b11:begin
                                        new_state = (src1 < src2) ? 2'b11:2'b10;
                                    end
                                endcase  
                            end
                            
                            /*Branch if less than unsigned*/
                            4'b0011:begin
                                misprediction = ((unsigned'(src1) >= unsigned'(src2)) & redirect) | 
                                    (!redirect & (unsigned'(src1) < unsigned'(src2)));
                                taken_branch = unsigned'(src1) < unsigned'(src2);
                                case(original_state)
                                    2'b00:begin
                                        new_state = (unsigned'(src1) < unsigned'(src2)) ? 
                                            2'b01:2'b00;
                                    end
                                    2'b01:begin
                                        new_state = (unsigned'(src1) < unsigned'(src2)) ? 
                                            2'b10:2'b00;
                                    end
                                    2'b10:begin
                                        new_state = (unsigned'(src1) < unsigned'(src2)) ? 
                                            2'b11:2'b01;
                                    end
                                    2'b11:begin
                                        new_state = (unsigned'(src1) < unsigned'(src2)) ? 
                                            2'b11:2'b10;
                                    end
                                endcase  
                            end
                            
                            /*Branch if greater than or equal to*/
                            4'b0100:begin
                                misprediction = ((src1 < src2) & redirect) |(!redirect & (src1 >= src2)) ;
                                taken_branch = src1 >= src2;
                                case(original_state)
                                    2'b00:begin
                                        new_state = (src1 >= src2) ? 2'b01:2'b00;
                                    end
                                    2'b01:begin
                                        new_state = (src1 >= src2) ? 2'b10:2'b00;
                                    end
                                    2'b10:begin
                                        new_state = (src1 >= src2) ? 2'b11:2'b01;
                                    end
                                    2'b11:begin
                                        new_state = (src1 >= src2) ? 2'b11:2'b10;
                                    end
                                endcase   
                            end
                            
                            /*Branch if greater than or equal to unsigned*/
                            4'b0101:begin
                                misprediction = ((unsigned'(src1) < unsigned'(src2)) & redirect) |
                                    ((unsigned'(src1) >= unsigned'(src2)) & !redirect) ;
                                taken_branch = unsigned'(src1) >= unsigned'(src2);
                                case(original_state)
                                    2'b00:begin
                                        new_state = (unsigned'(src1) >= unsigned'(src2)) 
                                            ? 2'b01:2'b00;
                                    end
                                    2'b01:begin
                                        new_state = (unsigned'(src1) >= unsigned'(src2)) 
                                            ? 2'b10:2'b00;
                                    end
                                    2'b10:begin
                                        new_state = (unsigned'(src1) >= unsigned'(src2)) 
                                            ? 2'b11:2'b01;
                                    end
                                    2'b11:begin
                                        new_state = (unsigned'(src1) >= unsigned'(src2)) 
                                            ? 2'b11:2'b10;
                                    end
                                endcase  
                            end
                            
                            default:begin
                                misprediction = '0;
                                new_state = original_state;
                                taken_branch = '1;    
                            end
                        endcase
                   end
                   
                   /*Determine actual branch address*/
                   always_comb begin
                        if(!redirect & taken_branch) begin
                            branch_address = branch_predicted_address;
                        end
                        else begin
                            branch_address = seq_pc;
                        end
                   end
endmodule
