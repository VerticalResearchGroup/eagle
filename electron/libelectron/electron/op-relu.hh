#pragma once

#include "upcycle/upcycle-api.hh"
#include "electron/electron.hh"

namespace electron::operators {

class ReluOp : public Operator {
private:
    upcycle::WorkHandle handle;

    void * g_args_blob;
    void * l_argss_blob;

public:
    ReluOp(
        const std::shared_ptr<Backend>& _backend,
        Tensor& src1,
        Tensor& dst);

    virtual void exec();

    virtual ~ReluOp() {
        backend->free_workhandle(handle);
    }
};

}
