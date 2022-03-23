#include "memory_mgmt.hh"
namespace memory_mgmt{

FirstFitAllocator::FirstFitAllocator(size_t dev_mem_size) {

    /* Initialize structures*/
    device_memory = mmap(NULL,dev_mem_size,PROT_EXEC|PROT_READ|PROT_WRITE,MAP_ANONYMOUS|MAP_SHARED,0,0);
    heap_start=std::make_shared<struct MemBlock>();
    heap_start->size = dev_mem_size;
    heap_start->used = 0;
    heap_start->ptr = device_memory;

    heap_start->prev = heap_start;
    heap_start->next = heap_start;
}

void *FirstFitAllocator::dev_malloc(size_t req_mem) {

    std::shared_ptr<struct MemBlock> block(nullptr);

    //Align to size of 8 bytes
    int align = 8;
    size_t requested=req_mem;
    requested = (req_mem + align - 1) & ~(align - 1);
    
    // Get the first free block in list
    std::shared_ptr<struct MemBlock> free_node = heap_start;
    do {
      if(!(free_node->used) && free_node->size >= requested) {
          block=free_node;
          break;
      }
      free_node=free_node->next;
    } while(free_node != heap_start);

    assert(block!=NULL);

    if(block->size > requested) {
      //Split the available block of memory into two blocks
      std::shared_ptr<struct MemBlock> new_free_block=std::make_shared<struct MemBlock>();
      // Insert new node into the linked list
      new_free_block->next = block->next;
      new_free_block->next->prev = new_free_block;
      new_free_block->prev = block;
      block->next = new_free_block;

      new_free_block->size = block->size - requested;
      new_free_block->used = 0;
      new_free_block->ptr = block->ptr + requested;
      block->size = requested;
    }

    block->used = 1;
    // Return the allocated pointer
    return block->ptr;
}

void FirstFitAllocator::dev_free(void* block) {

    assert(block!=NULL);

    std::shared_ptr<struct MemBlock> node = heap_start;
    int found = 0;
    do {
      if(node->ptr == block) {
        found=1;
        break;
      }
    } while((node = node->next) != heap_start);
    
    //Input address pointer not found in the memory list
    assert(found!=0);

    //Set used bit to 0
    node->used = 0;

    if(node != heap_start && !(node->prev->used)) {
      std::shared_ptr<struct MemBlock> prev = node->prev;
      prev->next = node->next;
      prev->next->prev = prev;
      prev->size += node->size;

      node = prev;
    }

    if(node->next != heap_start && !(node->next->used)) {
      std::shared_ptr<struct MemBlock> second = node->next;
      node->next = second->next;
      node->next->prev = node;
      node->size += second->size;
    }
}

void FirstFitAllocator::print_memory() {
  printf("Memory List [\n");
  //Traverse through all memory blocks
  if(heap_start==NULL){
    printf("No memory blocks allocated\n");
    return;
  }

  std::shared_ptr<struct MemBlock> node = heap_start;
  do {
    printf("\tBlock %p, size %d, %s\n", node->ptr,
           node->size, (node->used ? "[ALLOCATED]" : "[FREE]"));
  } while((node = node->next) != heap_start);
  printf("]\n");
}

}