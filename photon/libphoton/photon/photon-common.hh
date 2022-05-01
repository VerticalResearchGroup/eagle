#pragma once
#include <vector>
#include <functional>

#include <cassert>
#include <memory>

#include "upcycle/upcycle-api.hh"
#include "photon/photon-arith.hh"

namespace photon {

class PhotonEmu;
class TileEmu;

struct WorkHandle {
    upcycle::GlobalWorkList glb_wl;
};

#define VADD_LATENCY 2
#define VSUB_LATENCY 2
#define VMUL_LATENCY 3
#define VDIV_LATENCY 3
#define VFMA_LATENCY 2
#define VRELU_LATENCY 2
#define VTANH_LATENCY 3
#define VSIGMOID_LATENCY 3
#define VLD_LATENCY 1
#define VST_LATENCY 1

}
