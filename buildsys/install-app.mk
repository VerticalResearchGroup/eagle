
.PHONY: install-apps
install-apps:
$(call \
	install-rule, \
	$(EGL_TOOLS)/bin, \
	$(INSTALL_APPS), \
	0755, \
	install-apps \
)

install: install-apps
