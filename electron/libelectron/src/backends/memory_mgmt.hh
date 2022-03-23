#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>
#include <memory>
#include <sys/mman.h>

namespace memory_mgmt {

class FirstFitAllocator {
private:
    struct MemBlock
    {
        unsigned long int size;
        char used;
        void *ptr;
        std::shared_ptr<MemBlock> prev;
        std::shared_ptr<MemBlock> next;
    };

    std::shared_ptr<MemBlock> heap_start;

public:
    FirstFitAllocator(size_t sz, void* device_memory);
    void *dev_malloc(size_t requested);
    void dev_free(void* block);
    void print_memory();
};

}
