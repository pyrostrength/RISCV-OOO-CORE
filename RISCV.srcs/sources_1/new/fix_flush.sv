/*
If instruction in
decode stage 2 is jal instruction
or branch instruction for which
target address was mispredicted then
pipeline needs to be flushed. As
there are 3 preceding stages we need
to implement a 3 cycle flush whereby
register in between decode stage 2
and write setup on rob and reservation
station pushes out zeroes*/

module fix_flush
    (input logic clk,reset,reset_pipeline,freeze,
     input logic fix,
     output logic fix_flush
    );
    
    typedef enum{flush1,flush2,flush3,still} state_type;
    (* keep = "true" *) state_type state,state_next;
    
    always_ff @(posedge clk)begin
        if(reset | reset_pipeline)
            state <= still;
            
        else if(freeze)begin
            state <= state;
        end
        
        else begin
            state <= state_next;
        end
    end
    
    always_comb begin
        fix_flush = '0;
        state_next = state;
        case(state)
            still:begin
                fix_flush = '0;
                state_next = (fix) ? flush1 : still;
            end
            
            flush1:begin
                fix_flush = '1;
                state_next = flush2;
            end
            
            flush2:begin
                fix_flush = '1;
                state_next = flush3;
            end
            
            flush3:begin
                fix_flush = '1;
                state_next = still;
            end
            
        endcase
    end

endmodule
