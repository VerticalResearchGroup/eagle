# Project EAGLE
Welcome to the home of project EAGLE. This repository contains a full software
stack for the UPCYCLE architecture as well as packaged end-to-end deep learning
applications.

## For Developers
### Setting up your environment
First, you will need a linux environment (Windows users: WSL, Mac users: VM).
From there, you will need to install the following things:
1. [Anaconda Python](https://www.anaconda.com/products/individual) (Unless you
know what you're doing with python packages)
2. Suggested: Create a conda environment: `conda create -n eagle-dev python=3.6`
3. Activate dev environment: `conda activate eagle-dev`
4. Latest TensorFlow: `pip install tensorflow`
5. Latest PyTorch: `pip install torch`
6. Bazelisk: (Download binary [here](https://github.com/bazelbuild/bazelisk/releases), add to path as `bazel`)
7. Add `export EGL_STACK=/path/to/current-directory` to your `.bashrc`
8. Add `export EGL_TOOLS=$EGL_STACK/egl-tools` to your `.bashrc`

### Top Level Building
Commands from `$EGL_STACK`:
* `make full-rebuild`: Wipe and rebuild everything
* `make`: Incremental build

All outputs are stored in `$EGL_STACL`


