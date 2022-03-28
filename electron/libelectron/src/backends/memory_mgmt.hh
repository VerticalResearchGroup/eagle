#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>
#include <memory>
#include <sys/mman.h>
#include <optional>

namespace memory_mgmt {

class FirstFitAllocator {
private:
    struct MemBlock
    {
        unsigned long int size;
        char used;
        uint64_t offset;
        std::shared_ptr<MemBlock> prev;
        std::shared_ptr<MemBlock> next;
    };

    std::shared_ptr<MemBlock> heap_start;

public:
    FirstFitAllocator(size_t sz);
    std::optional<uintptr_t> dev_malloc(size_t requested);
    void dev_free(uint64_t block);
    void print_memory();
};

}
