/*Generates load address and determine if
load crosses data words*/
module load_address_gen #(parameter W = 31, C = 2)
    (input logic[W:0] load_op1,load_op2,
     input logic[C:0] load_control,
     output logic load_across_words,
    output logic[W:0] load_addr
    );
    
    assign load_addr = load_op1 + load_op2;
    logic[W:0] temp_addr;
    logic[C:0] new_control;
    assign new_control = load_control[C:0] - 1;
    assign temp_addr = load_addr + new_control;
    assign load_across_words = temp_addr[2] != load_addr[2];
    
endmodule