/*
If a hit occurs on branch target buffer
we need to eliminate subsequent instruction
*/

module btb_flush(
    input logic clk,reset,reset_pipeline,freeze,
    input logic hit,
    output logic short_flush
    );
    
    typedef enum{flush,still} state_type;
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
        short_flush = '0;
        state_next = state;
        case(state)
            still:begin
                short_flush = (hit) ? '1: '0;
                if(hit)begin
                    state_next = flush;
                end
            end
            
            /*Flush state only for 1 clock transition*/
            flush:begin
                short_flush = '0;
                state_next = still;
            end
            
        endcase
    end

endmodule
