#pragma once

#include <iostream>

#include "electron/electron.hh"
#include "electron/backend.hh"

#include "photon/photon.hh"

namespace electron {

class PhotonBackend : public Backend {
private:
    void * lib_handle;
    std::shared_ptr<photon::PhotonEmu> emu;

public:
    PhotonBackend();

    virtual void loadlib(const std::string& filename);
    virtual upcycle::KernelFunc getsym(const std::string& symname) const;
    virtual upcycle::WorkHandle put_worklist(const upcycle::WorkList& wl);
    virtual void enqueue(const upcycle::WorkHandle& handle);
    virtual void free_workhandle(upcycle::WorkHandle& handle);

    virtual void * malloc(const size_t sz) { return std::malloc(sz); }
    virtual void sync_device(void * ptr) { }
    virtual void sync_host(void * ptr) { }
    virtual void free(void * dev_ptr) { return std::free(dev_ptr); }

    virtual size_t num_cores() const { return 1; } // TODO
    virtual size_t vbitwidth() const { return 512; } // TODO

    virtual ~PhotonBackend();
};

}
