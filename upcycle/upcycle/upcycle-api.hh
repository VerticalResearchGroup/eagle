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

struct GlobalWorkItem{
    WorkItem* item;
    uint32_t  length;
}

typedef std::vector<WorkItem> WorkList;
typedef std::vector<GloablWorkItem> GlobalWorkList;

typedef std::pair<void*, size_t> WorkHandle;

}
