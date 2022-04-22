## L1 Cache Specifications

### I-Cache
* Blocking, 2-way set-associative cache with LRU replacement
* Data Width 64bits (8B) = Word Size in the cache
* Line Width 512bits (64B) = 8 Words per cache line
* Sends request for a 512b Cache line L2 on MISS
* Data bus width between processor <-> L1 is 64b
* Data bus width between L1 <-> MRA <-> L2/LLC
