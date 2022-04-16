module sn_controller#(
   // PARAMETERS
   parameter ADDR_WIDTH = 64,
   parameter WL_LEN_BITS = 32
)(
   // SN Interface
   input                        SN_next_op,
   input       [ADDR_WIDTH-1:0] SN_next_addr,
   input      [WL_LEN_BITS-1:0] SN_next_len,
   output                       SN_clr_next,
   output                       SN_req_done,

   // MRA Controller and WIP Controller Interface
   output start_dispatch,

   // WIP Controller Interface
   input  done_exe,   

   // MRA Controller Interface
   output      [ADDR_WIDTH-1:0] WL_addr,
   output     [WL_LEN_BITS-1:0] WL_len
);

endmodule
