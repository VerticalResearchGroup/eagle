#pragma once

#include <iostream>
#include <stdint.h>

namespace upcycle {
struct WorkItem {
    void * entry;
    void * l_args;
    void * g_args;
};

struct WorkList {
    size_t count;
    WorkItem * items;
};
}
