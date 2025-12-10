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

module databus_arbiter #(parameter W = 31, ROB = 32, I = 7)
                        (input logic clk,reset,
                         input logic[$clog2(ROB):0] jalr_rob,jal_rob,load_rob,store_rob,ri_rob,branch_rob,u_rob,
                         input logic ri_request,jal_request,jalr_request,branch_request,store_request,u_request,
                         input logic load_request,taken_branch,
                         input logic[W:0] ri_data,jalr_data,jal_data,store_data,store_address,load_data,u_data,
                         input logic[W:0] target_address,
                         input logic[I:0] t_index,
                         input logic[1:0] new_state,
                         output logic cdb_broadcast,
                         output logic[W:0] broadcast_data,broadcast_address,
                         output logic[$clog2(ROB):0] broadcast_rob,
                         
                         /*Full signals for pseudo reservation station of jal
                         and U-type instructions*/
                         output logic full_u_rob_buffer, full_jal_rob_buffer);
                         
                         logic[6:0] grant;
                         /*Buffer for load instructions*/
                         logic empty_load_rob_buffer;
                         logic[$clog2(ROB):0] read_load_rob;
                         fifo_buffer #(.DW($clog2(ROB))) load_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(empty_load_rob_buffer),
                                                                         .write(load_request),
                                                                         .read(grant[0]),
                                                                         .wr_data(load_rob),
                                                                         .rd_data(read_load_rob));
                         
                         logic[W:0] read_load_data;
                         fifo_buffer #(.DW(W)) load_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(),
                                                                         .write(load_request),
                                                                         .read(grant[0]),
                                                                         .wr_data(load_data),
                                                                         .rd_data(read_load_data));
                         /*Buffer for store instructions*/
                         logic empty_store_rob_buffer;
                         logic[$clog2(ROB):0] read_store_rob;
                         fifo_buffer #(.DW($clog2(ROB))) store_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(empty_store_rob_buffer),
                                                                         .write(store_request),
                                                                         .read(grant[1]),
                                                                         .wr_data(store_rob),
                                                                         .rd_data(read_store_rob));
                                                                         
                         logic[W:0] read_store_data;
                         fifo_buffer store_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(),
                                                                         .write(store_request),
                                                                         .read(grant[1]),
                                                                         .wr_data(store_data),
                                                                         .rd_data(read_store_data));
                                                                         
                         logic[W:0] read_store_address;
                         fifo_buffer  store_address_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(),
                                                                         .write(store_request),
                                                                         .read(grant[1]),
                                                                         .wr_data(store_address),
                                                                         .rd_data(read_store_address));
                                                                         
                         
                         /*Buffer for branch instructions*/
                         logic empty_branch_buffer;
                         logic[$clog2(ROB):0] read_branch_rob;
                         fifo_buffer #(.DW($clog2(ROB))) branch_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(empty_branch_buffer),
                                                                         .write(branch_request),
                                                                         .read(grant[2]),
                                                                         .wr_data(branch_rob),
                                                                         .rd_data(read_branch_rob));
                         
                         logic[W:0] read_branch_target;
                         fifo_buffer #(.DW(W)) branch_target_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(),
                                                                         .write(branch_request),
                                                                         .read(grant[2]),
                                                                         .wr_data(target_address),
                                                                         .rd_data(read_branch_target));
                         
                         logic[I+3:0] read_branch_index;
                         fifo_buffer #(.DW(I+3)) branch_index_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(),
                                                                         .write(branch_request),
                                                                         .read(grant[2]),
                                                                         .wr_data({new_state,taken_branch,t_index}),
                                                                         .rd_data(read_branch_index));
                         
                         /*Buffer for jalr instructions*/
                         logic empty_jalr_rob_buffer;
                         logic[$clog2(ROB):0] read_jalr_rob;
                         fifo_buffer #(.DW($clog2(ROB))) jalr_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(empty_jalr_rob_buffer),
                                                                         .write(jalr_request),
                                                                         .read(grant[3]),
                                                                         .wr_data(jalr_rob),
                                                                         .rd_data(read_jalr_rob));
                         
                         logic[W:0] read_jalr_data;
                         fifo_buffer #(.DW(W)) jalr_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(),
                                                                         .write(jalr_request),
                                                                         .read(grant[3]),
                                                                         .wr_data(jalr_data),
                                                                         .rd_data(read_jalr_data));
                         
                         /*Buffer for jal instructions*/
                         logic empty_jal_rob_buffer;
                         logic[$clog2(ROB):0] read_jal_rob;
                         fifo_buffer #(.DW($clog2(ROB))) jal_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_jal_rob_buffer),
                                                                         .empty(empty_jal_rob_buffer),
                                                                         .write(jal_request),
                                                                         .read(grant[4]),
                                                                         .wr_data(jal_rob),
                                                                         .rd_data(read_jal_rob));
                         
                         logic[W:0] read_jal_data;
                         fifo_buffer #(.DW(W)) jal_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(),
                                                                         .write(jal_request),
                                                                         .read(grant[4]),
                                                                         .wr_data(jal_data),
                                                                         .rd_data(read_jal_data));
                         
                         /*Buffer for u instructions*/
                         logic empty_u_rob_buffer;
                         logic[$clog2(ROB):0] read_u_rob;
                         fifo_buffer #(.DW($clog2(ROB))) u_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(full_u_rob_buffer),
                                                                         .empty(empty_u_rob_buffer),
                                                                         .write(u_request),
                                                                         .read(grant[4]),
                                                                         .wr_data(u_rob),
                                                                         .rd_data(read_u_rob));
                         
                         logic[W:0] read_u_data;
                         fifo_buffer #(.DW(W)) u_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(),
                                                                         .write(u_request),
                                                                         .read(grant[4]),
                                                                         .wr_data(u_data),
                                                                         .rd_data(read_u_data));
                         
                          /*Buffer for ri instructions*/
                         logic empty_ri_rob_buffer;
                         logic[$clog2(ROB):0] read_ri_rob;
                         fifo_buffer #(.DW($clog2(ROB))) ri_rob_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(empty_ri_rob_buffer),
                                                                         .write(ri_request),
                                                                         .read(grant[5]),
                                                                         .wr_data(ri_rob),
                                                                         .rd_data(read_ri_rob));
                         
                         logic[W:0] read_ri_data;
                         fifo_buffer #(.DW(W)) ri_data_buffer(.clk(clk),
                                                                         .reset(reset),
                                                                         .full(),
                                                                         .empty(),
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
                                    if (!empty_load_rob_buffer) grant[0] = 1'b1; 
                                    else if (!empty_store_rob_buffer) grant[1] = 1'b1; 
                                    else if (!empty_branch_buffer) grant[2] = 1'b1; 
                                    else if (!empty_jalr_rob_buffer) grant[3] = 1'b1;
                                    else if(!empty_jal_rob_buffer) grant[4] = 1'b1;
                                    else if(!empty_ri_rob_buffer) grant[5] = 1'b1;
                                    else if(!empty_u_rob_buffer) grant[6] = 1'b1;
                                end
                                
                                3'd1: begin 
                                    if (!empty_store_rob_buffer) grant[1] = 1'b1; 
                                    else if (!empty_branch_buffer) grant[2] = 1'b1; 
                                    else if (!empty_jalr_rob_buffer) grant[3] = 1'b1; 
                                    else if (!empty_jal_rob_buffer) grant[4] = 1'b1;
                                    else if(!empty_ri_rob_buffer) grant[5] = 1'b1;
                                    else if(!empty_u_rob_buffer) grant[6] = 1'b1;
                                    else if(!empty_load_rob_buffer) grant[0] = 1'b1;
                                end
                                
                                3'd2: begin 
                                    if (!empty_branch_buffer) grant[2] = 1'b1; 
                                    else if (!empty_jalr_rob_buffer) grant[3] = 1'b1; 
                                    else if (!empty_jal_rob_buffer) grant[4] = 1'b1; 
                                    else if (!empty_ri_rob_buffer) grant[5] = 1'b1;
                                    else if(!empty_u_rob_buffer) grant[6] = 1'b1;
                                    else if(!empty_load_rob_buffer) grant[0] = 1'b1;
                                    else if(!empty_store_rob_buffer) grant[1] = 1'b1;
                                end 
                                
                                3'd3: begin 
                                    if (!empty_jalr_rob_buffer) grant[3] = 1'b1; 
                                    else if (!empty_jal_rob_buffer) grant[4] = 1'b1; 
                                    else if (!empty_ri_rob_buffer) grant[5] = 1'b1;
                                    else if(!empty_u_rob_buffer) grant[6] = 1'b1; 
                                    else if (!empty_load_rob_buffer) grant[0] = 1'b1;
                                    else if(!empty_store_rob_buffer) grant[1] = 1'b1;
                                    else if(!empty_branch_buffer) grant[2] = 1'b1;
                                end
                                
                                3'd4: begin 
                                    if (!empty_jal_rob_buffer) grant[4] = 1'b1; 
                                    else if (!empty_ri_rob_buffer) grant[5] = 1'b1;
                                    else if(!empty_u_rob_buffer) grant[6] = 1'b1; 
                                    else if (!empty_load_rob_buffer) grant[0] = 1'b1; 
                                    else if (!empty_store_rob_buffer) grant[1] = 1'b1;
                                    else if(!empty_branch_buffer) grant[2] = 1'b1;
                                    else if(!empty_jalr_rob_buffer) grant[3] = 1'b1;
                                end
                                
                                3'd5: begin 
                                    if (!empty_ri_rob_buffer) grant[5] = 1'b1;
                                    else if(!empty_u_rob_buffer) grant[6] = 1'b1; 
                                    else if (!empty_load_rob_buffer) grant[0] = 1'b1; 
                                    else if (!empty_store_rob_buffer) grant[1] = 1'b1; 
                                    else if (!empty_branch_buffer) grant[2] = 1'b1;
                                    else if(!empty_jalr_rob_buffer) grant[3] = 1'b1;
                                    else if(!empty_jal_rob_buffer) grant[4] = 1'b1;
                                end
                                
                                3'd6:begin
                                    if (!empty_u_rob_buffer) grant[6] = 1'b1;
                                    else if (!empty_load_rob_buffer) grant[0] = 1'b1; 
                                    else if (!empty_store_rob_buffer) grant[1] = 1'b1; 
                                    else if (!empty_branch_buffer) grant[2] = 1'b1;
                                    else if(!empty_jalr_rob_buffer) grant[3] = 1'b1;
                                    else if(!empty_jal_rob_buffer) grant[4] = 1'b1;
                                    else if(!empty_ri_rob_buffer) grant[5] = 1'b1;
                                end
                                default:begin
                                    grant = '0;
                                end
                            endcase
                         end 
                         
                         
                         
                         logic[W:0] data_next,addr_next;
                         logic[$clog2(ROB):0] rob_next;
                         logic broadcast;
                         assign broadcast = (grant != '0); 
                         
                         always_ff @(posedge clk)begin
                            if(reset)begin
                                broadcast_data <= '0;
                                broadcast_rob <= '0;
                                broadcast_address <= '0;
                                cdb_broadcast <= '0;
                            end
                            else begin
                                broadcast_data <= data_next;
                                broadcast_rob <= rob_next;
                                broadcast_address <= addr_next;
                                cdb_broadcast <= broadcast;
                            end
                         end
                         
                         /*Writes to CDB based on current grant*/
                         always_comb begin
                            data_next = read_load_data;
                            rob_next = read_load_rob;
                            addr_next = read_load_data;
                            case(grant)
                                7'd1:begin
                                    data_next = read_load_data;
                                    rob_next = read_load_rob;
                                    addr_next = read_load_data;   
                                end
                                
                                7'd2:begin
                                    data_next = read_store_data;
                                    rob_next = read_store_rob;
                                    addr_next = read_store_address;
                                end
                                
                                7'd4:begin
                                    data_next = {'0,read_branch_index};
                                    rob_next = read_branch_rob;
                                    addr_next = read_branch_target;
                                end
                                
                                7'd8:begin
                                    data_next = read_jalr_data;
                                    rob_next = read_jalr_rob;
                                    addr_next = read_jalr_data;
                                end
                                
                                7'd16:begin
                                    data_next = read_jal_data;
                                    rob_next = read_jal_rob;
                                    addr_next = read_jal_data;   
                                end
                                
                                7'd32:begin
                                    data_next = read_ri_data;
                                    rob_next = read_ri_rob;
                                    addr_next = read_ri_data;    
                                end
                                
                                7'd64:begin
                                    data_next = read_u_data;
                                    rob_next = read_u_rob;
                                    addr_next = read_u_data;
                                end
                                
                                default:begin
                                    data_next = read_load_data;
                                    rob_next = read_load_rob;
                                    addr_next = read_load_data;   
                                end
                            endcase   
                         end                 
endmodule
