

install_shlibs = $(filter %.so,$(INSTALL_LIBS))
install_staticlibs = $(filter-out %.so,$(INSTALL_LIBS))

.PHONY: install-libs
install-libs:
$(call \
	install-rule, \
	$(EGL_TOOLS)/lib, \
	$(install_shlibs), \
	0755, \
	install-libs \
)
$(call \
	install-rule, \
	$(EGL_TOOLS)/lib, \
	$(install_staticlibs), \
	0644, \
	install-libs \
)

install: install-libs
