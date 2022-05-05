# 1. Problem 
Speech recognition accepts raw audio samples and produces a corresponding text transcription.
This directory has two versions. First is CPU version that has been optimized to use CPU only for EAGLE. 
Second one is GPU version that has been developed by MLPerf. GPU version is optional. 
You need to follow only steps 2.a, 2.c, and 3.b for GPU version.
For CPU version, follow steps 2.b, 2.c, 2.d, and 3.a.

# 2. Directions

# 2.a (OPTIONAL) Steps to setup NVIDIA Container for GPU Version

1. Install CUDA and Docker
```
source scripts/install_cuda_docker.sh
```

2. Build the docker image for the single stage detection task
```
# Build from Dockerfile
bash scripts/docker/build.sh
```

Currently, the reference uses CUDA-11.0 (see [Dockerfile](Dockerfile#L15)).
Here you can find a table listing compatible drivers: https://docs.nvidia.com/deploy/cuda-compatibility/index.html#binary-compatibility__table-toolkit-driver

3. Start an interactive session in the NGC container to run data download/training/inference
```
bash scripts/docker/launch.sh <DATA_DIR> <CHECKPOINT_DIR> <RESULTS_DIR>
```

Within the container, the contents of this repository will be copied to the `/workspace/rnnt` directory. The `/datasets`, `/checkpoints`, `/results` directories are mounted as volumes
and mapped to the corresponding directories `<DATA_DIR>`, `<CHECKPOINT_DIR>`, `<RESULT_DIR>` on the host.

# 2.b Setting up the Conda Environment 

Open `run.sh`. Set the stage variable to "-1". Set "work_dir" to a
path backed by a disk with at least 30 GB of space. Most space is used
by loadgen logs, not the data or model. You need conda and a C/C++
compiler on your PATH. I used conda 4.8.2. This script is responsible
for downloading dependencies.

Run `run.sh`. As you complete individual stages, you can set the variable "stage" to
a higher number for restarting from a later stage.

# 2.c Download and preprocess the dataset.

Note: Downloading and preprocessing the dataset requires 500GB of free disk space and can take several hours to complete.

This repository provides scripts to download, and extract the following datasets:

* LibriSpeech [http://www.openslr.org/12](http://www.openslr.org/12)

LibriSpeech contains 1000 hours of 16kHz read English speech derived from public domain audiobooks from LibriVox project and has been carefully segmented and aligned. For more information, see the [LIBRISPEECH: AN ASR CORPUS BASED ON PUBLIC DOMAIN AUDIO BOOKS](http://www.danielpovey.com/files/2015_icassp_librispeech.pdf) paper.

For GPU version:

Inside the container, download and extract the datasets into the required format for later training and inference:
```bash
bash scripts/download_librispeech.sh
```

For CPU version, you may need pandas, librosa and tqdm packages to be installed in the conda environment

```bash
bash scripts/download_librispeech.sh
```

Once the data download is complete, the following folders should exist:

* `/datasets/LibriSpeech/`
   * `train-clean-100/`
   * `train-clean-360/`
   * `train-other-500/`
   * `dev-clean/`
   * `dev-other/`
   * `test-clean/`
   * `test-other/`

Next, convert the data into WAV files:
```
bash scripts/preprocess_librispeech.sh
```
Once the data is converted, the following additional files and folders should exist:
* `datasets/LibriSpeech/`
   * `librispeech-train-clean-100-wav.json`
   * `librispeech-train-clean-360-wav.json`
   * `librispeech-train-other-500-wav.json`
   * `librispeech-dev-clean-wav.json`
   * `librispeech-dev-other-wav.json`
   * `librispeech-test-clean-wav.json`
   * `librispeech-test-other-wav.json`
   * `train-clean-100-wav/`
   * `train-clean-360-wav/`
   * `train-other-500-wav/`
   * `dev-clean-wav/`
   * `dev-other-wav/`
   * `test-clean-wav/`
   * `test-other-wav/`

For training, the following manifest files are used for CPU version:
   * `librispeech-train-clean-100-wav.json`

For training, the following manifest files are used for GPU version (optional):
   * `librispeech-train-clean-100-wav.json`
   * `librispeech-train-clean-360-wav.json`
   * `librispeech-train-other-500-wav.json`

For evaluation, the `librispeech-dev-clean-wav.json` is used in GPU version (optional).

# 2.d Install Warp-Transducer Loss for CPU version

```
git clone https://github.com/HawkAaron/warp-transducer.git
cd warp-transducer
mkdir build; cd build
export WARP_RNNT_PATH=/path/to/warp-transducer/build
cmake ..
make
cd ../pytorch_binding
python setup.py install
cd ../build
cp libwarprnnt.dylib /path/to/anaconda3/lib
```

# 3. Steps to run benchmark.

# 3.a Steps to launch training for CPU version

Before starting to run the benchmark, you need change these two datapaths according to your directory:
1. Change line 19 of scripts/train.sh to /your/data/path/dataset/LibriSpeech
2. Change line 20 of configs/baseline_v3-1023sp.yaml to /your/data/path/dataset/LibriSpeech/dataset/sentencepieces/librispeech1023.model

Then, run the training:

```
bash scripts/train.sh
```

If you receive any moduleNotFound error, please install them into your conda environment by searching `conda install package_name` on web.

# 3.b (OPTIONAL) Steps to launch training for GPU version

Run the container using the code defined in 2.a.3
Inside the container, use the following script to start training.
Make sure the downloaded and preprocessed dataset is located at `<DATA_DIR>/LibriSpeech`, which corresponds to `/datasets/LibriSpeech` inside the container.

```
bash scripts/train_gpu.sh
```

This script tries to use 8 GPUs by default.
To run 1-gpu training, use the following command:

```
NUM_GPUS=1 GRAD_ACCUMULATION_STEPS=64 scripts/train_gpu.sh
```
