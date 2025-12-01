/*Functional unit for R-type, U-type and I-type instructions*/
module alu #(parameter W = 31, C = 3, ROB = 32)
            (input logic is_ri_instr,
             input logic[$clog2(ROB):0] instr_rob,
             input logic [C:0] op_control,
             input logic signed[W:0] op1,op2,
             output logic[$clog2(ROB):0] ri_rob,
             output logic ri_cdb_request,
             output logic signed[W:0] result);
             
             assign ri_cdb_request = is_ri_instr;
             assign ri_rob = instr_rob;
             /*For shifts with immediate the shift amount
			 is encoded in first 5 bits of immediate or rs2 value.
			 */
			 always_comb begin
			     result = 32'd0;
			     case(op_control)
			         4'b0000:result = op1 + op2;
			         4'b0001:result = op1 & op2;
			         4'b0010:result = op1 | op2;
			         4'b0011:result = op1 ^ op2;
			         4'b0100:result = op1 < op2;
			         4'b0101:result = unsigned'(op1) < unsigned' (op2);
			         4'b0110:result = op1 << op2[4:0];
			         4'b0111:result = op1 >> op2[4:0];
			         4'b1000:result = op1 - op2;
			         4'b1001:result = op1 >>> op2[4:0];
			     endcase
			 end
endmodule
