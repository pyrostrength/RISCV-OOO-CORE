/*
Testbench for PC selection stage
*/
module pc_select_test #(parameter W = 31)
    (

    );
    logic[W:0] reset_addr,fix_addr;
    logic[W:0] predicted_addr;
    logic clk,reset;
    logic reset_pipeline;
    logic fix;
    logic freeze,btb_hit,pht_hit;
    logic[W:0] PC;
    
    always begin
        #5 clk = ~clk;
    end
    
    `timescale 1ns/1ps;
    pc_select selector(.*);
    
    /*
    This tasks randomizes next PC selection
    signals and checks to see if appropriate PC is
    sent out by the instruction. If appropriate PC
    isn't sent out, error is displayed on console.
    */ 
    logic[W:0] PC_next;
    task automatic check_PC();
        reset_addr = $urandom();
        fix_addr = $urandom();
        predicted_addr = $urandom();
        reset = $urandom();
        reset_pipeline = $urandom();
        fix = $urandom();
        freeze = $urandom();
        btb_hit = $urandom();
        pht_hit = $urandom();
        if(reset)begin
            #10;
            assert(PC == '0) else $display("PC not reset to 0 when global reset is asserted,bs");
        end
        else if(reset_pipeline)begin
            #10;
            assert(PC == reset_addr) else $display("Program flow not properly reset,bs");
        end
        else if(freeze)begin
            PC_next = PC;
            #10;
            assert(PC == PC_next) else $display("PC not frozen when freeze signal asserted,bs");
        end
        
        else if(fix)begin
            #10;
            assert(PC == fix_addr) else $display("PC not changed to jal jump address or correct branch \
            address for predicted taken branch,bs");
        end
        
        else if(btb_hit & pht_hit)begin
            #10;
            assert(PC == predicted_addr) else $display("PC hasnt switched according to prediction,bs");
        end
        
        else begin
            PC_next = PC;
            #10;
            assert(PC == (PC_next + 1)) else $display("Usual PC increments by 1 not occuring,bs");
        end
    endtask
    initial begin
        #100;
        clk = '1;
        /*Iterate for 1 second*/
        while($time<10**9)begin
            check_PC();
        end      
    end
    
    
endmodule
