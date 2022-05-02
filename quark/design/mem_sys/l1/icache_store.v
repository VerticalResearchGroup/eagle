/* $Author: Rutwik Jain $ */
/* $LastChangedDate: 2022-04-20 $ */
/* $Rev: 46 $ */
//
// Adapted for Eagle from 
// Cache module for CS/ECE 552 Project
// Written by Andy Phelps
// 4 May 2006
//
//  Modified by Derek Hower
//  30 Oct 2006
`include "../defs/mem_sys_constants.v"

module icache_store (
              input enable,
              input clk,
              input rst,
              input createdump,
              input [`L1_TAG_WIDTH-1:0] tag_in,
              input [`L1_INDEX_WIDTH-1:0] index,
              input [`L1_OFFSET_WIDTH-1:0] offset,
              input [`L1_ICACHE_DATA_WIDTH-1:0] data_in,
              input comp,
              input write,
              input valid_in,

              output [`L1_TAG_WIDTH-1:0] tag_out,
              output [`L1_ICACHE_DATA_WIDTH-1:0] data_out,
              output hit,
              output dirty,
              output valid,
              output err
              );

   parameter         cache_id = 0;  // overridden for each cache instance
   wire [4:0]        ram0_id = (cache_id<<3) + 0; // These allow each memory to create a unique dump file
   wire [4:0]        ram1_id = (cache_id<<3) + 1;
   wire [4:0]        ram2_id = (cache_id<<3) + 2;
   wire [4:0]        ram3_id = (cache_id<<3) + 3;
   wire [4:0]        ram4_id = (cache_id<<3) + 4;
   wire [4:0]        ram5_id = (cache_id<<3) + 5;
   wire [4:0]        ram6_id = (cache_id<<3) + 6;
   wire [4:0]        ram7_id = (cache_id<<3) + 7;
   wire [4:0]        ram8_id = (cache_id<<3) + 8;
   wire [4:0]        ram9_id = (cache_id<<3) + 9;

   wire [`L1_ICACHE_DATA_WIDTH-1:0] w0, w1, w2, w3, w4, w5, w6, w7;
   wire [`L1_ICACHE_DATA_WIDTH-1:0] mux_out;       
   assign            go = enable & ~rst;
   assign            match = (tag_in == tag_out);

   // all instructions are 8B wide => bits [2:0] should always be 0 
   // instruction is invalid if any of [2:0] bits are non-zero
   assign            err = |offset[2:0];

   // bits [5:3] of the address (upper bits of offset) determine which word 
   // within the line is being written to
   assign            wr_word0 = go & write & ~offset[5] & ~offset[4] & ~offset[3] & (match | ~comp);
   assign            wr_word1 = go & write & ~offset[5] & ~offset[4] &  offset[3] & (match | ~comp);
   assign            wr_word2 = go & write & ~offset[5] &  offset[4] & ~offset[3] & (match | ~comp);
   assign            wr_word3 = go & write & ~offset[5] &  offset[4] &  offset[3] & (match | ~comp);
   assign            wr_word4 = go & write &  offset[5] & ~offset[4] & ~offset[3] & (match | ~comp);
   assign            wr_word5 = go & write &  offset[5] & ~offset[4] &  offset[3] & (match | ~comp);
   assign            wr_word6 = go & write &  offset[5] &  offset[4] & ~offset[3] & (match | ~comp);
   assign            wr_word7 = go & write &  offset[5] &  offset[4] &  offset[3] & (match | ~comp);


   assign            wr_dirty = go & write & (match | ~comp);
   assign            wr_tag   = go & write & ~comp;
   assign            wr_valid = go & write & ~comp;
   assign            dirty_in = comp;  // a compare-and-write sets dirty; a cache-fill clears it

   memc #(`L1_ICACHE_DATA_WIDTH) mem_w0 (w0,  index, data_in,  wr_word0, clk, rst, createdump, ram0_id);
   memc #(`L1_ICACHE_DATA_WIDTH) mem_w1 (w1,  index, data_in,  wr_word1, clk, rst, createdump, ram1_id);
   memc #(`L1_ICACHE_DATA_WIDTH) mem_w2 (w2,  index, data_in,  wr_word2, clk, rst, createdump, ram2_id);
   memc #(`L1_ICACHE_DATA_WIDTH) mem_w3 (w3,  index, data_in,  wr_word3, clk, rst, createdump, ram3_id);
   memc #(`L1_ICACHE_DATA_WIDTH) mem_w4 (w4,  index, data_in,  wr_word4, clk, rst, createdump, ram4_id);
   memc #(`L1_ICACHE_DATA_WIDTH) mem_w5 (w5,  index, data_in,  wr_word5, clk, rst, createdump, ram5_id);
   memc #(`L1_ICACHE_DATA_WIDTH) mem_w6 (w6,  index, data_in,  wr_word6, clk, rst, createdump, ram6_id);
   memc #(`L1_ICACHE_DATA_WIDTH) mem_w7 (w7,  index, data_in,  wr_word7, clk, rst, createdump, ram7_id);

   memc #(`L1_TAG_WIDTH) mem_tg (tag_out, index, tag_in,   wr_tag,   clk, rst, createdump, ram8_id);
   memc #( 1) mem_dr (dirtybit,index, dirty_in, wr_dirty, clk, rst, createdump, ram9_id);
   memv       mem_vl (validbit,index, valid_in, wr_valid, clk, rst, createdump, ram0_id);

   assign            hit = go & match;
   assign            dirty = go & (~write | (comp & ~match)) & dirtybit;
   mux_8to1 M0(.in0(w0), 
               .in1(w1), 
               .in2(w2), 
               .in3(w3), 
               .in4(w4), 
               .in5(w5), 
               .in6(w6),
               .in7(w7), 
               .sel(offset[5:3]), 
               .out(mux_out)
   );
   assign            data_out = (write | ~go)? `L1_ICACHE_DATA_WIDTH'd0 : mux_out;
   assign            valid = go & validbit & (~write | comp);

endmodule

// DUMMY LINE FOR REV CONTROL :0:
