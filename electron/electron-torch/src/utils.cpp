#include "utils.h"

namespace torch_plugin {

    electron::DataType todp(c10::ScalarType tp)
    {
        switch(tp) {
        case c10::kHalf:
            return electron::DataType::DT_FP16;
        case c10::kBFloat16:
            return electron::DataType::DT_FP16;
        case c10::kChar:
            return electron::DataType::DT_INT8;
        case c10::kByte:
            return electron::DataType::DT_UINT8;
        /*case c10::kBool:
            TORCH_CHECK(sizeof(bool)==1,"Need to make sure tensors have same size");
            return;
        */
        default:
            throw std::runtime_error(std::string("Unsupported data type:") + c10::toString(tp));
        }
    }

    electron::Buffer buffer_from_tensor(torch::Tensor const &tt)
    {
        TORCH_CHECK(tt.device().type() == c10::DeviceType::OPENCL,"OpenCL device is required for tensor");
        TORCH_CHECK(tt.numel() > 0,"Buffer is not valid for unallocated defvice");
        cl_mem p=static_cast<cl_mem>(tt.getIntrusivePtr()->storage().data());
        cl::Buffer buf(p,true);
        return buf;
    }
    
    electron::Tensor todp(torch::Tensor const &tt)
    {
        auto backend = electron::make_backend("photon");
        backend->loadlib(lib_path());
        TORCH_CHECK(tt.device().type() == c10::DeviceType::OPENCL,"OpenCL device is required for tensor");
        TORCH_CHECK(tt.is_contiguous(),"dlprim::Tensor must be contiguous");
        auto sizes = tt.sizes();
        auto offset = tt.storage_offset();
        auto dtype = tt.dtype();
        //cl::Buffer buf = buffer_from_tensor(tt);
        Tensor::Shape sp;
        if(sizes.empty())
            sp =Tensor::Shape(1); // scalar
        else
            //sp = Tensor::Shape::from_range(sizes.begin(),sizes.end());
        
        //electron::Tensor res(buf,offset,sp,todp(dtype));
        electron::Tensor res(backend, todp(dtype), sp);
        return res;
    }

    torch::Tensor new_upcycle_tensor(torch::IntArrayRef size,c10::Device dev,c10::ScalarType type)
    {
        size_t n = 1;
        for(auto const &v:size)
            n*=v;
        if(n == 0)
            return torch::Tensor();
        dlprim::DataType dt = todp(type);
        size_t mem = n*dlprim::size_of_data_type(dt);
        c10::Storage storage(c10::Storage::use_byte_size_t(),mem,CLContextManager::allocate(dev,mem));

        c10::DispatchKeySet ks = c10::DispatchKeySet{c10::DispatchKey::OpenCL, c10::DispatchKey::AutogradOpenCL};
        
        c10::intrusive_ptr<c10::TensorImpl> impl=c10::make_intrusive<c10::TensorImpl>(
            std::move(storage),
            ks,
            caffe2::TypeMeta::fromScalarType(type));

        impl->set_sizes_contiguous(size);


        return torch::Tensor::wrap_tensor_impl(impl);

    }

    torch::Tensor new_tensor_as(dlprim::Shape const &s,torch::Tensor const &as)
    {
        int64_t shape[electron::max_tensor_dim];
        for(int i=0;i<s.size();i++)
            shape[i]=s[i];
        torch::Tensor result = new_upcycle_tensor(c10::IntArrayRef(shape,s.size()),
                                              as.device(),
                                              as.dtype().toScalarType());
        return result;
    }
    
    static at::DataPtr allocate(c10::Device const &dev,size_t n)
    {
        std::unique_ptr<CLMemAllocation> ptr=alloc(dev.index(),n);
        //cl_mem buffer = ptr->buffer();
        return at::DataPtr(buffer,ptr.release(),&CLContextManager::free_ptr,dev);
    }

    electron::Tensor make_workspace(at::DataPtr &ws_ptr,size_t ws_size,c10::Device const &dev)
    {
        dlprim::Tensor ws;
        if(ws_size) {
            ws_ptr = std::move(CLContextManager::allocate(dev,ws_size));
            ws=dlprim::Tensor(cl::Buffer((cl_mem)ws_ptr.get(),true),0,dlprim::Shape(ws_size),dlprim::uint8_data);
        }
        return ws;
    }


} // namespace
