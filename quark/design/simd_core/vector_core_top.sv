module vector_core #(
	parameter VEC_DATA_WIDTH = 512,
	parameter DATA_WIDTH = 64,
	parameter VEC_INSTR_WIDTH = 32
)(
	input CLK,
	input RESET,
	input control_data,
	input control_wr,
	output core_busy,
	output VEC_DADDR[0:1],
	output VEC_RW_REQ,
	output VEC_REQ_VALID[0:1],
	input [VEC_DATA_WIDTH-1:0] VEC_DIN[0:1],
	input  VEC_DVALID[0:1],
	output [VEC_DATA_WIDTH-1:0] VEC_DOUT
);

wire [3*DATA_WIDTH - VEC_INSTR_WIDTH-1:0] fifo_rd_data;
wire fifo_read_stall;
wire fifo_read;
wire fifo_empty;
wire fifo_data_valid;

c_fifo #(
	.depth(10),
	.width(DATA_WIDTH*3 - VEC_INSTR_WIDTH)
)instr_fifo(
 	.clk(CLK),
	.reset(RESET),
	.pop(fifo_read),
    	.pop_data(fifo_rd_data),
	.push(control_wr),
	.push_data(control_data),
	.full(core_busy)
	.empty(fifo_empty)
    //.fifo_data_valid(instr_valid),
 );

fifo_read = fifo_read_stall & !fifo_empty;
fifo_data_valid = !fifo_empty;

datapath_r0 #(
	 .DATA_WIDTH(DATA_WIDTH),
	 .VEC_DATA_WIDTH(VEC_DATA_WIDTH),
 	 .REG_ADDR_WIDTH(5), //Log2(Number of registers) (fixed to 32 for now)
	 .NUM_FUNC(12) //number of functional(execution) units 
)(
	.clk(CLK),
	.rst(RESET),
	.en_n(1'b0),
	.fifo_read_stall(fifo_read_stall),
	.fifo_rd_data(fifo_rd_data),
	.fifo_data_valid(fifo_data_valid)
);

endmodule

