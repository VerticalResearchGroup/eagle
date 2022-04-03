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

}
