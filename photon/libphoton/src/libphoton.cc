#include "photon/photon.hh"

typedef void(*EmuKernelFunc)(upcycle::KernelArg, upcycle::KernelArg);

namespace photon {

void PhotonEmu::enqueue(const upcycle::WorkHandle handle) {
    upcycle::WorkItem * work_list = (upcycle::WorkItem *)handle.first;
    size_t len = handle.second;

    //
    // TODO:
    // This is pretending we have a single core and it's dispatching items in-
    // order. We need this to emulate the ACTUAL scheduling algorithm (whatever
    // that may end up being).
    //

    for (size_t i = 0; i < len; i++) {
        auto item = work_list[i];
        EmuKernelFunc pf_entry = (EmuKernelFunc)item.prefetch_entry;
        EmuKernelFunc simd_entry = (EmuKernelFunc)item.simd_entry;
        pf_entry(item.g_args, item.l_args);
        simd_entry(item.g_args, item.l_args);
    }
}

}

