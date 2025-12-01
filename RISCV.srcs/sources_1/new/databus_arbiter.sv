/*
Instructions are written into FIFO buffers before being
selected to broadcast results into CDB. Since there
are multiple execution units, a scheme for selecting
what type of instruction's results to broadcast on
CDB is required. A round robin arbitrer is implemented
for the selection process.

As of module implementation, no explicit use
case for CPU has been made. As such, statistics
of program instruction type cannot be determined
thus a priority encoded selection scheme makes 
little sense*/

module databus_arbiter #(parameter W = 31, ROB = 32)
                        (input logic clk,reset,
                         input logic[$clog2(ROB):0] jalr_rob,jal_rob,load_rob,store_rob,ri_rob,branch_rob,u_rob,
                         input logic ri_request,jal_request,jalr_request,branch_request,store_request,u_request,
                         input logic load_request,
                         input logic[W:0] ri_data,jalr_data,jal_result,store_data,store_address,load_data,u_data,
                         output logic cdb_broadcast,
                         output logic[W:0] broadcast_data,broadcast_address,
                         output logic[$clog2(ROB):0] broadcast_rob);
                         
                         logic[6:0] grant;
                         /*Buffer for load instructions*/
                         logic full_load_rob_buffer,empty_load_rob_buffer;
                         logic[$clog2(ROB):0] read_load_rob;
                         fifo_buffer #(.DW($clog2(ROB))) load_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_load_rob_buffer),
                                                                         .empty(empty_load_rob_buffer),
                                                                         .write(load_request),
                                                                         .read(grant[0]),
                                                                         .wr_data(load_rob),
                                                                         .rd_data(read_load_rob));
                         
                         logic full_load_data_buffer,empty_load_data_buffer;
                         logic[W:0] read_load_data;
                         fifo_buffer #(.DW(W)) load_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_load_data_buffer),
                                                                         .empty(empty_load_data_buffer),
                                                                         .write(load_request),
                                                                         .read(grant[0]),
                                                                         .wr_data(load_data),
                                                                         .rd_data(read_load_data));
                         /*Buffer for store instructions*/
                         logic full_store_rob_buffer,empty_store_rob_buffer;
                         logic[$clog2(ROB):0] read_store_rob;
                         fifo_buffer #(.DW($clog2(ROB))) store_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_store_rob_buffer),
                                                                         .empty(empty_store_rob_buffer),
                                                                         .write(store_request),
                                                                         .read(grant[1]),
                                                                         .wr_data(store_rob),
                                                                         .rd_data(read_store_rob));
                                                                         
                         logic full_store_data_buffer,empty_store_data_buffer;
                         logic[W:0] read_store_data;
                         fifo_buffer store_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_store_data_buffer),
                                                                         .empty(empty_store_data_buffer),
                                                                         .write(store_request),
                                                                         .read(grant[1]),
                                                                         .wr_data(store_data),
                                                                         .rd_data(read_store_data));
                         logic full_store_address_buffer,empty_store_address_buffer;
                         logic[W:0] read_store_address;
                         fifo_buffer  store_address_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_store_address_buffer),
                                                                         .empty(empty_store_address_buffer),
                                                                         .write(store_request),
                                                                         .read(grant[1]),
                                                                         .wr_address(store_address),
                                                                         .rd_address(read_store_address));
                                                                         
                         
                         /*Buffer for branch instructions*/
                         logic full_branch_buffer,empty_branch_buffer;
                         logic[$clog2(ROB):0] read_branch_rob;
                         fifo_buffer #(.DW($clog2(ROB))) branch_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_branch_buffer),
                                                                         .empty(empty_branch_buffer),
                                                                         .write(branch_request),
                                                                         .read(grant[2]),
                                                                         .wr_data(branch_rob),
                                                                         .rd_data(read_branch_rob));
                         
                         /*Buffer for jalr instructions*/
                         logic full_jalr_rob_buffer,empty_jalr_rob_buffer;
                         logic[$clog2(ROB):0] read_jalr_rob;
                         fifo_buffer #(.DW($clog2(ROB))) jalr_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_jalr_rob_buffer),
                                                                         .empty(empty_jalr_rob_buffer),
                                                                         .write(jalr_request),
                                                                         .read(grant[3]),
                                                                         .wr_data(jalr_rob),
                                                                         .rd_data(read_jalr_rob));
                         
                         logic full_jalr_data_buffer,empty_jalr_data_buffer;
                         logic[W:0] read_jalr_data;
                         fifo_buffer #(.DW(W)) jalr_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_jalr_data_buffer),
                                                                         .empty(empty_jalr_data_buffer),
                                                                         .write(jalr_request),
                                                                         .read(grant[3]),
                                                                         .wr_data(jalr_data),
                                                                         .rd_data(read_jalr_data));
                         
                         /*Buffer for jal instructions*/
                         logic full_jal_rob_buffer,empty_jal_rob_buffer;
                         logic[$clog2(ROB):0] read_jal_rob;
                         fifo_buffer #(.DW($clog2(ROB))) jal_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_jal_rob_buffer),
                                                                         .empty(empty_jal_rob_buffer),
                                                                         .write(jal_request),
                                                                         .read(grant[4]),
                                                                         .wr_data(jal_rob),
                                                                         .rd_data(read_jal_rob));
                         
                         logic full_jal_data_buffer,empty_jal_data_buffer;
                         logic[W:0] read_jal_data;
                         fifo_buffer #(.DW(W)) jal_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_jal_data_buffer),
                                                                         .empty(empty_jal_data_buffer),
                                                                         .write(jal_request),
                                                                         .read(grant[4]),
                                                                         .wr_data(jal_result),
                                                                         .rd_data(read_jal_data));
                         
                         /*Buffer for u instructions*/
                         logic full_u_rob_buffer,empty_u_rob_buffer;
                         logic[$clog2(ROB):0] read_u_rob;
                         fifo_buffer #(.DW($clog2(ROB))) u_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_u_rob_buffer),
                                                                         .empty(empty_u_rob_buffer),
                                                                         .write(u_request),
                                                                         .read(grant[4]),
                                                                         .wr_data(u_rob),
                                                                         .rd_data(read_u_rob));
                         
                         logic full_u_data_buffer,empty_u_data_buffer;
                         logic[W:0] read_u_data;
                         fifo_buffer #(.DW(W)) u_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_u_data_buffer),
                                                                         .empty(empty_u_data_buffer),
                                                                         .write(u_request),
                                                                         .read(grant[4]),
                                                                         .wr_data(u_result),
                                                                         .rd_data(read_u_data));
                         
                          /*Buffer for ri instructions*/
                         logic full_ri_rob_buffer,empty_ri_rob_buffer;
                         logic[$clog2(ROB):0] read_ri_rob;
                         fifo_buffer #(.DW($clog2(ROB))) ri_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_ri_rob_buffer),
                                                                         .empty(empty_ri_rob_buffer),
                                                                         .write(ri_request),
                                                                         .read(grant[5]),
                                                                         .wr_data(ri_rob),
                                                                         .rd_data(read_ri_rob));
                         
                         logic full_ri_data_buffer,empty_ri_data_buffer;
                         logic[W:0] read_ri_data;
                         fifo_buffer #(.DW(W)) ri_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_ri_data_buffer),
                                                                         .empty(empty_ri_data_buffer),
                                                                         .write(ri_request),
                                                                         .read(grant[5]),
                                                                         .wr_data(ri_data),
                                                                         .rd_data(read_ri_data));
                         
                         logic [2:0] pointer; 
                         // Sequential logic for the pointer 
                         always_ff @(posedge clk) begin 
                            if (reset) begin 
                                pointer <= 0; 
                            end 
                            else begin 
                            /*Update priority based on the granted request. 
                            If request was granted, next priority starts 
                            after the current grant. If no request was granted, 
                            the pointer remains the same*/ 
                                if (grant[0]) pointer <= 3'd1; 
                                else if (grant[1]) pointer <= 3'd2; 
                                else if (grant[2]) pointer <= 3'd3; 
                                else if (grant[3]) pointer <= 3'd4;
                                else if(grant[4]) pointer <= 3'd5;
                                else if(grant[5]) pointer <= 3'd0;  
                            end 
                         end 
                         
                         /*Granting access to each functional unit*/ 
                         always_comb begin 
                            grant = '0;  
                            case (pointer) 
                                3'd0: begin 
                                    if (load_request) grant[0] = 1'b1; 
                                    else if (store_request) grant[1] = 1'b1; 
                                    else if (branch_request) grant[2] = 1'b1; 
                                    else if (jalr_request) grant[3] = 1'b1;
                                    else if(jal_request) grant[4] = 1'b1;
                                    else if(ri_request) grant[5] = 1'b1;
                                    else if(u_request) grant[6] = 1'b1;
                                end
                                
                                3'd1: begin 
                                    if (store_request) grant[1] = 1'b1; 
                                    else if (branch_request) grant[2] = 1'b1; 
                                    else if (jalr_request) grant[3] = 1'b1; 
                                    else if (jal_request) grant[4] = 1'b1;
                                    else if(ri_request) grant[5] = 1'b1;
                                    else if(u_request) grant[6] = 1'b1;
                                    else if(load_request) grant[0] = 1'b1;
                                end
                                
                                3'd2: begin 
                                    if (branch_request) grant[2] = 1'b1; 
                                    else if (jalr_request) grant[3] = 1'b1; 
                                    else if (jal_request) grant[4] = 1'b1; 
                                    else if (ri_request) grant[5] = 1'b1;
                                    else if(u_request) grant[6] = 1'b1;
                                    else if(load_request) grant[0] = 1'b1;
                                    else if(store_request) grant[1] = 1'b1;
                                end 
                                
                                3'd3: begin 
                                    if (jalr_request) grant[3] = 1'b1; 
                                    else if (jal_request) grant[4] = 1'b1; 
                                    else if (ri_request) grant[5] = 1'b1;
                                    else if(u_request) grant[6] = 1'b1; 
                                    else if (load_request) grant[0] = 1'b1;
                                    else if(store_request) grant[1] = 1'b1;
                                    else if(branch_request) grant[2] = 1'b1;
                                end
                                
                                3'd4: begin 
                                    if (jal_request) grant[4] = 1'b1; 
                                    else if (ri_request) grant[5] = 1'b1;
                                    else if(u_request) grant[6] = 1'b1; 
                                    else if (load_request) grant[0] = 1'b1; 
                                    else if (store_request) grant[1] = 1'b1;
                                    else if(branch_request) grant[2] = 1'b1;
                                    else if(jalr_request) grant[3] = 1'b1;
                                end
                                
                                3'd5: begin 
                                    if (ri_request) grant[5] = 1'b1;
                                    else if(u_request) grant[6] = 1'b1; 
                                    else if (load_request) grant[0] = 1'b1; 
                                    else if (store_request) grant[1] = 1'b1; 
                                    else if (branch_request) grant[2] = 1'b1;
                                    else if(jalr_request) grant[3] = 1'b1;
                                    else if(jal_request) grant[4] = 1'b1;
                                end
                                
                                3'd6:begin
                                    if (u_request) grant[6] = 1'b1;
                                    else if (load_request) grant[0] = 1'b1; 
                                    else if (store_request) grant[1] = 1'b1; 
                                    else if (branch_request) grant[2] = 1'b1;
                                    else if(jalr_request) grant[3] = 1'b1;
                                    else if(jal_request) grant[4] = 1'b1;
                                    else if(ri_request) grant[5] = 1'b1;
                                end
                            endcase
                         end 
                         
                         assign cdb_broadcast = (grant != '0);                  
endmodule
