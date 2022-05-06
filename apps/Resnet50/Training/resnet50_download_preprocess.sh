#!/bin/sh


# creating required directories.
mkdir imagenet
cd imagenet
mkdir train
mkdir validation
cd ..
export IMAGENET_HOME=imagenet


# download and extract the train data
cd $IMAGENET_HOME \
nohup wget http://image-net.org/challenges/LSVRC/2012/dd31405981ef5f776aa17412e1f0c112/ILSVRC2012_img_train.tar
tar xf ILSVRC2012_img_train.tar -C $IMAGENET_HOME/train


# individually extract the train data files.
cd train
for f in *.tar; do
 d=`basename $f .tar`
 mkdir $d
 tar xf $f -C $d
done


# download and extract the validation data
#wget http://www.image-net.org/challenges/LSVRC/2012/dd31405981ef5f776aa17412e1f0c112/ILSVRC2012_img_train_t3.tar
wget http://www.image-net.org/challenges/LSVRC/2012/dd31405981ef5f776aa17412e1f0c112/ILSVRC2012_img_val.tar
tar xf ILSVRC2012_img_val.tar -C $IMAGENET_HOME/validation
wget -O $IMAGENET_HOME/synset_labels.txt \
https://raw.githubusercontent.com/tensorflow/models/master/research/inception/inception/data/imagenet_2012_validation_synset_labels.txt


# downloading and running the preprocessing script
wget https://raw.githubusercontent.com/tensorflow/tpu/master/tools/datasets/imagenet_to_gcs.py
python3 imagenet_to_gcs.py \
--nogcs_upload \
--raw_data_dir=$IMAGENET_HOME \
--local_scratch_dir=$IMAGENET_HOME/tf_records