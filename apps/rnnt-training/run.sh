#/bin/bash

set -euo pipefail

#work_dir=/export/b07/ws15dgalvez/mlperf-rnnt-librispeech
work_dir=/users/agoksoy/Desktop/Eagle/training/rnn_speech_recognition/pytorch
stage=3

mkdir -p $work_dir

install_dir=third_party/install
mkdir -p $install_dir
install_dir=$(readlink -f $install_dir)

set +u
source "$($CONDA_EXE info --base)/etc/profile.d/conda.sh"
set -u

# stage -1: install dependencies
if [[ $stage -le -1 ]]; then
    conda env create --force -v --file environment.yml

    set +u
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate mlperf-rnnt
    set -u

    # We need to convert .flac files to .wav files via sox. Not all sox installs have flac support, so we install from source.
    wget https://ftp.osuosl.org/pub/xiph/releases/flac/flac-1.3.2.tar.xz -O third_party/flac-1.3.2.tar.xz
    (cd third_party; tar xf flac-1.3.2.tar.xz; cd flac-1.3.2; ./configure --prefix=$install_dir && make && make install)

    wget https://sourceforge.net/projects/sox/files/sox/14.4.2/sox-14.4.2.tar.gz -O third_party/sox-14.4.2.tar.gz
    (cd third_party; tar zxf sox-14.4.2.tar.gz; cd sox-14.4.2; LDFLAGS="-L${install_dir}/lib" CFLAGS="-I${install_dir}/include" ./configure --prefix=$install_dir --with-flac && make && make install)

    (cd $(git rev-parse --show-toplevel)/loadgen; python setup.py install)
fi

export PATH="$install_dir/bin/:$PATH"

set +u
conda activate mlperf-rnnt
set -u
