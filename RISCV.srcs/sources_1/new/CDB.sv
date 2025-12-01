/*
Buffers executed instructions as they
await their turn to write to CDB
*/

module CDB #(parameter W = 31, ROB = 32)
                        (input logic clk,reset,
                         input logic[$clog2(ROB):0] j_rob,jal_rob,load_entry_rob,st_rob,alu_rob,b_rob,u_rob,
                         input logic ri_request,jal_request,jalr_request,branch_request,store_request,
                         input logic load_request,u_request,
                         input logic[W:0] ri_data,jalr_data,jal_data,st_data,st_addr,retrieved_data,u_data,
                         output logic[W:0] broadcast_data,broadcast_address,
                         output logic cdb_broadcast,
                         output logic[$clog2(ROB):0] broadcast_rob);
                         
                         
                         databus_arbiter(.clk(clk),
                                         .reset(reset),
                                         .u_rob(u_rob),
                                         .jalr_rob(j_rob),
                                         .jal_rob(jal_rob),
                                         .load_rob(load_entry_rob),
                                         .store_rob(st_rob),
                                         .branch_rob(b_rob),
                                         .ri_rob(alu_rob),
                                         .u_request(u_request),
                                         .ri_request(ri_request),
                                         .jal_request(jal_request),
                                         .jalr_request(jalr_request),
                                         .store_request(store_request),
                                         .load_request(load_request),
                                         .branch_request(branch_request),
                                         .u_data(u_data),
                                         .ri_data(ri_data),
                                         .jalr_data(jalr_data),
                                         .jal_data(jal_data),
                                         .store_data(st_data),
                                         .store_address(st_addr),
                                         .load_data(retrieved_data),
                                         .cdb_broadcast(cdb_broadcast),
                                         .broadcast_data(broadcast_data),
                                         .broadcast_address(broadcast_address),
                                         .broadcast_rob(broadcast_rob));
                         
                 
endmodule