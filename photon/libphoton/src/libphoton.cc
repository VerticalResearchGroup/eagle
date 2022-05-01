#include "photon/photon.hh"
#include <string>
#include <map>

typedef void(*EmuKernelFunc)(upcycle::KernelArg, upcycle::KernelArg);

namespace photon {

static const char *enum_str[] = {"op_vadd_i8","op_vadds_i8","op_vadd_u8","op_vadds_u8","op_vadd_fp16",
    "op_vsub_i8","op_vsubs_i8","op_vsub_u8","op_vsubs_u8","op_vsub_fp16",
    "op_vmul_i8","op_vmuls_i8","op_vmul_u8","op_vmuls_u8","op_vmul_fp16",
    "op_vdiv_i8","op_vdivs_i8","op_vdiv_u8","op_vdivs_u8","op_vdiv_fp16",
    "op_vfma_i8_i32","op_vfmas_i8_i32","op_vfma_u8_u32","op_vfmas_u8_u32",
    "op_vrelu_i8","op_vrelu_u8","op_vrelu_fp16",
    "op_vtanh_i8","op_vtanh_u8","op_vtanh_fp16",
    "op_vsigmoid_i8","op_vsigmoid_u8","op_vsigmoid_fp16",
    "op_vld","op_vst"
    };
std::map<std::string, int> latency  {{"vadd", VADD_LATENCY}, {"vsub", VSUB_LATENCY},
{"vmul", VMUL_LATENCY}, {"vdiv", VDIV_LATENCY},
{"vfma", VFMA_LATENCY}, {"vrelu", VRELU_LATENCY},
{"vtanh", VTANH_LATENCY}, {"vsigmoid", VSIGMOID_LATENCY},
{"vld", VLD_LATENCY}, {"vst", VST_LATENCY}};

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
            for(int i=0;i<35;i++){
                std::string op_type = enum_str[i];
                for (const auto& [key, value] : latency) {
                    if (op_type.find(key) != std::string::npos){
                        std::cout << "[libphoton] inst [" << enum_str[i] <<"] count : "<<temu->inst_count[i];
                        std::cout << " Latency: "<<temu->inst_count[i]*value << std::endl;
                        break;
                    }
                }
            }
            temu = nullptr;
        }
    }
    std::cout << "[libphoton] Emulator Latency info" << std::endl;
    for (const auto& [key, value] : latency) {
        std::cout << '[' << key << "] = " << value << "; ";
    }
    std::cout << std::endl;
}

}

