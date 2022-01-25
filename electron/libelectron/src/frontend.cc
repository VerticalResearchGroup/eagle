#include "electron/backend.hh"
#include "backends/photon.hh"
// #include "backends/quark.hh"
#include "electron/frontend.hh"

namespace electron {
std::shared_ptr<Backend> make_backend(const std::string& name) {
    if (name == "photon") {
        return std::make_shared<PhotonBackend>();
    } else if (name == "quark") {
        assert(false); // TODO:
    }
    else {
        assert(false);
    }

    assert(false);
}
}
