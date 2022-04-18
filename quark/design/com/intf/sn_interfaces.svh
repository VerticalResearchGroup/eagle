// Signaling Network Related Interfaces

/*   Signaling Ring Messages
*    Used by GC FSM to send messages and by tiles to receive them
*/
interface sn_ring_msg #(
  parameter TILE_WIDTH = 4,
  parameter ADDR_WIDTH = 64,
  parameter WL_LEN_BITS = 32 
) (input clk, input rst_n);

logic                     op;
logic [TILE_WIDTH-1:0]    tile;
logic [ADDR_WIDTH-1:0]    addr;
logic [WL_LEN_BITS-1:0]   len;
logic                     ack;
logic                     done;

modport sender (input ack, done,
  output op, tile, addr, len);

modport receiver(output ack, done,
  input op, tile, addr, len);

endinterface:sn_ring_msg
