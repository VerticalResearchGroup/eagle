# Project EAGLE
Welcome to the home of project EAGLE. This repository contains a full software
stack for the UPCYCLE architecture as well as packaged end-to-end deep learning
applications.

## For Developers
### Setting up your environment
First, you will need a linux environment (Windows users: WSL, Mac users: VM).
From there, you will need to install the following things:
1. [Miniconda3 Python](https://docs.conda.io/en/latest/miniconda.html) (See below for more details)
2. Suggested: Create a conda environment: `conda create -n eagle-dev python=3.6`
3. Activate dev environment: `conda activate eagle-dev`
4. Latest TensorFlow: `pip install tensorflow`
5. Latest PyTorch: `pip install torch`
6. Bazelisk: (Download binary [here](https://github.com/bazelbuild/bazelisk/releases), add to path as `bazel`)
7. Add `export EGL_STACK=/path/to/current-directory` to your `.bashrc`
8. Add `export EGL_TOOLS=$EGL_STACK/egl-tools` to your `.bashrc`
8. Add `export LD_LIBRARY_PATH=$EGL_TOOLS/lib` to your `.bashrc`

### Top Level Building
Commands from `$EGL_STACK`:
* `make full-rebuild`: Wipe and rebuild everything
* `make`: Incremental build

All outputs are stored in `$EGL_STACK`

### Installing Miniconda
Instructions for installing miniconda if you are new:
1. Download [Miniconda3-latest-Linux-x86_64.sh](https://docs.conda.io/en/latest/miniconda.html)
2. `bash Miniconda3-latest-Linux-x86_64.sh`
3. Follow the prompts, selecte defaults for the install
4. When prompted to modify your bashrc, type `yes`
5. log out and back in, or `source .bashrc`

### Developer operations
We will use several branches for development that are occasionally merged as
features are brought together. There will be a single branch for each project
(electron-tf, libelectron, libphoton, etc). Here's the general developer flow
for **upstream** changes:

1. Developer wants to contribute to project `<foo>`
2. Developer creates branch named `<foo>/<developer username>`
3. Developer commits work to this branch
4. Developer opens PR to merge `<foo>/<username>` to `<foo>`
5. PR is reviewed, tested and accepted by project owner

Project branches will be merged into `main` occasionally to maintain a single
stable branch. Here's the general **downstream** flow:

1. Project merges changes into `main`
2. Other project branches rebase on `main` to consume changes
3. User banches rebase on project branch

For all merging, we will use rebase-merge. This means that all PRs must apply
cleanly on top of the target branch they are going into. This essentially means
the source branch owner is responsible for ensuring their branch is up-to-date.

