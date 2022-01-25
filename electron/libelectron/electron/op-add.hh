#pragma once

#include "upcycle/upcycle-api.hh"
#include "electron/electron.hh"

namespace electron::operators {

class AddOp : public Operator {
private:
    upcycle::WorkHandle handle;

    void * g_args;
    void * l_argss;


public:
    AddOp(
        const std::shared_ptr<Backend>& _backend,
        Tensor& src1,
        Tensor& src2,
        Tensor& dst);

    virtual void exec();


    virtual ~AddOp() {
        backend->free_workhandle(handle);
    }
};

}
