`timescale 1ns / 1ps


module gshare_test #(parameter I = 7, W = 31)
    (

    );
    
    logic clk,reset;
    logic[I:0] pc_lowerbits;
    logic[I:0] ghr_restore;
    logic update,restore; 
    logic branch_taken;
    logic[I:0] index;
    logic[I:0] ghr_checkpoint;
    
    gshare_predictor predictor(.*);
    always begin
        #5 clk = ~clk;
    end
    logic[I:0] ghr;
    /*Ensure ghr is updated to correct
    value based on relevant conditions*/
    task automatic check_ghr();
        reset = $urandom();
        pc_lowerbits = $urandom();
        ghr_restore = $urandom();
        restore = $urandom();
        update = $urandom();
        branch_taken = $urandom();
        
        assert (index == ghr_checkpoint ^ pc_lowerbits) else $display("Incorrect pht and btb index produced,ps");
        if(reset)begin
            #10;
            assert(ghr_checkpoint == '0) else $display("ghr not reset,ps");
        end
        else if(restore) begin
            #10;
            assert(ghr_checkpoint == ghr_restore) else $display("ghr not restored upon pipeline reset,ps");
        end
        else if(update)begin
            ghr = ghr_checkpoint;
            #10;
            assert(ghr_checkpoint == {ghr[7:1],branch_taken}) else $display("No updates occuring,ps");
        end
        else begin
            ghr = ghr_checkpoint;
            #10;
            assert(ghr_checkpoint == ghr) else $display("ghr changing when no branch committed and no pipeline reset,ps");
        end
    endtask
    
    initial begin
        #100;
        clk = '1;
        while($time<10**9)begin
            check_ghr();
        end
    end
endmodule
