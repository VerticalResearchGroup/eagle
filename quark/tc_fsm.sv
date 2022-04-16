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
   parameter WL_LEN_BITS = 32)(

   // GLOBAL SIGNALS
   input                        clk,
   input                        rst_n,

   // MRA INTERFACE
   l1tomra_request.sender       mra_req_if,
   mratol1_response.receiver    mra_rsp_if,

   // PF_CORE INTERFACE
   tc_pf_core_if.tc             pf_if,

   // SIMD_CORE INTERFACE
   tc_simd_core_if.tc           simd_if,

   // SIGNAL NETWORK INTERFACE
   sn_tc_if.tc                  sn_if);

endmodule
