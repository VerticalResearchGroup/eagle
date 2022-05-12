/*
DESCRIPTION
Pipelined MIPS Datapath

NOTES
	Stages:
	IF -> ID -> EXE[1...N] -> WB
TODO
*/

module datapath_r0 #(
	parameter DATA_WIDTH = 64,
	parameter VEC_DATA_WIDTH = 512,
	parameter REG_ADDR_WIDTH = 5,
	parameter NUM_FUNC = 12 //
)(
	input clk,
	input rst,
	input en_n,
	output fifo_read_stall,
	input [3*DATA_WIDTH - 32 -1:0] fifo_rd_data,
	input fifo_data_valid
);

/**********
 * Internal Signals
**********/

// IF
wire pipeline_stall;

wire [DATA_WIDTH - 1:0] instruction;
wire [DATA_WIDTH-1:0] mem_pointer;
wire [DATA_WIDTH-1:0] stride;

// IF/ID

wire [DATA_WIDTH - 1:0] IF_ID_Instruction;
wire [DATA_WIDTH - 1:0] IF_ID_mem_pointer;
wire [DATA_WIDTH - 1:0] IF_ID_stride;


//  ID
wire [NUM_FUNC-1:0] PipeRegSel;
wire INT_ALU_EN;
wire INT_MUL_EN;
wire INT_DIV_EN;
wire FP16_ALU_EN;
wire FP16_MUL_EN;
wire FP16_DIV_EN;
wire INT_FMA_EN;
wire FP16_FMA_EN;
wire INT_SIGMA_EN;
wire FP16_SIGMA_EN;
wire INT_TANH_EN;
wire FP16_TANH_EN;
wire RELU_EN;
wire LD_EN;
wire ST_EN;
wire BC_EN;
wire TR_EN_PULSE;
wire RegSrc;
wire RegDst;
wire RegWrite;
wire [1:0] MemToReg;
wire IntSigned;
wire Saturated;
wire ALUOp;
wire [REG_ADDR_WIDTH-1:0] VDST_ADDR;
wire [REG_ADDR_WIDTH-1:0] V1_addr;
wire [REG_ADDR_WIDTH-1:0] V2_addr;
wire [REG_ADDR_WIDTH-1:0] TR_ADDR;
wire [2*VEC_DATA_WIDTH-1:0] RegFileOut;


// ID/EX
wire ID_FU0_INT_ALU_EN; 
wire ID_FU0_RegWrite;
wire [1:0] ID_FU0_MemToReg; 
wire ID_FU0_IntSigned; 
wire ID_FU0_Saturated; 
wire ID_FU0_ALUOp;
wire [REG_ADDR_WIDTH-1:0] ID_FU0_V2_addr;
wire [REG_ADDR_WIDTH-1:0] ID_FU0_V1_addr;
wire [REG_ADDR_WIDTH-1:0] ID_FU0_VDST_ADDR;
wire [VEC_DATA_WIDTH-1:0] ID_FU0_V2;
wire [VEC_DATA_WIDTH-1:0] ID_FU0_V1;
wire ID_FU1_INT_MUL_EN;
wire ID_FU1_RegWrite ;
wire ID_FU1_MemToReg ;
wire ID_FU1_IntSigned ;
wire ID_FU1_Saturated;
wire [REG_ADDR_WIDTH-1:0] ID_FU1_V2_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU1_V1_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU1_VDST_ADDR;
wire [VEC_DATA_WIDTH-1:0] ID_FU1_V2 ;
wire [VEC_DATA_WIDTH-1:0] ID_FU1_V1;
wire ID_FU2_INT_ALU_EN ;
wire ID_FU2_RegWrite ;
wire ID_FU2_MemToReg ;
wire ID_FU2_IntSigned ;
wire ID_FU2_Saturated;
wire [REG_ADDR_WIDTH-1:0] ID_FU2_V2_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU2_V1_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU2_VDST_ADDR;
wire [VEC_DATA_WIDTH-1:0] ID_FU2_V2 ;
wire [VEC_DATA_WIDTH-1:0] ID_FU2_V1;
wire ID_FU3_FP16_ALU_EN ;
wire ID_FU3_RegWrite ;
wire ID_FU3_MemToReg ;
wire ID_FU3_IntSigned ;
wire ID_FU3_Saturated ;
wire ID_FU3_ALUOp;
wire [REG_ADDR_WIDTH-1:0] ID_FU3_V2_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU3_V1_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU3_VDST_ADDR;
wire [VEC_DATA_WIDTH-1:0] ID_FU3_V2 ;
wire [VEC_DATA_WIDTH-1:0] ID_FU3_V1;
wire ID_FU4_FP16_MUL_EN ;
wire ID_FU4_RegWrite ;
wire ID_FU4_MemToReg ;
wire ID_FU4_IntSigned ;
wire ID_FU4_Saturated;
wire [REG_ADDR_WIDTH-1:0] ID_FU4_V2_addr;
wire [REG_ADDR_WIDTH-1:0] ID_FU4_V1_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU4_VDST_ADDR;
wire [VEC_DATA_WIDTH-1:0] ID_FU4_V2 ;
wire [VEC_DATA_WIDTH-1:0] ID_FU4_V1;
wire ID_FU5_FP16_DIV_EN ;
wire ID_FU5_RegWrite ;
wire ID_FU5_MemToReg;
wire ID_FU5_IntSigned;
wire ID_FU5_Saturated;
wire [REG_ADDR_WIDTH-1:0] ID_FU5_V2_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU5_V1_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU5_VDST_ADDR;
wire [VEC_DATA_WIDTH-1:0] ID_FU5_V2 ;
wire [VEC_DATA_WIDTH-1:0] ID_FU5_V1;
wire ID_FU6_INT_FMA_EN ;
wire ID_FU6_RegWrite ;
wire ID_FU6_MemToReg ;
wire ID_FU6_IntSigned;
wire ID_FU6_Saturated;
wire [REG_ADDR_WIDTH-1:0] ID_FU6_V2_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU6_V1_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU6_VDST_ADDR ;
wire [VEC_DATA_WIDTH-1:0] ID_FU6_T1 ;
wire [VEC_DATA_WIDTH-1:0] ID_FU6_V2 ;
wire [VEC_DATA_WIDTH-1:0] ID_FU6_V1;
wire ID_FU7_FP16_FMA_EN ;
wire ID_FU7_RegWrite ;
wire ID_FU7_MemToReg ;
wire ID_FU7_IntSigned ;
wire ID_FU7_Saturated;
wire [REG_ADDR_WIDTH-1:0] ID_FU7_V2_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU7_V1_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU7_VDST_ADDR;
wire [VEC_DATA_WIDTH-1:0] ID_FU7_T1 ;
wire [VEC_DATA_WIDTH-1:0] ID_FU7_V2 ;
wire [VEC_DATA_WIDTH-1:0] ID_FU7_V1;
wire ID_FU8_RELU_EN ;
wire ID_FU8_RegWrite ;
wire ID_FU8_MemToReg;
wire [REG_ADDR_WIDTH-1:0] ID_FU8_V2_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU8_V1_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU8_VDST_ADDR ;
wire [VEC_DATA_WIDTH-1:0] ID_FU8_V1;
wire ID_FU9_INT_SIGMA_EN ;
wire ID_FU9_INT_TANH_EN ;
wire ID_FU9_RegWrite ;
wire ID_FU9_MemToReg;
wire [REG_ADDR_WIDTH-1:0] ID_FU9_V2_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU9_V1_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU9_VDST_ADDR ;
wire [VEC_DATA_WIDTH-1:0] ID_FU9_V1;
wire ID_FU10_FP16_SIGMA_EN ;
wire ID_FU10_FP16_TANH_EN ;
wire ID_FU10_RegWrite ;
wire ID_FU10_MemToReg;
wire [REG_ADDR_WIDTH-1:0] ID_FU10_V2_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU10_V1_addr ;
wire [REG_ADDR_WIDTH-1:0] ID_FU10_VDST_ADDR ;
wire [VEC_DATA_WIDTH-1:0] ID_FU10_V1;
wire ID_FU11_LD_EN;
wire ID_FU11_ST_EN;
wire ID_FU11_BC_EN;
wire ID_FU11_RegWrite;
wire ID_FU11_MemToReg;
wire ID_FU11_TR_EN;
wire [2:0] ID_FU11_TR_CNT;
wire [REG_ADDR_WIDTH-1:0] ID_FU11_V2_addr;
wire [REG_ADDR_WIDTH-1:0] ID_FU11_V1_addr;
wire [REG_ADDR_WIDTH-1:0] ID_FU11_VDST_ADDR;
wire [DATA_WIDTH-1:0] ID_FU11_TR_stride;
wire [DATA_WIDTH-1:0] ID_FU11_TR_LD_ADDR;
wire [DATA_WIDTH-1:0] ID_FU11_mem_pointer;
wire [VEC_DATA_WIDTH-1:0] ID_FU11_V2;


// EX

wire [VEC_DATA_WIDTH - 1:0] FU_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU0_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU1_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU2_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU3_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU4_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU5_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU6_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU7_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU8_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU9_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU10_OUT;
wire [VEC_DATA_WIDTH - 1:0] FU11_OUT;

wire ID_FU_MemToReg;

wire ID_FU_RegWrite;

// EX/WB
wire EX_WB_ST_EN;
wire EX_WB_TR_EN;
wire EX_WB_MemToReg;
wire EX_WB_RegWrite;
wire [VEC_DATA_WIDTH-1:0] EX_WB_FU_OUT;
wire [DATA_WIDTH-1:0] EX_WB_mem_pointer;
wire [REG_ADDR_WIDTH-1:0] EX_WB_VDST_ADDR;


// WB
wire [VEC_DATA_WIDTH-1:0] VEC_DIN[0:1];
wire VEC_DVALID[0:1];
wire [VEC_DATA_WIDTH-1:0] VEC_DIN_REPEATER;
wire [VEC_DATA_WIDTH - 1:0] RD_DATA;		// Data Written to Reg file
wire ST_EN_FLOP;
wire [15:0] TR_REG_BM;
wire TR_BUF_FULL;



// Forwarding Unit
wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire [VEC_DATA_WIDTH - 1:0] ForwardAOut;
wire [VEC_DATA_WIDTH - 1:0] ForwardBOut;


// MEM_STALL
wire wr_din_buf;
wire VEC_BUF_WR;
wire [VEC_DATA_WIDTH-1:0] VEC_DIN_BUF;
wire mem_stall;


/**********
 * Glue Logic 
 **********/
/**********
 * Synchronous Logic
 **********/
/**********
 * Glue Logic 
 **********/
/**********
 * Components
 **********/
 // ------- Forwarding Components ------ //
 forwardingUnit_r0 #(
	.BIT_WIDTH(REG_ADDR_WIDTH)
 ) U_FWDUNIT (
	.ID_EX_Rs(ID_FU0_V1_addr),
	.ID_EX_Rt(ID_FU0_V2_addr),
	.EX_WB_Rd(EX_WB_VDST_ADDR),
	.EX_WB_MemToReg(EX_WB_MemToReg),
	.MEM_DATA_VALID(VEC_DVALID[0]),
	.EX_WB_RegWrite(EX_WB_RegWrite),
	.ForwardA(ForwardA),
	.ForwardB(ForwardB)
 );
 
 //TODO: repeat the two forwarding muxes for all functional units
 mux #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(2)
 ) U_FWDA_FU0 (
	.dataIn({RD_DATA, ID_FU0_V1}),
	.sel(ForwardA),
	.dataOut(ForwardAOut)
 );
 
 mux #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(2)
 ) U_FWDB_FU0 (
	.dataIn({RD_DATA, ID_FU0_V2}),
	.sel(ForwardB),
	.dataOut(ForwardBOut)
 );
 
 // ----------- Hazard Detection Unit ------- //
 hazardDetectionUnit_r0 U_HDU(
 	.fifo_instr(instruction),
	//.fifo_valid(instr_valid),
	.IF_ID_Opcode(IF_ID_Instruction[7:3]),
	.IF_ID_Rs(V1_addr),
	.IF_ID_Rt(V2_addr),
	.ID_FU11_VDST(ID_FU11_VDST_ADDR),
	.ID_FU10_VDST(ID_FU10_VDST_ADDR),
	.ID_FU9_VDST(ID_FU9_VDST_ADDR),
	.ID_FU8_VDST(ID_FU8_VDST_ADDR),
	.ID_FU7_VDST(ID_FU7_VDST_ADDR),
	.ID_FU6_VDST(ID_FU6_VDST_ADDR),
	.ID_FU5_VDST(ID_FU5_VDST_ADDR),
	.ID_FU4_VDST(ID_FU4_VDST_ADDR),
	.ID_FU3_VDST(ID_FU3_VDST_ADDR),
	.ID_FU2_VDST(ID_FU2_VDST_ADDR),
	.ID_FU1_VDST(ID_FU1_VDST_ADDR),
	.ID_FU0_VDST(ID_FU0_VDST_ADDR),

	.ID_FU_RegWrite(ID_FU_RegWrite),
	//TODO: Add VDST_ADDR from intermediate pipeline stages of FUs.
	.TR_EN(ID_FU11_TR_EN),
	.TR_CNT(ID_FU11_TR_CNT),
	.TR_REG_BM(TR_REG_BM),
	.TR_BUF_FULL(TR_BUF_FULL),
	.MemStall(mem_stall),
	.STALL(pipeline_stall)
 );
 
 // --------- PIPELINE REGS ------------ //
 // IF/ID Register
 delay #(
	.BIT_WIDTH(DATA_WIDTH),
	.DEPTH(3),
	.DELAY(1)
 ) U_IF_ID_REG (
	.clk(clk),
	.rst(rst),
	//TODO: Check if hold is needed?
	.en_n(IF_ID_Hold),
	.dataIn({stride, mem_pointer, instruction}),
	.dataOut({IF_ID_stride, IF_ID_mem_pointer, IF_ID_Instruction})
 );
 
 // ID/EX Register
 // --- CONTROL PIPELINE REGS --- //

// FU0 Int Adder/Substractor
 delay #(
	.BIT_WIDTH(2),
	.DEPTH(6),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU0 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn(PipeRegSel[0] ? {INT_ALU_EN, RegWrite, MemToReg, IntSigned, Saturated, ALUOp} : 'h0),
	.dataOut({ID_FU0_INT_ALU_EN, ID_FU0_RegWrite, ID_FU0_MemToReg, ID_FU0_IntSigned, ID_FU0_Saturated, ID_FU0_ALUOp})
 );

//TODO: Split this into two regs so that different BIT_WIDTHs can be used to
//save space. CUrrently using VEC_DATA_WIDTH though only REG_ADDR_WIDTH is
//needed for REG addresses.
delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(5),
	.DELAY(1)
 ) U_ID_EX_DATA_FU0 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({V2_addr, V1_addr, VDST_ADDR, RegFileOut[2*VEC_DATA_WIDTH-1:VEC_DATA_WIDTH], RegFileOut[VEC_DATA_WIDTH-1:0]}),
	.dataOut({ID_FU0_V2_addr, ID_FU0_V1_addr, ID_FU0_VDST_ADDR,ID_FU0_V2, ID_FU0_V1})
 );

// FU1 Int Multiplier

 delay #(
	.BIT_WIDTH(2),
	.DEPTH(6),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU1 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn(PipeRegSel[1] ? {INT_MUL_EN, RegWrite, MemToReg, IntSigned, Saturated} : 'h0),
	.dataOut({ID_FU1_INT_MUL_EN, ID_FU1_RegWrite, ID_FU1_MemToReg, ID_FU1_IntSigned, ID_FU1_Saturated})
 );

delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(5),
	.DELAY(1)
 ) U_ID_EX_DATA_FU1 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({V2_addr, V1_addr, VDST_ADDR, RegFileOut[2*VEC_DATA_WIDTH-1:VEC_DATA_WIDTH], RegFileOut[VEC_DATA_WIDTH-1:0]}),
	.dataOut({ID_FU1_V2_addr, ID_FU1_V1_addr, ID_FU1_VDST_ADDR,ID_FU1_V2, ID_FU1_V1})
 );

// FU2 Int Divider
 delay #(
	.BIT_WIDTH(2),
	.DEPTH(6),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU2 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn(PipeRegSel[2] ? {INT_DIV_EN, RegWrite, MemToReg, IntSigned, Saturated} : 'h0),
	.dataOut({ID_FU2_INT_ALU_EN, ID_FU2_RegWrite, ID_FU2_MemToReg, ID_FU2_IntSigned, ID_FU2_Saturated})
 );

delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(5),
	.DELAY(1)
 ) U_ID_EX_DATA_FU2 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({V2_addr, V1_addr, VDST_ADDR, RegFileOut[2*VEC_DATA_WIDTH-1:VEC_DATA_WIDTH], RegFileOut[VEC_DATA_WIDTH-1:0]}),
	.dataOut({ID_FU2_V2_addr, ID_FU2_V1_addr, ID_FU2_VDST_ADDR,ID_FU2_V2, ID_FU2_V1})
 );

// FU3 FP16 Adder/Subtractor
 delay #(
	.BIT_WIDTH(2),
	.DEPTH(6),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU3 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn(PipeRegSel[3] ? {FP16_ALU_EN, RegWrite, MemToReg, IntSigned, Saturated, ALUOp} : 'h0),
	.dataOut({ID_FU3_FP16_ALU_EN, ID_FU3_RegWrite, ID_FU3_MemToReg, ID_FU3_IntSigned, ID_FU3_Saturated, ID_FU3_ALUOp})
 );

delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(5),
	.DELAY(1)
 ) U_ID_EX_DATA_FU3 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({V2_addr, V1_addr, VDST_ADDR, RegFileOut[2*VEC_DATA_WIDTH-1:VEC_DATA_WIDTH], RegFileOut[VEC_DATA_WIDTH-1:0]}),
	.dataOut({ID_FU3_V2_addr, ID_FU3_V1_addr, ID_FU3_VDST_ADDR,ID_FU3_V2, ID_FU3_V1})
 );

// FU4 FP16 Multiplier
delay #(
	.BIT_WIDTH(2),
	.DEPTH(6),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU4 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn(PipeRegSel[4] ? {FP16_MUL_EN, RegWrite, MemToReg, IntSigned, Saturated} : 'h0),
	.dataOut({ID_FU4_FP16_MUL_EN, ID_FU4_RegWrite, ID_FU4_MemToReg, ID_FU4_IntSigned, ID_FU4_Saturated})
 );

delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(5),
	.DELAY(1)
 ) U_ID_EX_DATA_FU4 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({V2_addr, V1_addr, VDST_ADDR, RegFileOut[2*VEC_DATA_WIDTH-1:VEC_DATA_WIDTH], RegFileOut[VEC_DATA_WIDTH-1:0]}),
	.dataOut({ID_FU4_V2_addr, ID_FU4_V1_addr, ID_FU4_VDST_ADDR,ID_FU4_V2, ID_FU4_V1})
 );

// FU5 FP16 Divider
delay #(
	.BIT_WIDTH(2),
	.DEPTH(6),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU5 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn(PipeRegSel[5] ? {FP16_DIV_EN, RegWrite, MemToReg, IntSigned, Saturated} : 'h0),
	.dataOut({ID_FU5_FP16_DIV_EN, ID_FU5_RegWrite, ID_FU5_MemToReg, ID_FU5_IntSigned, ID_FU5_Saturated})
 );

delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(5),
	.DELAY(1)
 ) U_ID_EX_DATA_FU5 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({V2_addr, V1_addr, VDST_ADDR, RegFileOut[2*VEC_DATA_WIDTH-1:VEC_DATA_WIDTH], RegFileOut[VEC_DATA_WIDTH-1:0]}),
	.dataOut({ID_FU5_V2_addr, ID_FU5_V1_addr, ID_FU5_VDST_ADDR,ID_FU5_V2, ID_FU5_V1})
 );

// FU6 Int FusedMultiplyAdd
delay #(
	.BIT_WIDTH(2),
	.DEPTH(6),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU6 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	//IntSigned here comes from "ACC" bit of instruction
	.dataIn(PipeRegSel[6] ? {INT_FMA_EN, RegWrite, MemToReg, IntSigned, Saturated} : 'h0),
	.dataOut({ID_FU6_INT_FMA_EN, ID_FU6_RegWrite, ID_FU6_MemToReg, ID_FU6_IntSigned, ID_FU6_Saturated})
 );

delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(6),
	.DELAY(1)
 ) U_ID_EX_DATA_FU6 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({V2_addr, V1_addr, VDST_ADDR, TR_RegFileOut, RegFileOut[2*VEC_DATA_WIDTH-1:VEC_DATA_WIDTH], RegFileOut[VEC_DATA_WIDTH-1:0]}),
	.dataOut({ID_FU6_V2_addr, ID_FU6_V1_addr, ID_FU6_VDST_ADDR, ID_FU6_T1, ID_FU6_V2, ID_FU6_V1})
 );


// FU7 FP16 FusedMultiplyAdd
delay #(
	.BIT_WIDTH(2),
	.DEPTH(6),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU7 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn(PipeRegSel[7] ? {FP16_FMA_EN, RegWrite, MemToReg, IntSigned, Saturated} : 'h0),
	.dataOut({ID_FU7_FP16_FMA_EN, ID_FU7_RegWrite, ID_FU7_MemToReg, ID_FU7_IntSigned, ID_FU7_Saturated})
 );

delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(6),
	.DELAY(1)
 ) U_ID_EX_DATA_FU7 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({V2_addr, V1_addr, VDST_ADDR, TR_RegFileOut, RegFileOut[2*VEC_DATA_WIDTH-1:VEC_DATA_WIDTH], RegFileOut[VEC_DATA_WIDTH-1:0]}),
	.dataOut({ID_FU7_V2_addr, ID_FU7_V1_addr, ID_FU7_VDST_ADDR, ID_FU7_T1, ID_FU7_V2, ID_FU7_V1})
 );

// FU8 ReLU unit

delay #(
	.BIT_WIDTH(2),
	.DEPTH(3),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU8 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn(PipeRegSel[8] ? {RELU_EN, RegWrite, MemToReg} : 'h0),
	.dataOut({ID_FU8_RELU_EN, ID_FU8_RegWrite, ID_FU8_MemToReg})
 );

delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(4),
	.DELAY(1)
 ) U_ID_EX_DATA_FU8 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({V2_addr, V1_addr, VDST_ADDR, RegFileOut[VEC_DATA_WIDTH-1:0]}),
	.dataOut({ID_FU8_V2_addr, ID_FU8_V1_addr, ID_FU8_VDST_ADDR, ID_FU8_V1})
 );

// FU9 Int Sigmoid/Tanh unit

delay #(
	.BIT_WIDTH(2),
	.DEPTH(3),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU9 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn(PipeRegSel[9] ? {INT_SIGMA_EN, INT_TANH_EN, RegWrite, MemToReg} : 'h0),
	.dataOut({ID_FU9_INT_SIGMA_EN, ID_FU9_INT_TANH_EN, ID_FU9_RegWrite, ID_FU9_MemToReg})
 );

delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(4),
	.DELAY(1)
 ) U_ID_EX_DATA_FU9 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({V2_addr, V1_addr, VDST_ADDR, RegFileOut[VEC_DATA_WIDTH-1:0]}),
	.dataOut({ID_FU9_V2_addr, ID_FU9_V1_addr, ID_FU9_VDST_ADDR, ID_FU9_V1})
 );

// FU10 FP16 Sigmoid/Tanh unit

 delay #(
	.BIT_WIDTH(2),
	.DEPTH(3),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU10 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn(PipeRegSel[10] ? {FP16_SIGMA_EN, FP16_TANH_EN, RegWrite, MemToReg} : 'h0),
	.dataOut({ID_FU10_FP16_SIGMA_EN, ID_FU10_FP16_TANH_EN, ID_FU10_RegWrite, ID_FU10_MemToReg})
 );

delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(4),
	.DELAY(1)
 ) U_ID_EX_DATA_FU10 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({V2_addr, V1_addr, VDST_ADDR, RegFileOut[VEC_DATA_WIDTH-1:0]}),
	.dataOut({ID_FU10_V2_addr, ID_FU10_V1_addr, ID_FU10_VDST_ADDR, ID_FU10_V1})
 );

// FU11 Load-Store Unit
delay #(
	.BIT_WIDTH(2),
	.DEPTH(5),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU11 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn(PipeRegSel[11] ? {LD_EN, ST_EN, BC_EN, RegWrite, MemToReg} : 'h0),
	.dataOut({ID_FU11_LD_EN,  ID_FU11_ST_EN, ID_FU11_BC_EN, ID_FU11_RegWrite, ID_FU11_MemToReg})
 );

 delay #(
	.BIT_WIDTH(2),
	.DEPTH(2),
	.DELAY(1)
 ) U_ID_EX_CONTROL_FU11_TR (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn({TR_EN, TR_CNT}),
	.dataOut({ID_FU11_TR_EN,  ID_FU11_TR_CNT})
 );

delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(7),
	.DELAY(1)
 ) U_ID_EX_DATA_FU11 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	
	.dataIn({V2_addr, V1_addr, VDST_ADDR, TR_stride ,TR_LD_ADDR ,IF_ID_mem_pointer, RegFileOut[2*VEC_DATA_WIDTH-1:VEC_DATA_WIDTH]}),
	.dataOut({ID_FU11_V2_addr, ID_FU11_V1_addr, ID_FU11_VDST_ADDR, ID_FU11_TR_stride, ID_FU11_TR_LD_ADDR ,ID_FU11_mem_pointer, ID_FU11_V2})
 );


 
// EX/WB Register
 delay #(
	.BIT_WIDTH(2),
	.DEPTH(4),
	.DELAY(1)
 ) U_EX_WB_REG0 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn({ID_FU11_ST_EN, ID_FU11_TR_EN, ID_FU_MemToReg, ID_FU_RegWrite}),
	.dataOut({EX_WB_ST_EN, EX_WB_TR_EN, EX_WB_MemToReg, EX_WB_RegWrite})
 );
 

 delay #(
	.BIT_WIDTH(REG_ADDR_WIDTH),
	.DEPTH(3),
	.DELAY(1)
 ) U_EX_WB_REG1 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn(ID_FU11_VDST_ADDR),
	.dataOut(EX_WB_VDST_ADDR)
 );

 delay #(
	.BIT_WIDTH(DATA_WIDTH),
	.DEPTH(3),
	.DELAY(1)
 ) U_EX_WB_REG2 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn(ID_FU11_mem_pointer),
	.dataOut(EX_WB_mem_pointer)
 );
 
 delay #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(3),
	.DELAY(1)
 ) U_EX_WB_REG3 (
	.clk(clk),
	.rst(rst),
	.en_n(1'b0),
	.dataIn(FU_OUT),
	.dataOut(EX_WB_FU_OUT)
 );

 // ----- INSTRUCTION FETCH (IF) ----- //
  

assign fifo_read_stall = ~pipeline_stall;

assign instruction = fifo_data_valid ? fifo_rd_data[31:0] : 'h0;
assign mem_pointer = fifo_data_valid ? fifo_rd_data[95:32]: 'h0;
assign stride = fifo_data_valid ? fifo_rd_data[159:96] : 'h0;


 // ----- INSTRUCTION DECODE (ID) ----- //
  controller_r0 #(
	  	.NUM_FUNC(NUM_FUNC)
	  ) U_CONTROLLER(
	//.instr_valid(instr_valid),
  	.opcode(IF_ID_Instruction[7:3]), //OPCODE
	.funcode(IF_ID_Instruction[9:8]), // ALUop
	.dt(IF_ID_Instruction[11:10]), // data type i8/u8/fp16
	.acc(IF_ID_Instruction[12]), //accumulator i32/u32
	.sat(IF_ID_Instruction[13]), //saturated/unsaturated -- ??
	
	//TODO: Figure out what control signals are needed
	
	.PipeRegSel(PipeRegSel),
	.INT_ALU_EN(INT_ALU_EN),
	.INT_MUL_EN(INT_MUL_EN),
	.INT_DIV_EN(INT_DIV_EN),
	.FP16_ALU_EN(FP16_ALU_EN),
	.FP16_MUL_EN(FP16_MUL_EN),
	.FP16_DIV_EN(FP16_DIV_EN),
	.INT_FMA_EN(INT_FMA_EN),
	.FP16_FMA_EN(FP16_FMA_EN),
	.INT_SIGMA_EN(INT_SIGMA_EN),
	.FP16_SIGMA_EN(FP16_SIGMA_EN),
	.INT_TANH_EN(INT_TANH_EN),
	.FP16_TANH_EN(FP16_TANH_EN),
	.RELU_EN(RELU_EN),
	.LD_EN(LD_EN),
	.ST_EN(ST_EN),
	.BC_EN(BC_EN),
	.TR_EN_PULSE(TR_EN_PULSE),
	.RegSrc(RegSrc),
	.RegDst(RegDst),
	.RegWrite(RegWrite),
	.MemToReg(MemToReg),
	.IntSigned(IntSigned),
	.Saturated(Saturated),
	.ALUOp(ALUOp)
 );

assign VDST_ADDR = RegDst ? IF_ID_Instruction[23:19] : IF_ID_Instruction[28:24];
assign V1_addr = RegSrc ? VDST_ADDR : IF_ID_Instruction[23:19];
assign V2_addr = IF_ID_Instruction[18:14];
assign TR_ADDR = IF_ID_Instruction[23:19];
 
registerFile #(
	.DATA_WIDTH(VEC_DATA_WIDTH),
	.RD_DEPTH(2),
	.REG_DEPTH(32),
	.REG_ADDR_WIDTH(REG_ADDR_WIDTH)
 )U_REGFILE(
	.clk(clk),
	.rst(rst),
	.wr(EX_WB_RegWrite),
	.rr({V2_addr, V1_addr}),
	.rw(EX_WB_VDST_ADDR),
	.d(RD_DATA),
	.q(RegFileOut)
 );
 
//TODO: Add TR_ADDR_CALC module with inputs as IF_ID_stride and IF_ID_mem_pointer


//  comparator_r0 #(
// 	.BIT_WIDTH(DATA_WIDTH)
//  ) U_COMPARE(
// 	.dataIn(RegFileOut),
// 	.equal(equal)
//  );
 
//   signextender_r0 #(
// 	.IN_WIDTH(16),
// 	.OUT_WIDTH(DATA_WIDTH),
// 	.DEPTH(1),
// 	.DELAY(0)
//  )U_SIGNEXTENDER(
// 	.clk(clk),
// 	.rst(rst),
// 	.en_n(en_n),
// 	.dataIn(IF_ID_Instruction[15:0]),
// 	.dataOut(SignExtOut),
// 	.isSigned(isSigned)
//  );
 
 // ----- EXECUTE (EX) ----- //

 
//TODO:
// Pick FU units from Vivado IPGEN.
// The input formats are currently not clear. 
// Connect the ForwardAOut and FOrwardBout to appropriate FU inputs.
// We assume outputs from each FU as FUx_OUT (x = [0-11])

//Only one of the below will be one. Remaining will be zero.
assign FU_OUT = FU0_OUT | 
		 FU1_OUT |
		 FU2_OUT |
		 FU3_OUT |
		 FU4_OUT |
		 FU5_OUT |
		 FU6_OUT |
		 FU7_OUT |
		 FU8_OUT |
		 FU9_OUT |
		 FU10_OUT |
		 FU11_OUT;

assign ID_FU_MemToReg = ID_FU0_MemToReg |
				 ID_FU1_MemToReg |
				 ID_FU2_MemToReg |
				 ID_FU3_MemToReg |
				 ID_FU4_MemToReg |
				 ID_FU5_MemToReg |
				 ID_FU6_MemToReg |
				 ID_FU7_MemToReg |
				 ID_FU8_MemToReg |
				 ID_FU9_MemToReg |
				 ID_FU10_MemToReg |
				 ID_FU11_MemToReg;

assign ID_FU_RegWrite = ID_FU0_RegWrite |
				 ID_FU1_RegWrite |
				 ID_FU2_RegWrite |
				 ID_FU3_RegWrite |
				 ID_FU4_RegWrite |
				 ID_FU5_RegWrite |
				 ID_FU6_RegWrite |
				 ID_FU7_RegWrite |
				 ID_FU8_RegWrite |
				 ID_FU9_RegWrite |
				 ID_FU10_RegWrite |
				 ID_FU11_RegWrite;

 
 // ----- WRITE BACK (WB) ----- //


 repeater #(
	 .BIT_WIDTH(VEC_DATA_WIDTH)
 )U_REPEATER(
	 .dataIn(VEC_DIN[0]),
	 .mem_pointer(EX_WB_mem_pointer),
	 .dataOut(VEC_DIN_REPEATER)
 );

// wr_din_buf comes from mem_rd_stall unit
c_fifo DIN_FIFO(
 	.clk(clk),
	.reset(rst),
	.push(wr_din_buf),
    	.push_data(VEC_DIN[0]),
	.pop(VEC_BUF_WR),
	.pop_data(VEC_DIN_BUF)
 );

 //VEC_DIN_BUF and VEC_BUF_WR come from mem_rd_Stall unit's "WB" stage
  mux #(
	.BIT_WIDTH(VEC_DATA_WIDTH),
	.DEPTH(2)
 )U_MEMTOREGMUX(
	.dataIn({(VEC_DIN_BUF & VEC_BUF_WR), VEC_DIN[0] , VEC_DIN_REPEATER, EX_WB_FU_OUT}),
	.sel(EX_WB_MemToReg),
	.dataOut(RD_DATA)
 );


delay #(
	.BIT_WIDTH(1),
	.DEPTH(1),
	.DELAY(1)
 ) U_ST_EN_REG (
	.clk(clk),
	.rst(rst),
	//TODO: Check if hold is needed?
	.en_n(1'b0),
	.dataIn(EX_WB_ST_EN),
	.dataOut(ST_EN_FLOP)
 );
//ST_EN_FLOP is used by MEM_WR_STALL unit


//TODO: ADD transpose unit with inputs: EX_WB_TR_EN, VEC_DIN[0:1], VEC_DVALID[0:1]
//It also houses the TR_REG_FILE which takes in TR_ADDR and gives out T1 

endmodule
