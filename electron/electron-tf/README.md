# Electron TensorFlow Plugin

## Build and Run

### Linux
1. Run the following command to install the latest `tensorflow`.
```
$ pip install tensorflow
```
2. In the plug-in `sample` code folder, configure the build options:
```
$ ./configure 

Please specify the location of python. [Default is /home/test/miniconda2/envs/sycl3.6/bin/python]: 


Found possible Python library paths:
  /home/test/miniconda2/envs/sycl3.6/lib/python3.6/site-packages
Please input the desired Python library path to use.  Default is [/home/test/miniconda2/envs/sycl3.6/lib/python3.6/site-packages]

Do you wish to build TensorFlow plug-in with MPI support? [y/N]: 
No MPI support will be enabled for TensorFlow plug-in.

Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native -Wno-sign-compare]: 
```

3. Built the plug-in with
```
$ bazel build  -c opt //tensorflow_plugin/tools/pip_package:build_pip_package --verbose_failures
```
4. Then generate a python wheel and install it.
```
$ bazel-bin/tensorflow_plugin/tools/pip_package/build_pip_package .
$ pip install tensorflow_plugins-0.0.1-cp36-cp36m-linux_x86_64.whl
```
5. Now we can run the TensorFlow with plug-in device enabled.
```
$ python
>>> import tensorflow as tf
>>> tf.config.list_physical_devices()
```