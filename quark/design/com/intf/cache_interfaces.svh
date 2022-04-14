// L1 Cache Related Interfaces

/*   L1 to core request/response
     Used by both Prefetch core and SIMD Core for both I and D-Caches
     Prefetch requests from Prefetch core to SIMD L1 Cache receive prefetch
     response
*/
interface coretol1_request #(
  parameter DATA_WIDTH = 512,
  parameter ADDR_WIDTH = 64
) (input clk, input rst_n);

logic [ADDR_WIDTH-1:0]    addr;
logic [DATA_WIDTH-1:0]    data;
logic                     rw;
logic                     valid;
logic                     ready;

modport sender (input ready,
  output addr, data, rw, valid);

modport receiver(output ready,
  input addr, data, rw, valid);

endinterface:coretol1_request

interface l1tocore_response #(
  parameter DATA_WIDTH = 512
) (input clk, input rst_n);

logic [DATA_WIDTH-1:0]    data;
logic                     valid;

modport sender(output data, valid);
modport receiver(input data, valid);

endinterface:l1tocore_response

//prefetch response - single bitbusy signal
interface prefetch_response (input clk, input rst_n);

logic busy;

modport sender(output busy);
modport receiver(input busy);

endinterface:prefetch_response

/*   Gluon request/response
     Used by both Prefetch core and SIMD Core for both I and D-Caches
*/
interface gluontol1_request #(
  parameter DATA_WIDTH = 512,
  parameter ADDR_WIDTH = 64,
  parameter NUM_BEATS  = 2
) (input clk, input rst_n);

logic [ADDR_WIDTH-1:0]    addr[NUM_BEATS-1:0];
logic [DATA_WIDTH-1:0]    data;
logic                     rw;
logic [NUM_BEATS-1:0]     valid;
logic                     ready;

modport sender (input ready,
  output addr, data, rw, valid);

modport receiver(output ready,
  input addr, data, rw, valid);

endinterface:gluontol1_request

interface l1togluon_response #(
  parameter DATA_WIDTH = 512,
 parameter NUM_BEATS  = 2
) (input clk, input rst_n);

logic [DATA_WIDTH-1:0]    data[NUM_BEATS-1:0];
logic [NUM_BEATS-1:0]     valid;

modport sender(output data, valid);
modport receiver(input data, valid);

endinterface:l1togluon_response

/* Client to MRA interfaces
   Clients include either of the L1-Caches or the Tile Control FSM
*/
interface l1tomra_request #(
  parameter DATA_WIDTH = 512,
  parameter ADDR_WIDTH = 64
) (input clk, input rst_n);

logic [ADDR_WIDTH-1:0]    addr;
logic [DATA_WIDTH-1:0]    data;
logic                     rw;
logic                     valid;
logic                     ready;

modport sender (input ready,
  output addr, data, rw, valid);

modport receiver(output ready,
  input addr, data, rw, valid);

endinterface:l1tomra_request

interface mratol1_response #(
  parameter DATA_WIDTH = 512
) (input clk, input rst_n);

logic [DATA_WIDTH-1:0]    data;
logic                     valid;

modport sender(output data, valid);
modport receiver(input data, valid);

endinterface:mratol1_response
