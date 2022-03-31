
`include "../com/intf/axi_interfaces.svh"

module top_quark (
input clk,
input rst_n,
axi_wr_aw_if.receiver quark_wr_cmd_if,
axi_wr_w_if.receiver quark_wr_data_if
);

endmodule
