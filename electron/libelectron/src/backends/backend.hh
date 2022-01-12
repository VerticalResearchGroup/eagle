#pragma once

#include <iostream>
#include <string>

#include "electron.hh"
#include "upcycle/upcycle-api.hh"


namespace electron {


class Backend {
public:
    virtual void loadlib(const std::string& filename) = 0;
    virtual void* getsym(const std::string& symname) = 0;
    virtual upcycle::WorkList make_worklist(const size_t count) = 0;
    virtual void enqueue(const upcycle::WorkList& wl) = 0;
    virtual void free_worklist(upcycle::WorkList& wl) = 0;

    virtual ~Backend() {}
};

}

