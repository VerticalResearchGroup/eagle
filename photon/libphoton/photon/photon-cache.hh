#pragma once

#include "stdint.h"
#include <stdlib.h>
#include <string.h>

namespace photon {

#define BLOCK_SIZE 64
#define NUM_BLOCKS 4096

struct Data {
    uint8_t data[BLOCK_SIZE] = { 0 };
};

struct Cache {

private:
    struct Data * cache;
    uint64_t * tag;
    size_t num_blocks;
    size_t block_idx;

    Cache(size_t num_blocks):
        num_blocks(num_blocks),
        block_idx(0) {
        cache = new struct Data[num_blocks];
        tag = new uint64_t[num_blocks];
    }

    ~Cache() {
        free(cache);
    }

    void fetch_block(uint8_t * addr) {
        bool hit = false;
        for (size_t i = 0; i < num_blocks; i++) {
            if ((uint64_t)addr == tag[i]) {
                memcpy(cache[i].data, addr, BLOCK_SIZE);
                hit = true;
            }
        }
        if(!hit) {
            tag[block_idx] = (uint64_t)addr;
            memcpy(cache[block_idx].data, addr, BLOCK_SIZE);
            block_idx = (block_idx + 1) % num_blocks;   
        }
    }

    uint8_t * lookup_cache(uint8_t * addr) {
        for (size_t i = 0; i < num_blocks; i++) {
            if ((uint64_t)addr == tag[i]) {
                return cache[i].data;
            }
        }

        return nullptr;
    }

public:
    Cache(const Cache&) = delete;
    Cache& operator=(const Cache&) = delete;

    static Cache& singleton() {
        thread_local static Cache buf(NUM_BLOCKS);
        return buf;
    }

    static void fetch(uint8_t * addr) {
        singleton().fetch_block(addr);
    }

    static uint8_t * read(uint8_t * addr) {
        uint8_t * cache_addr = singleton().lookup_cache(addr);
        assert(cache_addr != nullptr);
        return cache_addr;
    }
};

}