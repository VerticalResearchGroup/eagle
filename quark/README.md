This is the directory structure for QUARK:

eagle/quark: root dir
eagle/quark/design : design related files(RTL)
eagle/quark/design/com: common components
eagle/quark/design/com/intf : all interface files
eagle/quark/design/com/src : common IPs like FIFOs etc
eagle/quark/design/top/ : top related RTL files
eagle/quark/design/prefetch_core :prefetch core design
eagle/quark/design/simd_core :simd_core design...and so on for other blocks
eagle/quark/verif/prefetch_core : prefetch core related verif files...and so on for other blocks
eagle/quark/verif/com : common verif components like clock and reset generation modules etc

