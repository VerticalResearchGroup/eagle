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

public:
    PhotonBackend();

    std::shared_ptr<memory_mgmt::FirstFitAllocator> allocator;
    void *device_memory = NULL;
    virtual void loadlib(const std::string& filename);
    virtual upcycle::KernelFunc getsym(const std::string& symname) const;
    virtual upcycle::WorkHandle put_worklist(const upcycle::GlobalWorkList& gwl);
    virtual void enqueue(const upcycle::WorkHandle& handle);
    virtual void free_workhandle(const upcycle::WorkHandle handle);

    virtual void * malloc(const size_t sz) { return allocator->dev_malloc(sz); }
    virtual void sync_device(void * ptr) { }
    virtual void sync_host(void * ptr) { }
    virtual void free(void * dev_ptr) { return allocator->dev_free(dev_ptr); }

    virtual size_t num_tiles() const { return emu->num_tiles; }
    virtual size_t vbitwidth() const { return emu->vbitwidth; }

    virtual ~PhotonBackend();
};

}
