module fifo_tb;
    
    //Signal declaration
    logic clk,reset;
    logic write,read;
    logic full,empty;
    logic[7:0] wr_data;
    logic [7:0] rd_data;
    
    fifo_buffer #(.DW(7)) buffer(.*);
    
    always begin
        #5 clk = ~clk;
    end
    
    `timescale 1ns/1ps;
    
    initial begin
        #100;
        reset = '1;
        clk = '0;
        read = '0;
        write = '0;
        wr_data = '0;
        
        #5;
        assert(full == '0);
        assert(empty == '1);
        
        //Test for same cycle read and write
        
        reset = '0;
        wr_data = 75;
        write = '1;
        read = '1;
        #10;
        
        /*
        reset = '0; 
        wr_data = 75;
        write = '1;
        #10; 
        assert(full == 0);
        assert(empty == 0);
        
        //Initiate next write after write 1 completes
        wr_data  = 32;
        write = '1;
        #10;
        assert(full == 0);
        assert(empty == 0);
        
        //Initiate read
        write = '0;
        wr_data = 14;
        read = '1;
        assert (rd_data == 75);
        #10;
        assert(full == 0); 
        assert(empty == 0);
        assert (rd_data == 32);
        
        
        //Initiate write with no read
        write = '1;
        read = '0;
        #10;
        assert (full == 0);
        assert(empty == 0);
        assert (rd_data == 32);
        
        //2 reads to clear buffer
        //First read
        write = '0;
        read = '1;
        assert(rd_data == 32);
        #10;
        assert(full == 0); 
        assert(empty == 0);
        assert (rd_data == 14);
        
        //Last Read
        
        #10;
        assert (empty == 1);
        assert (full == 0);
        
        //Filling Buffer - ensure write looping works
        write = '1;
        read = '0;
        for(int i = 1; i<18 ; i++) begin
            wr_data = i*(i+2);
            #10;
        end 
        
        /*Buffer is full, now try writing some more*/
        /*
        wr_data = 38;
        write = '1;
        assert (full == '1);
        #10;
        
        read = '1; 
        assert (full == '0);*/         
    end
endmodule