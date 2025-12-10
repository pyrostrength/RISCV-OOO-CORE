
/* 
    Encodes specific operation
    to be performed by the instruction type's
    execution unit.
	
*/	


module execution_op(input logic funct7,//We only take a single bit of the funct7 field.
				   input logic[2:0] funct3,
				   input logic[1:0] execute_op,
				   output logic[3:0] op_control);
						 
				   always_comb begin 
						op_control = '0;
						case(execute_op)
						  2'b00: 
						      case(funct7)
				                1'b1:
								    case(funct3)
									   3'b000 : op_control = 4'b1000; //Subtraction
									   3'b111 : op_control = 4'b1001; //Arithmetic right shift
									   default : op_control = '0; 
									endcase
										
								1'b0:
								    case(funct3)
									   3'b000: op_control = 4'b0000;  // Addition
									   3'b001: op_control = 4'b0001;  // And
									   3'b010: op_control = 4'b0010;  // Or
									   3'b011: op_control = 4'b0011;  // Xor
									   3'b100: op_control = 4'b0100;  // Slt
									   3'b101: op_control = 4'b0101;  // Slt[unsigned]
									   3'b110: op_control = 4'b0110;  // Sll
									   3'b111: op_control = 4'b0111;  // Srl
									   default: op_control = '0;
								    endcase
							     default:op_control = '0;
							  endcase
						 //Branch instructions
						 2'b01:begin
						      op_control = '0;
						      case(funct3)
						          3'b000: op_control = 4'b0000;//branch if equal
						          3'b001: op_control = 4'b0001;//branch if not equal
						          3'b010: op_control = 4'b0010;//branch if less than
						          3'b011: op_control = 4'b0011;//branch if less than unsigned
						          3'b100: op_control = 4'b0100;//branch if greater than equal to
						          3'b101: op_control = 4'b0101;//branch if greater than equal to unsigned 
						          default: op_control = '0;
						      endcase
						 end
						 //Load instructions
						 2'b10:begin
						      op_control = 1;
						      /*Do not change these op-control assignments*/
						      case(funct3)
						          3'b111: op_control = 4'b0100;//load word
						          3'b010: op_control = 4'b0010;//load half word
						          3'b110: op_control = 4'b1010;//load half word unsigned
						          3'b001: op_control = 4'b0001;//load byte
						          3'b101: op_control = 4'b1001;//load byte unsigned
						          default: op_control = 4'b0100;
						      endcase
						 end
						 
						 //Store instructions.
						 2'b11:begin
						      op_control = 1;
						      /*Do not change these op-control assigments*/
						      case(funct3)
						          3'b111: op_control = 4'b0100;//store word
						          3'b010: op_control = 4'b0010;//store half word
						          3'b001: op_control = 4'b0001;//store byte
						          default: op_control = 4'b0100;
						      endcase
						 end
						 
						 default:op_control = '0;
					   endcase
		           end
endmodule
