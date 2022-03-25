#include "photon/photon.hh"

typedef void(*EmuKernelFunc)(upcycle::KernelArg, upcycle::KernelArg);

namespace photon {

void PhotonEmu::enqueue(const upcycle::WorkHandle handle) {
    upcycle::WorkList * global_work_list = (upcycle::WorkList *)handle.first;
    size_t len = handle.second;

    //
    // TODO:
    // This is pretending we have a single core and it's dispatching items in-
    // order. We need this to emulate the ACTUAL scheduling algorithm (whatever
    // that may end up being).
    //

    for (size_t i = 0; i < len; i++) {
     for(size_t j = 0; j < 2; j++){
        auto item = work_list[i][j];
        EmuKernelFunc pf_entry = (EmuKernelFunc)item.prefetch_entry;
        EmuKernelFunc simd_entry = (EmuKernelFunc)item.simd_entry;
        pf_entry(item.g_args, item.l_args);
        simd_entry(item.g_args, item.l_args);
     }
    }
}

}

