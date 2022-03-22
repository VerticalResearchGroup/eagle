#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>

namespace Memory_mgmt{

class Memory_mgmt{
public:
struct memBlock
{
  int size;            
  char used;          
  void *ptr;
  struct memBlock *prev;
  struct memBlock *next;
};

void init_devmem(size_t sz);
void *dev_malloc(size_t requested);
void *dev_free(void* block);
void print_memory();


void *device_memory = NULL;

struct memBlock *heap_start;
};

}