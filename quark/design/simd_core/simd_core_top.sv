`include "../com/intf/cache_interfaces.svh"
//TODO:l1tocore_response.valid is not connected
//TODO:signals interfacing with tc_fsm should be added as interface.
module simd_core_top #(
	parameter DATA_WIDTH = 64,
	parameter ADDR_WIDTH = 64,
	parameter VEC_DATA_WIDTH = 512
	)(
	input CLK,
	input RESET,
	input wire [ADDR_WIDTH-1:0] I_ADDR,
	input wire [DATA_WIDTH-1:0] INSTR,
	coretol1_request.sender  D_ADDR,
	coretol1_request.sender RW_REQ,
	coretol1_request.sender REQ_VALID,
	l1tocore_response.receiver  D_IN,
	coretol1_request.sender  D_OUT,
	gluontol1_request.sender  VEC_DADDR[0:1],
	gluontol1_request.sender VEC_RW_REQ,
	gluontol1_request.sender VEC_REQ_VALID[0:1],
	l1togluon_response.data  VEC_DIN[0:1],
	l1togluon_response.valid  VEC_DVALID[0:1],
	gluontol1_request.sender VEC_DOUT,
	input wire [ADDR_WIDTH-1:0] BOOT_ADDRESS,
	output wire SIMD_DONE
//NOT CONFIRMED
/* 
output wire SIMD_FAIL
output wire SIMD_FAIL_REASON
input wire E_IRQ
*/
);


wire [DATA_WIDTH-1:0] control_data;
wire control_wr;
wire core_busy;

//TODO: Modify boot_address to be an input to steel core instead of
//a parameter
steel_core_top #(

    // The address of the first instruction the core will fetch
    // ---------------------------------------------------------------------------------

    //.BOOT_ADDRESS(BOOT_ADDRESS) 

    ) core (    

    // Clock and reset inputs
    // ---------------------------------------------------------------------------------

    .CLK(CLK),         // System clock (input, required, 1-bit)
    .RESET(RESET),       // System reset (input, required, 1-bit, synchronous, active high)

    // Instruction fetch interface
    // ---------------------------------------------------------------------------------
    .I_ADDR(I_ADDR),      // Instruction address (output, 32-bit)
    .INSTR(INSTR),       // Instruction itself (input, required, 32-bit)

    // Data read/write interface
    // ---------------------------------------------------------------------------------

    .D_ADDR(D_ADDR),      // Data address (output, 32-bit)    
    .DATA_IN(D_IN),     // Data read from memory (input, required, 32-bit)
    .DATA_OUT(D_OUT),    // Data to write into memory (output, 32-bit)
    .WR_REQ(RW_REQ),      // Write enable/request (output, 1-bit)
    .WR_MASK(),     // Byte-write enable mask (output, 4-bit)

    // Interrupt request interface (hardwire to zero if unused)
    // ---------------------------------------------------------------------------------

    .E_IRQ('h0),       // External interrupt request (optional, active high, 1-bit)
    .T_IRQ('h0),       // Timer interrupt request (optional, active high, 1-bit)
    .S_IRQ('h0),       // Software interrupt request (optional, active high, 1-bit)

    // Time register update interface (hardwire to zero if unused)
    // ---------------------------------------------------------------------------------

    .REAL_TIME('h0),   // Value read from a real-time counter (optional, 64-bit)
    .CONTROL_DATA(control_data),
    .CONTROL_WR(control_wr),
    .CORE_BUSY(core_busy),
    .SIMD_DONE(SIMD_DONE)
);



vector_core (
    .CLK(CLK),
    .RESET(RESET),
    .control_data(control_data),
    .control_wr(control_wr),
    .core_busy(core_busy),
    .VEC_DADDR(VEC_DADDR[2]),
    .VEC_RW_REQ(VEC_RW_REQ),
    .VEC_REQ_VALID(VEC_REQ_VALID[0:1]),
    .VEC_DIN(VEC_DIN[0:1]),
    .VEC_DVALID(VEC_DVALID[0:1]),
    .VEC_DOUT(VEC_DOUT)
);
endmodule
