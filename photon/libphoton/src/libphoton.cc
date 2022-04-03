#include "photon/photon.hh"

typedef void(*EmuKernelFunc)(upcycle::KernelArg, upcycle::KernelArg);

namespace photon {

thread_local TileEmu * temu = nullptr;

void PhotonEmu::enqueue(const upcycle::WorkHandle handle) {
    const auto& glb_wl = ((WorkHandle *)handle)->glb_wl;
    assert(glb_wl.size() == num_tiles);

    for (size_t tile_id = 0; tile_id < num_tiles; tile_id++) {
        for (const auto& wi : glb_wl.at(tile_id)) {
            temu = tiles[tile_id].get();
            EmuKernelFunc pf_entry = (EmuKernelFunc)wi.prefetch_entry;
            EmuKernelFunc simd_entry = (EmuKernelFunc)wi.simd_entry;
            pf_entry(wi.g_args, wi.l_args);
            simd_entry(wi.g_args, wi.l_args);
            temu = nullptr;
        }
    }
}

}

