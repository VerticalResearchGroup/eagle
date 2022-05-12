
`include "../com/intf/axi_interfaces.svh"
`include "../com/intf/cache_interfaces.svh"

module top_quark (
input clk,
input rst_n,
//ingress* interfaces are related to the axi requests(wr/rd) coming into the quark
//egress* interfaces are related to the axi requests going out of quark
axi_wr_aw_if.receiver  quark_ingress_wr_cmd_if,
axi_wr_w_if.receiver   quark_ingress_wr_data_if,
axi_wr_b_if.sender     quark_ingress_wr_bresp_if,
axi_rd_ar_if.receiver  quark_ingress_rd_cmd_if,
axi_rd_r_if.sender     quark_ingress_rd_data_if,
axi_wr_aw_if.receiver  quark_egress_wr_cmd_if,
axi_wr_w_if.receiver   quark_egress_wr_data_if,
axi_wr_b_if.sender     quark_egress_wr_bresp_if,
axi_rd_ar_if.receiver  quark_egress_rd_cmd_if,
axi_rd_r_if.sender     quark_egress_rd_data_if
);

endmodule
