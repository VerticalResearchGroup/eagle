#include <dlfcn.h>
#include <string.h>

#include "backends/photon.hh"


using namespace upcycle;


namespace electron {

PhotonBackend::PhotonBackend() :
    lib_handle{nullptr},
    emu(std::make_shared<photon::PhotonEmu>(4, 512)),  // TODO: Get # tiles from environment or caller
    allocator(std::make_shared<memory_mgmt::FirstFitAllocator>((unsigned long int) 8 * (1 << 30))),
    dev_base(mmap(NULL, (unsigned long int) 8 * (1 << 30), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, -1, 0))
{
    assert(dev_base != MAP_FAILED);
}

void PhotonBackend::loadlib(const std::string& filename) {
    assert(lib_handle == nullptr);
    lib_handle = dlopen(filename.c_str(), RTLD_NOW);

    // TODO: This shouldn't be an assert but need to add error checking
    assert(lib_handle != nullptr);
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
