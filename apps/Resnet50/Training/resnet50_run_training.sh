#!/bin/sh

conda create -n env3 python=3.7.3
Y 
conda activate env3
pip install tensorflow==2.4.0

# Pulling tensorflow training code (for image classification)
git clone https://github.com/mlcommons/training.git
cd training/image_classification/tensorflow2




# command to run training
# need to see how to import $IMAGENET_HOME path from previous script to here.
python3 ./resnet_ctl_imagenet_main.py \
--base_learning_rate=10.0 \
--batch_size=2 \
--nocache_decoded_image \
--clean \
--data_dir==$IMAGENET_HOME/tf_records \
--device_warmup_steps=1 \
--dtype=fp32 \
--noenable_checkpoint_and_export \
--noenable_device_warmup \
--enable_eager \
--epochs_between_evals=4 \
--noeval_dataset_cache \
--eval_offset_epochs=2 \
--label_smoothing=0.1 \
--lars_epsilon=0 \
--log_steps=125 \
--lr_schedule=polynomial \
--model_dir=$IMAGENET_HOME/data_output \
--optimizer=LARS \
--noreport_accuracy_metrics \
--single_l2_loss_op \
--steps_per_loop=313 \
--train_epochs=42 \
--notraining_dataset_cache \
--notrace_warmup \
--nouse_synthetic_data \
--use_tf_function \
--verbosity=0 \
--warmup_epochs=5 \
--weight_decay=0.0002 \
--target_accuracy=0.759 \
--momentum=0.9 \
--num_replicas=64 \
--num_accumulation_steps=1 \
--num_classes=1000 \
--noskip_eval
