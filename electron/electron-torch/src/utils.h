#pragma once
#include <iostream>
#include <memory>
#include <sstream>

#include "electron/electron.hh"
#include "electron/op-add.hh"

namespace torch_plugin {
    /// 
inline void sync_if_needed(c10::Device const &d)
{
    //CLContextManager::sync_if_needed(d.index());
    return;
}

dlprim::DataType todp(c10::ScalarType tp);
    
inline dlprim::DataType todp(caffe2::TypeMeta meta)
{
    return todp(meta.toScalarType());

}

inline dlprim::ExecutionContext getExecutionContext(c10::Device dev)
{
    return CLContextManager::getCommandQueue(dev.index());
}
inline dlprim::ExecutionContext getExecutionContext(torch::Tensor const &t)
{        
    return getExecutionContext(t.device());
}

// APU function definitions
torch::Tensor new_tensor_as(dlprim::Shape const &s,torch::Tensor const &as);
cl::Buffer buffer_from_tensor(torch::Tensor const &tt);
dlprim::Tensor todp(torch::Tensor const &tt);
torch::Tensor new_upcycle_tensor(torch::IntArrayRef size,c10::Device dev,c10::ScalarType type=c10::kFloat);


//electron::Tensor make_workspace(at::DataPtr &ws_ptr,size_t ws_size,c10::Device const &dev);
// TODO : see if we need workspace guard
/*class WSGuard {
public:
    WSGuard(size_t size,c10::Device const &dev)
    {
        ws = make_workspace(ws_ptr_,size,dev);
    }
    dlprim::Tensor ws;
private:
    at::DataPtr ws_ptr_;
};
*/

class ExecGuard {
public:
    ExecGuard(char const *name);
    ~ExecGuard();
private:
    char const *name_;
};
    
#define GUARD ExecGuard debug_guard(__PRETTY_FUNCTION__);
} // namespace
