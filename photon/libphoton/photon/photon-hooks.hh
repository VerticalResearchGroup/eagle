#pragma once
#include <vector>
#include <functional>
#include <stdint.h>

namespace photon {

template<class... Args>
struct PhotonHook {
    std::vector<std::function<void(Args...)>> callbacks;

    void operator()(Args... args) {
        for (auto& f : callbacks) {
            f(args...);
        }
    }

};

struct PhotonHooks {
    PhotonHook<size_t, uintptr_t> on_mem_access;
    // TODO: Declare hooks here
};

}
