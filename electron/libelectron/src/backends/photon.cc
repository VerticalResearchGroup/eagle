#include <dlfcn.h>

#include "backends/photon.hh"

using namespace upcycle;


namespace electron {

PhotonBackend::PhotonBackend() : lib_handle{nullptr} {}

void PhotonBackend::loadlib(const std::string& filename) {
    assert(lib_handle == nullptr);
    lib_handle = dlopen(filename.c_str(), RTLD_NOW);

    // TODO: This shouldn't be an assert but need to add error checking
    assert(lib_handle != nullptr);
}

void* PhotonBackend::getsym(const std::string& symname) {
    void * sym = dlsym(lib_handle, symname.c_str());

    // TODO: This shouldn't be an assert but need to add error checking
    assert(sym != nullptr);

    return sym;
}

// WorkList PhotonBackend::make_worklist(const size_t count) {
//     return {
//         .count = count,
//         .items = (WorkItem*)calloc(count, sizeof(WorkItem))
//     };
// }


void PhotonBackend::enqueue(const WorkList& wl) {
    // TODO
}


// void PhotonBackend::free_worklist(WorkList& wl) {
//     free(wl.items);
// }

PhotonBackend::~PhotonBackend() {
    if (lib_handle) {
        dlclose(lib_handle);
    }
}

}
