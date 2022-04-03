#pragma once
#include "photon/photon-common.hh"
#include "photon/photon-hooks.hh"

namespace photon {

class PhotonEmu {
private:
    std::vector<std::shared_ptr<TileEmu>> tiles;

public:
    const size_t num_tiles;
    const size_t vbitwidth;
    const std::shared_ptr<PhotonHooks> hooks;

    PhotonEmu(size_t _num_tiles, size_t _vbitwidth) :
        num_tiles(_num_tiles),
        vbitwidth(_vbitwidth),
        hooks(std::make_shared<PhotonHooks>()),
        tiles()
    {
        for (size_t tile_id = 0; tile_id < num_tiles; tile_id++) {
            tiles.push_back(std::make_shared<TileEmu>(tile_id, hooks));
        }
    }

    void enqueue(upcycle::WorkHandle handle);

};

}
