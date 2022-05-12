module repeater #(
	parameter DATA_WIDTH = 64	
)(
    input [DATA_WIDTH-1:0] dataIn,
    input [DATA_WIDTH-1:0]mem_pointer,
    output [DATA_WIDTH-1:0]dataOut
);
endmodule
