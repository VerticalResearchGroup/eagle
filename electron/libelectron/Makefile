
MODULE=electron
LIB=libelectron.so
PUBHDRS=$(wildcard electron/*.hh) $(wildcard electron/*/*.hh)

OPSRC_HOST=$(filter-out %-dev.cc, $(wildcard src/operators/*/*.cc))
OPSRC_DEV=$(filter %-dev.cc, $(wildcard src/operators/*/*.cc))

SRCS=$(wildcard src/*.cc) $(wildcard src/*/*.cc) $(OPSRC_HOST)
HDRS=$(wildcard src/*.hh) $(wildcard src/*/*.hh) $(wildcard src/operators/*/*.hh)

include ../../buildsys/build.mk
include ../../buildsys/build-lib.mk

INSTALL_LIBS=$(LIB)
INSTALL_HEADERS=$(PUBHDRS)

include ../../buildsys/install.mk
include ../../buildsys/install-hdrs.mk
include ../../buildsys/install-libs.mk
