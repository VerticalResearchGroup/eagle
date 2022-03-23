#include <dlfcn.h>
#include <string.h>
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
    //TODO: Amount of memory to allocate?
    dev_mem_obj = new memory_mgmt::FirstFitAllocator(10*4000);

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


PhotonBackend::~PhotonBackend() {
    if (lib_handle) {
        dlclose(lib_handle);
    }
}

}
