/*Generates store address and determine if 
a store crosses two data words*/

module store_address_gen #(parameter W = 31, C = 2)
    (input logic[W:0] store_op1,store_op2,commit_addr,
     input logic[C:0] commit_mode,
     output logic store_across_words,
    output logic[W:0] store_address
    );
    
    assign store_address = store_op1 + store_op2;
    logic[W:0] temp_addr;
    logic[C:0] new_control;
    assign new_control = (commit_mode[C:0] - 1);
    assign temp_addr = commit_addr + new_control;
    assign store_across_words = temp_addr[2] != commit_addr[2];
endmodule
