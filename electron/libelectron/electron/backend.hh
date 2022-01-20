#pragma once

#include <iostream>
#include <string>

#include "electron/electron.hh"
#include "upcycle/upcycle-api.hh"


namespace electron {


class Backend {
public:
    virtual void loadlib(const std::string& filename) = 0;
    virtual upcycle::KernelFunc getsym(const std::string& symname) const = 0;
    virtual upcycle::WorkHandle put_worklist(const upcycle::WorkList&) = 0;
    virtual void enqueue(const upcycle::WorkHandle& handle) = 0;
    virtual void free_workhandle(upcycle::WorkHandle& handle) = 0;

    virtual void * malloc(const size_t sz) = 0;
    virtual void * sync_device(void * ptr) = 0;
    virtual void * sync_host(void * ptr) = 0;
    virtual void free(void * dev_ptr) = 0;

    virtual size_t num_cores() const = 0;
    virtual size_t vbitwidth() const = 0;

    virtual ~Backend() {}
};

}

