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


upcycle::WorkHandle PhotonBackend::put_worklist(const upcycle::GlobalWorkList& gwl, const std::vector<upcycle::WorkList>& wl) {
    //upcycle::WorkItem * wl_dev =
    //    (upcycle::WorkItem *)std::malloc(wl.size(i) * sizeof(*wl_dev));
    upcycle::GlobalWorkItem* dev_gwl = (upcycle::GlobalWorkItem *)std::malloc(gwl.size() * sizeof(upcycle::GlobalWorkItem));
    upcycle::WorkItem ** dev_wl = (upcycle::WorkItem **)std::malloc(gwl.size * sizeof(*upcycle::WorkItem));

    memcpy(dev_gwl,gwl.data(),gwl.size() * sizeof(*dev_gwl));

    for(size_t i=0; i<gwl.size() ; i++){
     dev_wl[i] = (upcycle::WorkItem *)std::malloc(2*sizeof(upcycle::WorkItem));
     dev_wl[i][0] = wl[i][0]; //Pftch thread
     dev_wl[i][1] = wl[i][1]; //Simd thread
    }


    //memcpy(wl_dev, wl.data(), wl.size() * sizeof(*wl_dev));

    return std::make_pair((void *)dev_gwl, dev_gwl.size());
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
