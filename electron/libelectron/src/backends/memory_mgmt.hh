#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>
#include <memory>
#include <sys/mman.h>

namespace memory_mgmt{

class FirstFitAllocator{
public:
struct MemBlock
{
    int size;
    char used;
    void *ptr;
    std::shared_ptr<struct MemBlock> prev;
    std::shared_ptr<struct MemBlock> next;
};

FirstFitAllocator(size_t sz);
void *dev_malloc(size_t requested);
void dev_free(void* block);
void print_memory();


void *device_memory = NULL;

std::shared_ptr<struct MemBlock> heap_start;
};

}