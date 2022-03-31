#pragma once

#include <cassert>
#include <memory>

#include "upcycle/upcycle-api.hh"

namespace photon {

struct WorkHandle {
    upcycle::GlobalWorkList glb_wl;
};


class PhotonEmu {
private:
    size_t num_tiles;

public:
    PhotonEmu(size_t _num_tiles) : num_tiles(_num_tiles) {}

    void enqueue(const upcycle::WorkHandle handle);
    size_t get_num_tiles() const { return num_tiles; }
};

}
