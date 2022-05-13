// mem_sys_constants.v
// Contains defines such as number of ways, cache lines etc.

//Common constants
`define KB              1024
`define ADDR_WIDTH      64
`define L2_DATA_WIDTH   512
`define L2_BLOCK_SIZE   64
`define L2_NUM_SETS     8192

`define L2_INDEX_WIDTH  $clog2(`L2_NUM_SETS)
`define L2_OFFSET_WIDTH $clog2(`L2_BLOCK_SIZE)
`define L2_TAG_WIDTH    `ADDR_WIDTH - `L2_INDEX_WIDTH - `L2_OFFSET_WIDTH

`define L2_NUM_WAYS     2
`define L2_CACHE_SIZE   `L2_BLOCK_SIZE*`L2_NUM_SETS*`L2_NUM_WAYS
