#!/bin/bash

dir_t=$(pwd)

RAW_DATASET_DIR=${1}
PREPROCESSED_DATA_DIR=${2}
if [ -d ${RAW_DATASET_DIR} ]
then
    TRAINING_DIR=training/image_segmentation/pytorch #change the path as per directory structure if you want to run the script from other directory 

    PREPROCESSED_DATA_DIR=${PREPROCESSED_DATA_DIR}/unet_preprocessed_data
    mkdir ${PREPROCESSED_DATA_DIR}

    cd ${TRAINING_DIR}  


    python3 preprocess_dataset.py --data_dir ${RAW_DATASET_DIR} --results_dir ${PREPROCESSED_DATA_DIR}


    echo "*******************"
    echo "*******************"
    echo "Preprocessed data_set to ${PREPROCESSED_DATA_DIR}"
    echo "*******************"
    echo "*******************"
else
    echo "*******************"
    echo "*******************"
    echo "Dataset directory ${RAW_DATASET_DIR} does not exist"
    echo "*******************"
    echo "*******************"
fi

cd ${dir_t}