
MODULE=photon
LIB=libphoton.so
PUBHDRS=$(wildcard photon/*.hh) $(wildcard photon/*/*.hh)

SRCS=$(wildcard src/*.cc)
HDRS=$(wildcard src/*.hh)

include ../../buildsys/build.mk
include ../../buildsys/build-lib.mk

INSTALL_LIBS=$(LIB)
INSTALL_HEADERS=$(PUBHDRS)

include ../../buildsys/install.mk
include ../../buildsys/install-hdrs.mk
include ../../buildsys/install-libs.mk
