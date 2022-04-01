
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

interface axi_wr_b_if #(
	parameter ID_WIDTH = 8
) (input clk, input rst_n);

logic [ID_WIDTH-1:0]    axi_bid;
logic                   axi_bresp;
logic                   axi_bvalid;
logic                   axi_bready;

modport sender (input axi_bready,
		output axi_bid, axi_bresp, axi_bvalid);

modport receiver (output axi_bready,
		input axi_bid, axi_bresp, axi_bvalid);



endinterface:axi_wr_b_if

interface axi_rd_ar_if #(
	parameter ID_WIDTH = 8,
	parameter ADDR_WIDTH = 16
) (input clk, input rst_n);

logic [ID_WIDTH-1:0]    axi_arid;
logic [ADDR_WIDTH-1:0]  axi_araddr;
logic [7:0]             axi_arlen;
logic [2:0]             axi_arsize;
logic [1:0]             axi_arburst;
logic                   axi_arlock;
logic [3:0]             axi_arcache;
logic [2:0]             axi_arprot;
logic                   axi_arvalid;
logic                   axi_arready;

modport sender (input axi_arready,
		output axi_arid, axi_araddr, axi_arlen, axi_arsize, axi_arburst, axi_arlock, axi_arcache, axi_arprot, axi_arvalid);


modport receiver (output axi_arready,
		input axi_arid, axi_araddr, axi_arlen, axi_arsize, axi_arburst, axi_arlock, axi_arcache, axi_arprot, axi_arvalid);

endinterface:axi_rd_ar_if

interface axi_rd_r_if #(
	parameter ID_WIDTH = 8,
	parameter DATA_WIDTH = 64
) (input clk, input rst_n);

logic [ID_WIDTH-1:0]    axi_rid;
logic [DATA_WIDTH-1:0]  axi_rdata;
logic [1:0]             axi_rresp;
logic                   axi_rlast;
logic                   axi_rvalid;
logic                   axi_rready;

modport sender (input axi_rready,
		output axi_rid, axi_rdata, axi_rresp, axi_rlast, axi_rvalid);

modport receiver (output axi_rready,
		input axi_rid, axi_rdata, axi_rresp, axi_rlast, axi_rvalid);


endinterface:axi_rd_r_if

