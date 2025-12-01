
module short_flush_tb(

    );
    
    logic clk,reset,reset_pipeline,freeze;
    logic hit;
    logic short_flush;
    
    `timescale 1ns/1ns;
    always begin
        #5 clk = ~clk;
    end
    
    
    btb_flush flusher(.*);
    
    logic flush;
    task automatic run_flusher();
        reset = $urandom();
        reset_pipeline = $urandom();
        freeze = $urandom();
        hit = $urandom();
        
        if(reset | reset_pipeline)begin
            #2;
            assert(short_flush == hit) else $display("Improperly reset flusher,d");
            #8;
            assert(short_flush == hit) else $display("Flusher should remain reset!,d");
            #10;       
        end
        else if(freeze)begin
            #2;
            assert(short_flush == hit) else $display("Improperly frozen flusher,d");
            flush = short_flush;
            #8;
            assert(short_flush == flush) else $display("Flusher should remain frozen!,d");
            #10;  
        end
        else begin
            if(hit)begin
                #2;
                assert(short_flush == '1) else $display("Flush should be asserted even in still state,d");
                #8;
                assert(short_flush == '0) else $display("Flush should only be asserted for 1 clock cycle,d");
                #10;
            end
            else begin
                #2;
                assert(short_flush == '0) else $display("Flush asserted yet no branch prediction made,d");
                #8;
                assert(short_flush == '0) else $display("State shouldn't have changed,d");
                #10;
            end
        end
    endtask
    
    initial begin
        #100;
        clk = '1;
        run_flusher();
    end
endmodule
