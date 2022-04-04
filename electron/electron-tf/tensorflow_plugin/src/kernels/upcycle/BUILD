load("//tensorflow_plugin:demo_plugin.bzl", "tf_copts")

package(
    licenses = ["notice"],  # Apache 2.0
)

cc_library(
    name = "relu_op",
    srcs = ["relu_op.cc"],
    copts = tf_copts(),
    linkstatic = 1,
    visibility = ["//visibility:public"],
    deps = [
        "//tensorflow_plugin:core",
        "@com_google_absl//absl/container:inlined_vector",
    ],
    alwayslink = True,
)


cc_library(
    name = "bitcast_op",
    srcs = ["bitcast_op.cc"],
    copts = tf_copts(),
    linkstatic = 1,
    visibility = ["//visibility:public"],
    deps = [
        "//tensorflow_plugin:core",
        "@com_google_absl//absl/container:inlined_vector",
    ],
    alwayslink = True,
)


cc_library(
    name = "add_op",
    srcs = ["add_op.cc"],
    copts = tf_copts(),
    linkstatic = 1,
    visibility = ["//visibility:public"],
    deps = [
        "//tensorflow_plugin:core",
        "@com_google_absl//absl/container:inlined_vector",
    ],
    alwayslink = True,
)

cc_library(
    name = "relu_op",
    srcs = ["relu_op.cc"],
    hdrs = ["egl-tools/include/electron/common.hh", 
            "egl-tools/include/electron/backend.hh",
            "egl-tools/include/upcycle/upcycle-api.hh",
            "egl-tools/include/electron/tensor.hh",
            "egl-tools/include/electron/operator.hh",
            "egl-tools/include/electron/frontend.hh",],
    copts = tf_copts()+["-Itensorflow_plugin/src/kernels/upcycle/egl-tools/include"],
    linkstatic = 1,
    visibility = ["//visibility:public"],
    deps = [
        "//tensorflow_plugin:core",
        "@com_google_absl//absl/container:inlined_vector",
        ":eagle",
    ],
    alwayslink = True,
)



UPCYCLE_KERNELS = [
    ":relu_op",
    ":bitcast_op",
    ":add_op",
    ":relu_op",
]

cc_library(
    name = "upcycle_kernel_impl",
    srcs = ["upcycle_kernel_init.cc"],
    hdrs = [
        "upcycle_kernel_init.h",
        "//tensorflow_plugin/src/device/upcycle:cpu_device_plugin.h",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "//tensorflow_plugin:core",
    ] + UPCYCLE_KERNELS,
    alwayslink = True,
)
