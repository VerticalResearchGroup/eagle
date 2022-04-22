// mem_sys_constants.v
// Contains defines such as number of ways, cache lines etc.

//Common constants
// *_B suffixed defines in Bytes, all other defines are in bits  
`define KB                       1024
`define ADDR_WIDTH               64
`define L1_ICACHE_DATA_WIDTH     64
`define L1_DCACHE_DATA_WIDTH     512

`define L1_LINE_SIZE    512
`define L1_LINE_SIZE_B  `L1_LINE_SIZE/8
`define L1_BLOCK_SIZE   64
`define L1_NUM_SETS     256

`define L1_INDEX_WIDTH  $clog2(`L1_LINE_SIZE_B)
`define L1_OFFSET_WIDTH $clog2(`L1_BLOCK_SIZE)
`define L1_TAG_WIDTH    `ADDR_WIDTH - `L1_INDEX_WIDTH - `L1_OFFSET_WIDTH

`define L1_NUM_WAYS     4
`define L1_CACHE_SIZE   `L1_BLOCK_SIZE*`L1_NUM_SETS*`L1_NUM_WAYS