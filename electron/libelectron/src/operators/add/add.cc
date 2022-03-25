#include "electron/op-add.hh"
#include "operators/add/add-dev.hh"

using namespace upcycle;

namespace {
size_t add_elem_per_thead(
    const size_t num_cores, const size_t num_elems, const size_t vlen)
{
    assert(num_elems > 0);
    return ((num_elems / (num_cores * 2) - 1) / vlen + 1) * vlen;
}

size_t num_elems_per_tile(
    const size_t num_cores, const size_t num_elems)
    {
     assert(num_elems>0);
     return (num_elems%num_cores==0)?(num_elems/num_cores):(num_elems/(num_cores-1));
    }
}

namespace electron::operators {

AddOp::AddOp(
    const std::shared_ptr<Backend>& _backend,
    Tensor& src1,
    Tensor& src2,
    Tensor& dst) : Operator(_backend)
{
    const size_t num_cores = backend->num_cores();
    WorkList wl;
    std::vector<WorkList> wl_vector;
    GlobalWorkList gwl;

    const DataType dtype = src1.get_dtype();

    assert(src2.get_dtype() == dtype);
    assert(dst.get_dtype() == dtype);

    const size_t num_elems = src1.num_elem();

    assert(src2.num_elem() == num_elems);
    assert(dst.num_elem() == num_elems);

    KernelFunc kern = nullptr;
    KernelFunc prefetch = nullptr;
    size_t vlen = vlen = backend->vbitwidth() / 8 / dtype_size(dtype);

    switch (dtype) {
    case DT_INT8:
        kern = backend->getsym("add_i8_simd");
        prefetch = backend->getsym("add_i8_prefetch");

        break;

    default:
        assert(false);
    }

    assert(kern != nullptr);
    assert(prefetch != nullptr);

    //const size_t elem_per_thd = add_elem_per_thead(num_cores, num_elems, vlen);
    //const size_t num_work_item = (num_elems - 1) / elem_per_thd + 1;
    const size_t elem_per_thd_pftch = num_elems_per_tile(num_cores, num_elems) / 2; //One set of elems for prefetch thread and other for the simd thread
    const size_t elem_per_thd_simd = (num_elems_per_tile(num_cores, num_elems)%2)? ((num_elems_per_tile(num_cores, num_elems)/2) + 1) : (num_elems_per_tile(num_cores, num_elems)/2);
    const size_t tail_tile = num_elems % num_cores;

    if (tail_tile>0){
     const size_t elem_per_tail_thd_pftch = (num_elems%(num_cores-1)) / 2;
     const size_t elem_per_tail_thd_simd = ((num_elems%(num_cores-1))%2)? elem_per_tail_thd_pftch+1 : elem_per_tail_thd_pftch;
    }

    g_args = backend->malloc(sizeof(device::AddGArgs));
    l_argss = backend->malloc(2 * num_cores * sizeof(device::AddLArgs));

    device::AddGArgs * dev_g_args = (device::AddGArgs*)g_args;
    device::AddLArgs * dev_l_argss = (device::AddLArgs*)l_argss;

    dev_g_args->src1 = src1.get_dev_ptr();
    dev_g_args->src2 = src2.get_dev_ptr();
    dev_g_args->dst = dst.get_dev_ptr();

    for(size_t i=0; i<(tail_tile?num_cores-1:num_cores) ; i++){
      dev_l_argss[2*i].off = 2*i;
      dev_l_argss[2*i].len = elem_per_thd_pftch;
      wl.push_back(WorkItem {prefetch, kern, g_args, &dev_l_argss[2*i]});
      dev_l_argss[(2*i) + 1].off = (2*i) + 1;
      dev_l_argss[(2*i)+1].len = elem_per_thd_simd;
      wl.push_back(WorkItem {prefetch, kern, g_args, &dev_l_argss[(2*i)+1]});
      gwl.push_back(GlobalWorkItem {&wl[2*i], 2});
      wl_vector.push_back(wl);
      wl.clear();
    }

    if(tail_tile>0){
      dev_l_argss[2*(num_cores-1)].off = 2*(num_cores-1);
      dev_l_argss[2*(num_cores-1)].len = elem_per_tail_thd_pftch; 
      wl.push_back(WorkItem {prefetch, kern, g_args, &dev_l_argss[2*(num_cores-1)]});
      dev_l_argss[(2*(num_cores-1))+1].off = (2*(num_cores-1)) + 1;
      dev_l_argss[(2*(num_cores-1))+1].len = elem_per_tail_thd_pftch; 
      wl.push_back(WorkItem {prefetch, kern, g_args, &dev_l_argss[(2*(num_cores-1))+1]});
      gwl.push_back(GlobalWorkItem {&wl[2*(num_cores-1)], 2});
      wl_vector.push_back(wl);
      wl.clear();
    }

    //for (size_t i = 0; i < num_elems; i += elem_per_thd) {
    //    dev_l_argss[i].off = i;
    //    dev_l_argss[i].len = std::min(elem_per_thd, num_elems - i);
    //    wl.push_back(WorkItem {prefetch, kern, g_args, &dev_l_argss[i]});
    //}

    backend->sync_device(dev_g_args);
    backend->sync_device(dev_l_argss);
    handle = backend->put_worklist(gwl,wl_vector);
}

void AddOp::exec() {
    backend->enqueue(handle);
}

}
