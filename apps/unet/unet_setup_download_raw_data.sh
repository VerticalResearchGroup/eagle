#!/bin/bash

dir_t=$(pwd)

git clone https://github.com/mlperf/logging.git mlperf-logging
pip3 install -e mlperf-logging


dir=$1

# Download data
DATASET_DIR=${dir}/unet_raw_data #or change it to public directory where you want to downlaod the data, e.g. /home/user/public_dir


mkdir ${DATASET_DIR}
cd ${DATASET_DIR}
git clone https://github.com/neheller/kits19
cd kits19
pip3 install -r requirements.txt
python3 -m starter_code.get_imaging


DATASET_DIR=${dir}/unet_raw_data/kits19/data

echo "*******************"
echo "*******************"
echo "Downloaded data_set to ${DATASET_DIR}"
echo "*******************"
echo "*******************"

cd ${dir_t}