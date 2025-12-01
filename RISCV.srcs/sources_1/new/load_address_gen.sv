/*Generates load address*/
module load_address_gen #(parameter W = 31)
    (input logic[W:0] load_op1,load_op2,
    output logic[W:0] load_addr
    );
    
    assign load_addr = load_op1 + load_op2;
    
endmodule