.PHONY: default
default: build-all

# First check that our environment has the necessary stuff set

define env-msg :=

The following environment variables must be defined:
  EGL_STACK (suggested: $(CURDIR))
  EGL_TOOLS (suggested: $$EGL_STACK/egl-tools)

endef

ifndef EGL_TOOLS
$(error $(env-msg))
endif

ifndef EGL_STACK
$(error $(env-msg))
endif

# Sub projects to build
UPCYCLE=upcycle

LIBELECTRON=electron/libelectron
ELECTRON_TF=electron/electron-tf
ELECTRON_TEST=electron/electron-test
ELECTRON=$(LIBELECTRON) $(ELECTRON_TF) $(ELECTRON_TEST)

LIBPHOTON=photon/libphoton
PHOTON=$(LIBPHOTON)

GROUPS=$(ELECTRON) $(PHOTON)
PROJECTS=$(UPCYCLE) $(LIBELECTRON) $(ELECTRON_TEST) $(LIBPHOTON)

.PHONY: electron-all
electron-all: $(ELECTRON)

.PHONY: photon-all
photon-all: $(PHOTON)

.PHONY: build-all $(PROJECTS)
build-all: $(PROJECTS)

CLEAN_PROJECTS := $(PROJECTS:%=clean-%)
.PHONY: clean-all $(CLEAN_PROJECTS)
clean-all: $(CLEAN_PROJECTS)


# Dependency Graph
$(LIBPHOTON): $(UPCYCLE)
$(LIBELECTRON): $(UPCYCLE) $(PHOTON)
$(ELECTRON_TF): $(LIBELECTRON)
$(ELECTRON_TEST): $(LIBELECTRON)

$(PROJECTS):
	$(MAKE) -C $@ install

$(PROJECTS:%=clean-%):
	$(MAKE) -C $(@:clean-%=%) clean

# Nuke and (hopefully) pave...
.PHONY: full-rebuild
full-rebuild:
	@echo "Wipe \$$EGL_TOOLS ($$EGL_TOOLS) and rebuild everything?"
	@read -p "[Y/n]: " yn && { [ -z "$$yn" ] || [ "$$yn" = Y ] || [ "$$yn" = y ]; }
	$(MAKE) full-rebuild-nocheck

.PHONY: full-rebuild-nocheck
full-rebuild-nocheck:
	rm -rf "$$EGL_TOOLS"
	$(MAKE) clean-all
	$(MAKE) build-all
