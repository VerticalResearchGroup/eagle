
default: $(LIB)

OBJS=$(SRCS:.cc=.o)
INCLUDES+=-Isrc -I. -I$(EGL_TOOLS)/include
LIBDIRS+=-L$(EGL_TOOLS)/lib

$(OBJS): %.o: %.cc $(HDRS) $(PUBHDRS)
	$(CXX) $(DBGOPTS) -fPIC -o $@ -c $< $(CXXOPTS) $(INCLUDES)

$(LIB): $(OBJS)
	$(CXX) $(DBGOPTS) -fPIC -shared -o $@ $(OBJS) $(LIBDIRS)

.PHONY: clean-lib
clean-lib:
	rm -f $(LIB) $(OBJS)

clean: clean-lib
