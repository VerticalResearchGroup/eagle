

# For installing things
rinstall = install -d $1 && install -p -m 0644 -t $1 $2
xinstall = install -d $1 && install -p -m 0755 -t $1 $2
rinstall_as = install -d $1 && install -p -m 0644 $2 $1/$3

define install-rule-impl
# destdir path/to/srcfile mode parent-target

$(4): $(1)/$(notdir $(2))
$(1)/$(notdir $(2)): $(2) | $(1)/
	install -m $(3) -t $(1) $(2)

endef

# destdir path/to/srcfileS mode parent-target
install-rule = $(eval $(foreach h,$(2),$(call install-rule-impl,$(1),$(h),$(3),$(4))))

%/:
	install -d $@

.PHONY: install

