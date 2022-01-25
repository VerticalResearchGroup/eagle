
APP=electron-test

SRCS=$(wildcard src/*.cc)
HDRS=$(wildcard src/*.hh)
LINKOPTS=-lphoton -lelectron

include ../../buildsys/build.mk
include ../../buildsys/build-app.mk

INSTALL_APPS=$(APP)

include ../../buildsys/install.mk
include ../../buildsys/install-hdrs.mk
include ../../buildsys/install-app.mk
