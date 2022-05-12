/*
DESCRIPTION:
Hazard Detection Unit

NOTES:
TODO:
*/

module hazardDetectionUnit_r0 #(
	parameter DATA_WIDTH = 64
) (
	input [DATA_WIDTH-1:0] fifo_instr,
	input [4:0] IF_ID_Opcode,
	input [DATA_WIDTH-1:0] IF_ID_Rs,
	input [DATA_WIDTH-1:0] IF_ID_Rt,
	input [DATA_WIDTH-1:0] ID_FU_VDST,
	input [DATA_WIDTH-1:0] ID_FU10_VDST_ADDR,
	input [DATA_WIDTH-1:0] ID_FU9_VDST_ADDR,
	input [DATA_WIDTH-1:0] ID_FU8_VDST_ADDR,
	input [DATA_WIDTH-1:0] ID_FU7_VDST_ADDR,
	input [DATA_WIDTH-1:0] ID_FU6_VDST_ADDR,
	input [DATA_WIDTH-1:0] ID_FU5_VDST_ADDR,
	input [DATA_WIDTH-1:0] ID_FU4_VDST_ADDR,
	input [DATA_WIDTH-1:0] ID_FU3_VDST_ADDR,
	input [DATA_WIDTH-1:0] ID_FU2_VDST_ADDR,
	input [DATA_WIDTH-1:0] ID_FU1_VDST_ADDR,
	input [DATA_WIDTH-1:0] ID_FU0_VDST_ADDR,
	input ID_FU_RegWrite,
	input TR_EN,
	input [2:0] TR_CNT,
	input [15:0] TR_REG_BM,
	input TR_BUF_FULL,
	input MemStall,
	output STALL
);

// /**********
//  * Internal Signals
//  **********/
//  localparam j		= 6'h02;
//  localparam jal		= 6'h03;
//  localparam beq		= 6'h04;
//  localparam bne		= 6'h05;
 
//  localparam R_Type 	= 6'h00;
//  localparam fun_jr		= 6'h08;
 
// /**********
//  * Glue Logic 
//  **********/
// /**********
//  * Synchronous Logic
//  **********/
// /**********
//  * Glue Logic 
//  **********/
// /**********
//  * Components
//  **********/
// /**********
//  * Output Combinatorial Logic
//  **********/
// 	always @(IF_ID_Opcode, IF_ID_Rs, IF_ID_Rt, ID_EX_MemRead, ID_EX_Rt, equal, ID_EX_Rd, EX_MEM_Rd, ID_EX_RegWrite, EX_MEM_RegWrite) begin
// 		if((ID_EX_MemRead == 1'b1) && ((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt))) begin
// 			PCWrite <= 1'b0;
// 			ID_EX_CtrlFlush <= 1'b1;
// 			IF_ID_Flush <= 1'b0;
// 			IF_ID_Hold <= 1'b1;
// 		end else if(((IF_ID_Opcode == beq) || (IF_ID_Opcode == bne) || ((IF_ID_Opcode == R_Type) && (IF_ID_Funcode == fun_jr))) 
// 		&& (((ID_EX_Rd == IF_ID_Rs || ID_EX_Rd == IF_ID_Rt) && (ID_EX_RegWrite == 1'b1)) || ((EX_MEM_Rd == IF_ID_Rs || EX_MEM_Rd == IF_ID_Rt) && (EX_MEM_RegWrite == 1'b1)))) begin
// 			PCWrite <= 1'b0;
// 			ID_EX_CtrlFlush <= 1'b1;
// 			IF_ID_Flush <= 1'b0;
// 			IF_ID_Hold <= 1'b1;
// 		end else if((IF_ID_Opcode == j) /*|| (IF_ID_Opcode == jal)*/ || ((IF_ID_Opcode == R_Type) && (IF_ID_Funcode == fun_jr)) || (IF_ID_Opcode == beq && (equal == 1'b1)) || (IF_ID_Opcode == bne && (equal == 1'b0))) begin
// 			PCWrite <= 1'b1;
// 			ID_EX_CtrlFlush <= 1'b0;
// 			IF_ID_Flush <= 1'b1;
// 			IF_ID_Hold <= 1'b0;
// 		end else if(IF_ID_Opcode == jal) begin
// 			PCWrite <= 1'b1;
// 			ID_EX_CtrlFlush <= 1'b0;
// 			IF_ID_Flush <= 1'b1;
// 			IF_ID_Hold <= 1'b0;
// 		end else begin
// 			PCWrite <= 1'b1;
// 			ID_EX_CtrlFlush <= 1'b0;
// 			IF_ID_Flush <= 1'b0;
// 			IF_ID_Hold <= 1'b0;
// 		end
// 	end	
endmodule
