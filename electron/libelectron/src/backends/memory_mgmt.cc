#include "memory_mgmt.hh"

namespace memory_mgmt {

FirstFitAllocator::FirstFitAllocator(size_t dev_mem_size) {

    /* Initialize structures*/
    heap_start = std::make_shared<MemBlock>();
    heap_start->size = dev_mem_size;
    heap_start->used = 0;
    heap_start->ptr = 0;

    heap_start->prev = NULL;
    heap_start->next = NULL;
}

std::pair<bool,uintptr_t> FirstFitAllocator::dev_malloc(size_t requested) {

    std::shared_ptr<MemBlock> block(nullptr);
    std::pair<bool,uintptr_t> block_stat_offset;
    block_stat_offset.first = false;
    // Get the first free block in list
    std::shared_ptr<MemBlock> free_node = heap_start;
    do {
        if (!(free_node->used) && free_node->size >= requested) {
            block = free_node;
            break;
        }
        free_node = free_node->next;
    } while (free_node != heap_start);

    if(block == NULL) {
        return block_stat_offset;
    }

    if (block->size > requested) {
        //Split the available block of memory into two blocks
        std::shared_ptr<MemBlock> new_free_block = std::make_shared<MemBlock>();
        // Insert new node into the linked list
        new_free_block->next = block->next;
        if (new_free_block->next) {
            new_free_block->next->prev = new_free_block;
        }
        new_free_block->prev = block;
        block->next = new_free_block;

        new_free_block->size = block->size - requested;
        new_free_block->used = 0;
        new_free_block->ptr = block->ptr + requested;
        block->size = requested;
    }

    block->used = 1;
    // Return the allocated pointer
    block_stat_offset.first = true;
    block_stat_offset.second = (uint64_t)block->ptr;
    return block_stat_offset;
}

void FirstFitAllocator::dev_free(void* block) {

    std::shared_ptr<MemBlock> node = heap_start;
    int found = 0;
    do {
        if (node->ptr == block) {
            found = 1;
            break;
        }
    } while ((node = node->next));
    
    //Input address pointer not found in the memory list
    assert(found != 0);

    //Set used bit to 0
    node->used = 0;

    if (node != heap_start && node->prev) {
        if (!(node->prev->used)) {
            std::shared_ptr<MemBlock> prev = node->prev;
            prev->next = node->next;
            if (prev->next) {
                prev->next->prev = prev;
            }
            prev->size += node->size;

            node = prev;
        }
    }

    if (node->next != heap_start && node->next) {
        if (!(node->next->used)) {
            std::shared_ptr<MemBlock> second = node->next;
            node->next = second->next;
            if (node->next) {
                node->next->prev = node;
            }
            node->size += second->size;
        }
    }
}

void FirstFitAllocator::print_memory() {
    printf("Memory List [\n");
    //Traverse through all memory blocks
    if (heap_start == NULL){
        printf("No memory blocks allocated\n");
        return;
    }

    std::shared_ptr<MemBlock> node = heap_start;
    do {
        printf("\tBlock %p, size %lud, %s\n", node->ptr,
              node->size, (node->used ? "[ALLOCATED]" : "[FREE]"));
    } while ((node = node->next));
    printf("]\n");
}

}
