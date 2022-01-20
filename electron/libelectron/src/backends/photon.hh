#pragma once

#include <iostream>

#include "electron/electron.hh"
#include "electron/backend.hh"

namespace electron {

class PhotonBackend : public Backend {
private:
    void * lib_handle;

public:
    PhotonBackend();

    virtual void loadlib(const std::string& filename);
    virtual void* getsym(const std::string& symname);
    virtual upcycle::WorkList make_worklist(const size_t count);
    virtual void enqueue(const upcycle::WorkList& wl);
    virtual void free_worklist(upcycle::WorkList& wl);

    virtual ~PhotonBackend();
};

}
