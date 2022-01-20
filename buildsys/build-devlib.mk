
default: $(DEV_LIB_EMU)

DEV_OBJS_EMU=$(DEV_SRCS:.cc=.emu.o)
DEV_INCLUDES_EMU+=-Isrc -I. -I$(EGL_TOOLS)/include
DEV_LIBDIRS_EMU+=-L$(EGL_TOOLS)/lib

$(DEV_OBJS_EMU): %.emu.o: %.cc $(DEV_HDRS)
	$(CXX) $(DBGOPTS) -D__EMU__ -fPIC -o $@ -c $< $(CXXOPTS) $(DEV_INCLUDES_EMU)

$(DEV_LIB_EMU): $(DEV_OBJS_EMU)
	$(CXX) $(DBGOPTS) -D__EMU__ -fPIC -shared -o $@ -lphoton $(DEV_OBJS_EMU) $(DEV_LIBDIRS_EMU)

.PHONY: clean-devlib
clean-devlib:
	rm -f $(DEV_LIB_EMU) $(DEV_OBJS_EMU)

clean: clean-devlib
