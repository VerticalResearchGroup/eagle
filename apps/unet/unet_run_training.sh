#!/bin/bash

PREPROCESSED_DATA_DIR=${1}

if [ -d ${PREPROCESSED_DATA_DIR} ]
then
    TRAINING_DIR=training/image_segmentation/pytorch #change the path as per directory structure if you want to run the script from other directory 

    sh ${TRAINING_DIR}/run_and_time.sh 1 ${PREPROCESSED_DATA_DIR}
else
    echo "*******************"
    echo "*******************"
    echo "Dataset directory ${PREPROCESSED_DATA_DIR} does not exist"
    echo "*******************"
    echo "*******************"
fi