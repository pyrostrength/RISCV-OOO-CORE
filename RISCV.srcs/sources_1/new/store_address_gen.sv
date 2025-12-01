/*Generates store address*/

module store_address_gen #(parameter W = 31)
    (input logic[W:0] store_op1,store_op2,
    output logic[W:0] store_address
    );
    
    assign store_address = store_op1 + store_op2;
endmodule
