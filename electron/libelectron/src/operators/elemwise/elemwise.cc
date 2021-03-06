#include "electron/op-elemwise.hh"
#include "operators/elemwise/elemwise-dev.hh"

using namespace upcycle;


namespace electron::operators {

void ElemwiseBinOp::setup(Tensor& src1, Tensor& src2, Tensor& dst) {
    const size_t num_tiles = backend->num_tiles();
    GlobalWorkList gwl(num_tiles);

    const DataType dtype = src1.get_dtype();

    assert(src2.get_dtype() == dtype);
    assert(dst.get_dtype() == dtype);

    const size_t num_elems = src1.num_elem();

    assert(src2.num_elem() == num_elems);
    assert(dst.num_elem() == num_elems);

    KernelFunc kern = pf_kern(dtype);
    KernelFunc prefetch = simd_kern(dtype);

    assert(kern != nullptr);
    assert(prefetch != nullptr);

    size_t vlen = vlen = backend->vbitwidth() / 8 / dtype_size(dtype);

    const size_t blk_size = 64; // TODO: should be sized to L1
    const size_t num_blks = (num_elems + blk_size - 1) / blk_size;

    g_args_blob = backend->malloc(sizeof(device::ElemwiseBinGArgs));
    l_argss_blob = backend->malloc(num_blks * sizeof(device::ElemwiseLArgs));

    device::ElemwiseBinGArgs * g_args = (device::ElemwiseBinGArgs *)g_args_blob;
    device::ElemwiseLArgs * l_argss = (device::ElemwiseLArgs *)l_argss_blob;

    g_args->src1 = src1.get_dev_ptr();
    g_args->src2 = src2.get_dev_ptr();
    g_args->dst = dst.get_dev_ptr();

    size_t off = 0;

    for (size_t i = 0; i < num_blks; i++) {
        l_argss[i] = device::ElemwiseLArgs {
            .off = off, .len = std::min(blk_size, num_elems - off) };

        gwl[i % num_tiles].push_back(upcycle::WorkItem {
            prefetch, kern, g_args, &l_argss[i] });

        off += blk_size;
    }

    backend->sync_device(g_args_blob);
    backend->sync_device(l_argss_blob);
    handle = backend->put_worklist(gwl);
}

void ElemwiseBinOp::exec() {
    backend->enqueue(handle);
}

}
