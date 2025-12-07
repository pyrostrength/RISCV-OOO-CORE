/*Generates load address*/
module load_address_gen #(parameter W = 31, C = 3)
    (input logic[W:0] load_op1,load_op2,
     input logic[C:0] load_control,
     output logic load_across_words,
    output logic[W:0] load_addr
    );
    
    assign load_addr = load_op1 + load_op2;
    logic[W:0] temp_addr;
    assign temp_addr = load_addr + (load_control[C-1:0]-1);
    assign load_across_words = temp_addr[2] != load_addr[2];
    
endmodule