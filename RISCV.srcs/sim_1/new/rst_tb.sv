/*Test bench for register status table*/
module rst_tb;
    logic clk,reset;
    logic reg_write,instr_commit,pipeline_reset;
    logic[4:0] commit_reg, dest_reg, src1_reg, src2_reg;
    logic[5:0] instr_rob,reset_rob,read_ptr;
    logic[6:0] src1_booking, src2_booking;
    
    register_status_table rstable(.*);
    
    always begin
        #5 clk = ~clk;
    end
    
    `timescale 1ns/1ps;
    
    initial begin
        clk = '0;
        #100;
        reset = '1;
        pipeline_reset = '0;
        instr_commit = '0;
        reg_write = '0;
        {commit_reg,dest_reg,src1_reg,src2_reg} = '0;
        {instr_rob,reset_rob,read_ptr} = '0;
        
        #10;
        reset = '0;
        reg_write = '1;
        dest_reg = 28;
        instr_rob = 24;
        
        #10;
        reg_write = '0;
        instr_commit = '1;
        commit_reg = 28;
        src1_reg =28;
        
        
    end
    
    

endmodule