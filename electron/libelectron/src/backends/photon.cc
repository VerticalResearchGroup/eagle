#include <dlfcn.h>
#include <string.h>

#include "backends/photon.hh"


using namespace upcycle;


namespace electron {

PhotonBackend::PhotonBackend() :
    lib_handle{nullptr},
    emu(std::make_shared<photon::PhotonEmu>()) { }

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


upcycle::WorkHandle PhotonBackend::put_worklist(const upcycle::WorkList& wl) {
    upcycle::WorkItem * wl_dev =
        (upcycle::WorkItem *)std::malloc(wl.size() * sizeof(*wl_dev));

    memcpy(wl_dev, wl.data(), wl.size() * sizeof(*wl_dev));

    return std::make_pair((void *)wl_dev, wl.size());
}


void PhotonBackend::enqueue(const WorkHandle& handle) {
    emu->enqueue(handle);
}


void PhotonBackend::free_workhandle(upcycle::WorkHandle& handle) {
    std::free(handle.first);
}

PhotonBackend::~PhotonBackend() {
    if (lib_handle) {
        dlclose(lib_handle);
    }
}

}
