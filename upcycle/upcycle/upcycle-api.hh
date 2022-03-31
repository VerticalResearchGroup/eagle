#pragma once

#include <iostream>
#include <vector>
#include <stdint.h>

namespace upcycle {

typedef void* KernelFunc;
typedef void* KernelArg;

struct WorkItem {
    KernelFunc prefetch_entry;
    KernelFunc simd_entry;
    KernelArg g_args;
    KernelArg l_args;
};

typedef std::vector<WorkItem> TileWorkList;
typedef std::vector<TileWorkList> GlobalWorkList;
typedef void * WorkHandle;

}
