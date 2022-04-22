/* $Author: Rutwik Jain $ */
/* $LastChangedDate: 2022-04-22 $ */
/* $Rev: 0 $ */
`include ../defs/mem_sys_constants.v

`define L1_INDEX_LSB `L1_OFFSET_WIDTH
`define L1_INDEX_MSB `L1_OFFSET_WIDTH + `L1_INDEX_WIDTH - 1
`define L1_TAG_LSB   `L1_INDEX_MSB + 1

module l1_icache (
input clk,
input rst_n,
input enable,
input createdump,
output err,
coretol1_request.receiver req,
l1tocore_response.sender  rsp,
l1tomra_request.sender    mem_req,
mratol1_response.receiver mem_rsp
); 




 /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (c_tag_out_0),
                          .data_out             (c_data_out_0),
                          .hit                  (c_hit_0),
                          .dirty                (c_dirty_0),
                          .valid                (c_valid_0),
                          .err                  (c_err_0),
                          // Inputs
                          .enable               (c_enable_0),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (Addr[L1_ADDR_WIDTH-1:L1_TAG_LSB]),
                          .index                (Addr[]),
                          .offset               (cache_offset),
                          .data_in              (cache_data_in),
                          .comp                 (c_comp),
                          .write                (c_write_0),
                          .valid_in             (1'b1));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (c_tag_out_1),
                          .data_out             (c_data_out_1),
                          .hit                  (c_hit_1),
                          .dirty                (c_dirty_1),
                          .valid                (c_valid_1),
                          .err                  (c_err_1),
                          // Inputs
                          .enable               (c_enable_1),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (Addr[15:11]),
                          .index                (Addr[10:3]),
                          .offset               (cache_offset),
                          .data_in              (cache_data_in),
                          .comp                 (c_comp),
                          .write                (c_write_1),
                          .valid_in             (1'b1));


// m_data_out -> data_out to next level of cache
// m_stall, m_busy -> busy signal from MRA
// m_err -> Error signal from MRA/LLC
// mem_addr -> address for dirty writes to next cache level
// m_wr, m_rd -> read/write signals



assign err = m_err | c_err_0 | c_err_1; 


















endmodule
