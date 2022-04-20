// mem_sys_constants.v
// Contains defines such as number of ways, cache lines etc.

//Common constants
`define KB              1024
`define ADDR_WIDTH      64
`define DATA_WIDTH      512

`define L1_BLOCK_SIZE   64
`define L1_NUM_SETS     256

`define L1_INDEX_WIDTH  $clog2(`L1_NUM_SETS)
`define L1_OFFSET_WIDTH $clog2(`L1_BLOCK_SIZE)
`define L1_TAG_WIDTH    `ADDR_WIDTH - `L1_INDEX_WIDTH - `L1_OFFSET_WIDTH

`define L1_NUM_WAYS     4
`define L1_CACHE_SIZE   `L1_BLOCK_SIZE*`L1_NUM_SETS*`L1_NUM_WAYS

