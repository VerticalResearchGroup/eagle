
interface axi_wr_aw_if #(
	parameter ID_WIDTH = 8,
	parameter ADDR_WIDTH = 16
) (input clk, input rst_n);

logic [ID_WIDTH-1:0]    axi_awid;
logic [ADDR_WIDTH-1:0]  axi_awaddr;
logic [7:0]             axi_awlen;
logic [2:0]             axi_awsize;
logic [1:0]             axi_awburst;
logic                   axi_awlock;
logic [3:0]             axi_awcache;
logic [2:0]             axi_awprot;
logic                   axi_awvalid;
logic                   axi_awready;

modport sender (input axi_awready,
		output axi_awid, axi_awaddr, axi_awlen, axi_awsize, axi_awburst, axi_awlock, axi_awcache, axi_awprot, axi_awvalid);

modport receiver (output axi_awready,
		input axi_awid, axi_awaddr, axi_awlen, axi_awsize, axi_awburst, axi_awlock, axi_awcache, axi_awprot, axi_awvalid);

endinterface:axi_wr_aw_if

interface axi_wr_w_if #(
	parameter DATA_WIDTH = 64,
	parameter STRB_WIDTH = 8
) (input clk, input rst_n);

logic [DATA_WIDTH-1:0]  axi_wdata;
logic [STRB_WIDTH-1:0]  axi_wstrb;
logic                   axi_wlast;
logic                   axi_wvalid;
logic                   axi_wready;

modport sender (input axi_wready,
		output axi_wdata, axi_wstrb, axi_wlast, axi_wvalid);

modport receiver (output axi_wready,
		input axi_wdata, axi_wstrb, axi_wlast, axi_wvalid);


endinterface:axi_wr_w_if

