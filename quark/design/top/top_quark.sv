
`include "../com/intf/axi_interfaces.svh"
`include "../com/intf/cache_interfaces.svh"

module top_quark (
input clk,
input rst_n,
axi_wr_aw_if.receiver quark_wr_cmd_if,
axi_wr_w_if.receiver quark_wr_data_if,
axi_wr_b_if.sender quark_wr_bresp_if,
axi_rd_ar_if.receiver quark_rd_cmd_if,
axi_rd_r_if.sender quark_rd_data_if,
);

endmodule
