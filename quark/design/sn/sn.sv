////////////////////////////////////////////////////////////
//
// MODULE: sn
// DEPENDENCIES:
// DESCRIPTION:
// DESIGNER: Steve Landherr
// DATE: 4/20/2022
//
///////////////////////////////////////////////////////////

module sn #(
   // PARAMETERS
   parameter TILE_WIDTH = 4,
   parameter ADDR_WIDTH = 64,
   parameter WL_LEN_BITS = 32 
)(
   // GLOBAL SIGNALS
   input clk,
   input rst_n,

   // RING INTERFACE
   sn_ring_msg.receiver    ring_recv_if,
   sn_ring_msg.sender      ring_send_if,

   // TC FSM INTERFACE
   sn_tc_if.sn             tc_if);

   // The tiles are passive on the ring and just pass the signals along.
   assign ring_send_if.op   = ring_recv_if.op;
   assign ring_send_if.tile = ring_recv_if.tile;
   assign ring_send_if.addr = ring_recv_if.addr;
   assign ring_send_if.len  = ring_recv_if.len;
   assign ring_recv_if.ack  = ring_send_if.ack;
   assign ring_recv_if.done = ring_send_if.done;

endmodule
