
default: $(APP)

OBJS=$(SRCS:.cc=.o)
INCLUDES+=-Isrc -I$(EGL_TOOLS)/include
LIBDIRS+=-L$(EGL_TOOLS)/lib

$(OBJS): %.o: %.cc $(HDRS)
	$(CXX) $(DBGOPTS) -fPIC -o $@ -c $< $(CXXOPTS) $(INCLUDES)

$(APP): $(OBJS)
	$(CXX) $(DBGOPTS) -o $@ $(OBJS) $(LINKOPTS) $(LIBDIRS)

.PHONY: clean-lib
clean-lib:
	rm -f $(APP) $(OBJS)

clean: clean-lib
