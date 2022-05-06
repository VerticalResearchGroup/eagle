#!/bin/sh


# assuming that the files: ILSVRC2012_img_train.tar, ILSVRC2012_img_val.tar and imagenet_2012_validation_synset_labels.txt
# are already present in the current directory.


# creating required directories.
mkdir imagenet
cd imagenet
mkdir train
mkdir validation
cd ..
export IMAGENET_HOME=imagenet
cd $IMAGENET_HOME


# extracting training data
tar xf ILSVRC2012_img_train.tar -C $IMAGENET_HOME/train


# individually extract the train data files.
cd train
for f in *.tar; do
 d=`basename $f .tar`
 mkdir $d
 tar xf $f -C $d
done


# extracting validation data
tar xf ILSVRC2012_img_val.tar -C $IMAGENET_HOME/validation


# downloading and running the preprocessing script
wget https://raw.githubusercontent.com/tensorflow/tpu/master/tools/datasets/imagenet_to_gcs.py
python3 imagenet_to_gcs.py \
--nogcs_upload \
--raw_data_dir=$IMAGENET_HOME \
--local_scratch_dir=$IMAGENET_HOME/tf_recordss