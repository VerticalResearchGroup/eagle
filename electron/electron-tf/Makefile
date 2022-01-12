.PHONY: build whl install

default: build

WHL=my_tensorflow_plugin_package-0.0.1-cp36-cp36m-linux_x86_64.whl

build:
	echo "\n\n\n\n" | ./configure
	bazel build  -c opt //tensorflow_plugin/tools/pip_package:build_pip_package

whl: build
	bazel-bin/tensorflow_plugin/tools/pip_package/build_pip_package .

install: whl
	pip install --no-deps --force-reinstall $(WHL)

clean:
	rm -f $(WHL)
	rm -rf bazel-bin bazel-electron-tf bazel-out bazel-testlogs .tf_plugin_configure.bazelrc
