#include "memory_mgmt.hh"
namespace Memory_mgmt{

void Memory_mgmt::init_devmem(size_t dev_mem_size) {

  /* Initialize structures*/
  device_memory = malloc(dev_mem_size);
  heap_start = (memBlock *)device_memory;
  heap_start->size = dev_mem_size-sizeof(heap_start);
  heap_start->used = 0;
  heap_start->ptr = device_memory+sizeof(struct memBlock);

  heap_start->prev = heap_start;
  heap_start->next = heap_start;
}

void *Memory_mgmt::dev_malloc(size_t req_mem) {

  struct memBlock* block = NULL;

  //Align to size of 8 bytes
  int align = 8;
  size_t requested=req_mem;
  requested = (req_mem + align - 1) & ~(align - 1);
  
  // Get the first free block in list 
  struct memBlock* free_node = heap_start;
  do {
    if(!(free_node->used) && free_node->size >= requested) {
        block=free_node;
        break;
    }
    free_node=free_node->next;
  } while(free_node != heap_start);

  assert(block!=NULL);
  /*if(!block) {
    printf("No free blocks available");
    return NULL;
  }*/

  if(block->size > (requested+sizeof(struct memBlock))) {
    //Split the available block of memory into two blocks
    struct memBlock* new_free_block = (memBlock*)(block->ptr + requested);
    // Insert new node into the linked list 
    new_free_block->next = block->next;
    new_free_block->next->prev = new_free_block;
    new_free_block->prev = block;
    block->next = new_free_block;
    
    new_free_block->size = block->size - (requested+sizeof(struct memBlock));
    new_free_block->used = 0;
    new_free_block->ptr = block->ptr + requested + sizeof(struct memBlock);
    block->size = requested;
  } 

  block->used = 1;
  // Return the allocated pointer
  return block->ptr;
}

void *Memory_mgmt::dev_free(void* block) {

  assert(block!=NULL);
  //Return error on NULL ptr
  /*if(block==NULL){
    printf("Deallocating a NULL reference\n");
    return NULL;
  }*/

  struct memBlock* node = heap_start;
  int found = 0;
  do {
    if(node->ptr == block) {
      found=1;
      break;
    }
  } while((node = node->next) != heap_start);
  
  //Input address pointer not found in the memory list
  assert(found!=0);
  /*if(found==0){
    printf("Invalid pointer reference\n");
    return NULL;
  }*/

  //Set used bit to 0
  node->used = 0;

  if(node != heap_start && !(node->prev->used)) {
    struct memBlock* prev = node->prev;
    prev->next = node->next;
    prev->next->prev = prev;
    prev->size += (node->size + sizeof(struct memBlock));
    
    node = prev;
  }

  if(node->next != heap_start && !(node->next->used)) {
    struct memBlock* second = node->next;
    node->next = second->next;
    node->next->prev = node;
    node->size += (second->size + sizeof(struct memBlock));  
  }
}

void Memory_mgmt::print_memory() {
  printf("Memory List [\n");
  //Traverse through all memory blocks
  if(heap_start==NULL){
    printf("No memory blocks allocated\n");
    return;
  }

  struct memBlock* node = heap_start;
  do {
    printf("\tBlk head %p Block %p, size %d, %s\n", node, node->ptr,
           node->size, (node->used ? "[ALLOCATED]" : "[FREE]"));
  } while((node = node->next) != heap_start);
  printf("]\n");
}

}