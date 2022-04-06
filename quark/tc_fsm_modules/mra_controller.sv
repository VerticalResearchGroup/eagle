module mra_controller#(
   // PARAMETERS
   parameter ADDR_WIDTH = 64,
   parameter WL_LEN_BITS = 8
)(
   // SN Controller Interface
   input       [ADDR_WIDTH-1:0] WL_addr,
   input      [WL_LEN_BITS-1:0] WL_len,
   input                        start_dispatch,

   // MRA Interface
   output      [ADDR_WIDTH-1:0] MRA_req_addr,
   output                       MRA_rw,
   output                       MRA_req_valid,
   input                        MRA_ready,

   // FIFO Interface
   input                        FIFO_rd_en
);

endmodule