
MODULE=electron
LIB=libelectron.so
PUBHDRS=$(wildcard electron/*.hh) $(wildcard electron/*/*.hh)

OPSRC_HOST=$(filter-out %-dev.cc, $(wildcard src/operators/*/*.cc))
OPSRC_DEV=$(filter %-dev.cc, $(wildcard src/operators/*/*.cc))

SRCS=$(wildcard src/*.cc) $(wildcard src/*/*.cc) $(OPSRC_HOST)
HDRS=$(wildcard src/*.hh) $(wildcard src/*/*.hh) $(wildcard src/operators/*/*.hh)

DEV_LIB_EMU=electron-ops-emu.so
DEV_SRCS=$(OPSRC_DEV)
DEV_HDRS=src/operators/kernel.hh $(wildcard src/operators/*-dev.hh)

include ../../buildsys/build.mk
include ../../buildsys/build-lib.mk
include ../../buildsys/build-devlib.mk

INSTALL_LIBS=$(LIB) $(DEV_LIB_EMU)
INSTALL_HEADERS=$(PUBHDRS)

include ../../buildsys/install.mk
include ../../buildsys/install-hdrs.mk
include ../../buildsys/install-libs.mk
