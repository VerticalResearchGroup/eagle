#pragma once

#include "upcycle/upcycle-api.hh"

namespace photon {
class PhotonEmu {
private:

public:
    PhotonEmu() {}

    void enqueue(upcycle::WorkHandle handle);
};

}
