## L2 Cache Specifications

* Blocking, 2-way set-associative cache with LRU replacement
* Data Width 512bits (64B) = Word Size in the cache
* Line Width 512bits (64B)
* L1 sends request for a 512b Cache line L2 on MISS
* Cache Size = 1MB (4 times the size of current L1 cache) per tile
* Line Sized Access only (512b/64B) => 1 word = 1 line i.e. LSB 6 offset bits are 0
* Efficient utilization of DRAM bandwidth and ensures throughput of the MRA bus

Parameters
ADDR_WIDTH 64
DATA_WIDTH 512
NUM_SETS 8192
TAG_WIDTH 45
INDEX_WIDTH 13
OFFSET 6
FIXED:
NUM_WAYS 2
LINE_SIZE(B) 64
CACHE_SIZE(MB) 1024
