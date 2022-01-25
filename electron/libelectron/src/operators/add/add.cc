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

    const size_t elem_per_thd = add_elem_per_thead(num_cores, num_elems, vlen);
    const size_t num_work_item = (num_elems - 1) / elem_per_thd + 1;

    g_args = backend->malloc(sizeof(device::AddGArgs));
    l_argss = backend->malloc(num_work_item * sizeof(device::AddLArgs));

    device::AddGArgs * dev_g_args = (device::AddGArgs*)g_args;
    device::AddLArgs * dev_l_argss = (device::AddLArgs*)l_argss;

    dev_g_args->src1 = src1.get_dev_ptr();
    dev_g_args->src2 = src2.get_dev_ptr();
    dev_g_args->dst = dst.get_dev_ptr();

    for (size_t i = 0; i < num_elems; i += elem_per_thd) {
        dev_l_argss[i].off = i;
        dev_l_argss[i].len = std::min(elem_per_thd, num_elems - i);
        wl.push_back(WorkItem {prefetch, kern, g_args, &dev_l_argss[i]});
    }

    backend->sync_device(dev_g_args);
    backend->sync_device(dev_l_argss);
    handle = backend->put_worklist(wl);
}

void AddOp::exec() {
    backend->enqueue(handle);
}

}
