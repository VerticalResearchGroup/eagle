module vector_core(
	input CLK,
	input RESET,
	input control_data,
	input control_wr,
	output core_busy,
	output VEC_DADDR[2],
	output VEC_RW_REQ,
	output VEC_REQ_VALID[0:1],
	input [VEC_DATA_WIDTH-1:0] VEC_DIN[0:1],
	input  VEC_DVALID[0:1],
	output [VEC_DATA_WIDTH-1:0] VEC_DOUT
);
endmodule

