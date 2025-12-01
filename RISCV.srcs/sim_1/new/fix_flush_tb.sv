

module fix_flush_tb(

    );
    
    logic clk,reset,reset_pipeline,freeze;
    logic fix;
    logic fix_flush;
    
    `timescale 1ns/1ns;
    always begin
        #5 clk = ~clk;
    end
    
    
    fix_flush flusher(.*);
    
    logic flush;
    task automatic run_flusher();
        reset = $urandom();
        reset_pipeline = $urandom();
        freeze = $urandom();
        fix = $urandom();
        
        if(reset | reset_pipeline)begin
            #2;
            assert(fix_flush == fix) else $display("Improperly reset flusher");
            #8;
            /*Still state*/
            assert(fix_flush == fix) else $display("Flusher should remain reset on 2nd cycle!");
            #10;
            /*Still state*/
            assert(fix_flush == fix) else $display("Flusher should remain reset on 3rd cycle!");
            #10;
            /*Still state*/
            assert(fix_flush == fix) else $display("Flusher should remain reset on 4th cycle!");
            #10;        
        end
        else if(freeze)begin
            #2;
            assert(fix_flush == fix) else $display("Improperly frozen flusher");
            flush = fix_flush;
            #8;
            assert(fix_flush == flush) else $display("Flusher should remain frozen on 1st cycle!");
            #10;
            assert(fix_flush == flush) else $display("Flusher should remain frozen on 2nd cycle!");
            #10;
            assert(fix_flush == flush) else $display("Flusher should remain frozen on 3rd cycle!");
            #10;  
        end
        else begin
            if(fix)begin
                #2;
                assert(fix_flush == '1) else $display("Flush should be asserted even in still state");
                #8;
                assert(fix_flush == '1) else $display("Flush should be asserted for 3 cycles,this is second");
                #10;
                assert(fix_flush == '1) else $display("Flusher should asserted for 3 cycles!,this is third");
                #10;
                assert(fix_flush == '0) else $display("Flusher should be deasserted after 3 cycle assertion");
                #10;
            end
            else begin
                #2;
                assert(fix_flush == '0) else $display("Flush asserted yet no branch prediction made,d");
                #8;
                assert(fix_flush == '0) else $display("State shouldn't have changed on 1st cycle");
                #10;
                assert(fix_flush == '0) else $display("State shouldn't have changed on 2nd cycle");
                #10;
                assert(fix_flush == '0) else $display("State shouldn't have changed on 3rd cycle");
                #10;
            end
        end
    endtask
    
    initial begin
        #100;
        clk = '1;
        while($time < 100000)begin
            run_flusher();
        end
    end
endmodule
