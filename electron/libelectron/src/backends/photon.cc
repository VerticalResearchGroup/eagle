#include <dlfcn.h>
#include <string.h>
#include "memory_mgmt.hh"
#include "backends/photon.hh"


using namespace upcycle;


namespace electron {
Memory_mgmt::Memory_mgmt dev_mem_obj;

PhotonBackend::PhotonBackend() :
    lib_handle{nullptr},
    emu(std::make_shared<photon::PhotonEmu>(4, 512)) { } // TODO: Get # tiles from environment or caller

void PhotonBackend::loadlib(const std::string& filename) {
    assert(lib_handle == nullptr);
    lib_handle = dlopen(filename.c_str(), RTLD_NOW);

    // TODO: This shouldn't be an assert but need to add error checking
    assert(lib_handle != nullptr);
    //Memory_mgmt::init_devmem(4000*4);
    dev_mem_obj.init_devmem(4000*4);

}

upcycle::KernelFunc PhotonBackend::getsym(const std::string& symname) const {
    void * sym = dlsym(lib_handle, symname.c_str());

    // TODO: This shouldn't be an assert but need to add error checking
    assert(sym != nullptr);

    return (upcycle::KernelFunc)sym;
}

upcycle::WorkHandle PhotonBackend::put_worklist(const upcycle::GlobalWorkList& gwl) {
    return new photon::WorkHandle { gwl };
}

void PhotonBackend::enqueue(const WorkHandle& handle) {
    emu->enqueue(handle);
}

void PhotonBackend::free_workhandle(const upcycle::WorkHandle handle) {
    delete ((photon::WorkHandle *)handle);
}

//New memory management - malloc
void* PhotonBackend::dev_malloc(const size_t sz) { 
    //return std::malloc(sz); 
    return dev_mem_obj.dev_malloc(sz);
}

//New memory management - free
void PhotonBackend::dev_free(void *dev_ptr) { 
    //free(dev_ptr);
    //dev_mem_obj.print_memory();
    dev_mem_obj.dev_free(dev_ptr);
    return; 
}

void PhotonBackend::print_memory(){
    dev_mem_obj.print_memory();
}

PhotonBackend::~PhotonBackend() {
    if (lib_handle) {
        dlclose(lib_handle);
    }
}

}
