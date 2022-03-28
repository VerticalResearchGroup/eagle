#pragma once

#include <iostream>

#include "electron/electron.hh"
#include "electron/backend.hh"
#include "memory_mgmt.hh"
#include "photon/photon.hh"

namespace electron {

class PhotonBackend : public Backend {
private:
    void * lib_handle;
    std::shared_ptr<photon::PhotonEmu> emu;
    std::shared_ptr<memory_mgmt::FirstFitAllocator> allocator;
    void *dev_base = NULL;

public:
    PhotonBackend();

    virtual void loadlib(const std::string& filename);
    virtual upcycle::KernelFunc getsym(const std::string& symname) const;
    virtual upcycle::WorkHandle put_worklist(const upcycle::GlobalWorkList& gwl);
    virtual void enqueue(const upcycle::WorkHandle& handle);
    virtual void free_workhandle(const upcycle::WorkHandle handle);

    virtual void * malloc(const size_t sz) {
        std::optional<uintptr_t> offset = allocator->dev_malloc(sz);
        if (offset == std::nullopt) {
            return NULL;
        }
        return ((void *)((uintptr_t)dev_base + *offset));
    }
    virtual void sync_device(void * ptr) { }
    virtual void sync_host(void * ptr) { }
    virtual void free(void * dev_ptr) {
        allocator->print_memory();
        if (dev_ptr != NULL) {
            return allocator->dev_free(((uint64_t)((uintptr_t)dev_ptr - (uintptr_t)dev_base)));
        }
    }
    virtual size_t num_tiles() const { return emu->num_tiles; }
    virtual size_t vbitwidth() const { return emu->vbitwidth; }

    virtual ~PhotonBackend();
};

}
