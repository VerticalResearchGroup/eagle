////////////////////////////////////////////////////////////
//
// MODULE: tc_fsm
// DEPENDENCIES:
// DESCRIPTION:
// DESIGNER: Anna Iwanski
// DATE: 4/4/2022
//
///////////////////////////////////////////////////////////

module tc_fsm #(   
   // PARAMETERS
   parameter ADDR_WIDTH = 64,
   parameter DATA_WIDTH = 512,
   parameter WL_LEN_BITS = 8)(

   // MRA INTERFACE

   output      [ADDR_WIDTH-1:0] MRA_req_addr,
   output                       MRA_rw,
   output                       MRA_req_valid,
   input                        MRA_ready,
   input       [DATA_WIDTH-1:0] MRA_rsp_data,
   input                        MRA_rsp_valid,

   // PF_CORE INTERFACE

   output      [ADDR_WIDTH-1:0] PF_pointer,
   output                       PF_reset,
   input                        PF_done,

   // SIMD_CORE INTERFACE

   output      [ADDR_WIDTH-1:0] SIMD_pointer,
   input                        SIMD_done,
   output                       SIMD_reset,
   output      [ADDR_WIDTH-1:0] SIMD_g_arg_pointer,
   output      [ADDR_WIDTH-1:0] SIMD_l_arg_pointer,

   // SIGNAL NETWORK INTERFACE

   input                        SN_next_op,
   input       [ADDR_WIDTH-1:0] SN_next_addr,
   input      [WL_LEN_BITS-1:0] SN_next_len,
   output                       SN_clr_next,
   output                       SN_req_done);

endmodule
