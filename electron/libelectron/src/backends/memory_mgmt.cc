#include "memory_mgmt.hh"

namespace memory_mgmt {

FirstFitAllocator::FirstFitAllocator(size_t dev_mem_size) {

    /* Initialize structures*/
    heap_start = std::make_shared<MemBlock>();
    heap_start->size = dev_mem_size;
    heap_start->used = 0;
    heap_start->offset = 0;

    heap_start->prev = NULL;
    heap_start->next = NULL;
}

std::optional<uintptr_t> FirstFitAllocator::dev_malloc(size_t requested) {

    std::shared_ptr<MemBlock> block(nullptr);

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
        return std::nullopt;
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
        new_free_block->offset = block->offset + requested;
        block->size = requested;
    }

    block->used = 1;
    // Return the allocated pointer
    return block->offset;
}

void FirstFitAllocator::dev_free(uint64_t block) {

    std::shared_ptr<MemBlock> node = heap_start;
    int found = 0;
    do {
        if (node->offset == block) {
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
        printf("\tBlock %ld, size %lud, %s\n", node->offset,
              node->size, (node->used ? "[ALLOCATED]" : "[FREE]"));
    } while ((node = node->next));
    printf("]\n");
}

bool FirstFitAllocator::is_allocated(uint64_t block) {

    //printf("Verifying address %lu\n",block);
    std::shared_ptr<MemBlock> node = heap_start;
    bool found = false;
    do {
        if (block >= node->offset && block < (node->offset + node->size)) {
            found = true;
            break;
        }
    } while ((node = node->next));

    return found;
}

}
