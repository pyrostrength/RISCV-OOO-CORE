/*Execution units for JALR instructions*/

module jalr_unit #(parameter W = 31)
    (input logic is_jalr_instruction,
     input logic[W:0] op1,op2,seq_pc,
     /*JALR instruction stores next sequential
     PC in register rd. THis is what's broadcast
     on CDB*/
     output logic[W:0] store_pc,
     output logic jalr_cdb_request,
     /*Target address of jalr instruction*/
     output logic[W:0] jalr_jump_address
    );
    
    assign jalr_cdb_request = is_jalr_instruction;
    assign store_pc = seq_pc;
    assign jalr_jump_address = op1 + op2;
    
endmodule
