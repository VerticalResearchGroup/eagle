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
    KernelArg l_args;
    KernelArg g_args;
};

typedef std::vector<WorkItem> WorkList;

typedef void* WorkHandle;

}
