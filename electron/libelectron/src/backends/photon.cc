#include <dlfcn.h>
#include <string.h>
#include "memory_mgmt.hh"
#include "backends/photon.hh"


using namespace upcycle;


namespace electron {

PhotonBackend::PhotonBackend() :
    lib_handle{nullptr},
    emu(std::make_shared<photon::PhotonEmu>(4, 512)) { } // TODO: Get # tiles from environment or caller

void PhotonBackend::loadlib(const std::string& filename) {
    assert(lib_handle == nullptr);
    lib_handle = dlopen(filename.c_str(), RTLD_NOW);

    // TODO: This shouldn't be an assert but need to add error checking
    assert(lib_handle != nullptr);
    Memory_mgmt::init_devmem(4000*4);

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

//New memory management
void* PhotonBackend::dev_malloc(const size_t sz) { 
    //return std::malloc(sz); 
    return Memory_mgmt::dev_malloc(sz);
}

void PhotonBackend::dev_free(void *dev_ptr) { 
    //free(dev_ptr);
    Memory_mgmt::print_memory();
    Memory_mgmt::dev_free(dev_ptr);
    return; 
}

void PhotonBackend::print_memory(){
    Memory_mgmt::print_memory();
}

PhotonBackend::~PhotonBackend() {
    if (lib_handle) {
        dlclose(lib_handle);
    }
}

}
