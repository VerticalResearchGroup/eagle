
.PHONY: install-headers install
install-headers:
ifneq ($(INSTALL_HEADERS),)
ifeq ($(MODULE),)
$(error MODULE must be defined (e.g. MODULE = libfoo) to use INSTALL_HEADERS)
endif
$(call \
	install-rule, \
	$(EGL_TOOLS)/include/$(MODULE), \
	$(INSTALL_HEADERS), \
	0644, \
	install-headers \
)
endif

install: install-headers
