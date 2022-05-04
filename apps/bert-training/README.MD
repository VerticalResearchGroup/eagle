
# Running MLPerf BERT training, only has tensorflow version

The folder apps/bert-training/bert is an exact copy of mlcommons/training/language_model/tensorflow/bert from MLPerf. 


```
cd bert/
mkdir download
mkdir output
```

Download the following files to bert/download/
```
model.ckpt-28252.data-00000-of-00001: https://drive.google.com/file/d/1oVBgtSxkXC9rH2SXJv85RXR9-WrMPy-Q/view?usp=sharing
model.ckpt-28252.index: https://drive.google.com/file/d/1pJhVkACK3p_7Uc-1pAzRaOXodNeeHZ7F/view?usp=sharing
bert_config.json: https://drive.google.com/file/d/1fbGClQMi2CoMv7fwrwTC5YYPooQBdcFW/view?usp=sharing
vocab.txt: https://drive.google.com/file/d/1USK108J6hMM_d27xCHi738qBL8_BT1u1/view?usp=sharing
```

Download results_text.zip and unzip, then move results_text/results4/part-00000-of-00500 to bert/download/
```
results_text.zip: https://drive.google.com/file/d/1pJhVkACK3p_7Uc-1pAzRaOXodNeeHZ7F/view?usp=sharing
```

## Dataset preprocessing

Start docker container for dataset preprocessing. This command will mount the currect work directory to `/workspace` inside container
```
docker run -v "$PWD:/workspace" -it tensorflow/tensorflow:1.15.2-gpu
```

When container starts, run
```
cd /workspace/cleanup_scripts
python3 create_pretraining_data.py \
   --input_file=../download/part-00000-of-00500 \
   --output_file=../output/part-00000-of-00500 \
   --vocab_file=../download/vocab.txt \
   --do_lower_case=True \
   --max_seq_length=512 \
   --max_predictions_per_seq=76 \
   --masked_lm_prob=0.15 \
   --random_seed=12345 \
   --dupe_factor=10
exit
```
This will create a TFRecord file from downloaded `part-00000-of-00500` and then exit. Since we do not run a full training, a single TFRecord file is sufficient. 


## Training

MLPerf training code run on a different docker image, but the image does not have mlperf-logging installed, so first download the mlperf-logging repo in `bert\` folder
```
git clone https://github.com/mlperf/logging.git mlperf-logging
```

Then, start docker container for training
```
docker run -v "$PWD:/workspace" -it tensorflow/tensorflow:2.4.0-gpu
```
When container starts, run
```
cd /workspace/
pip install -e mlperf-logging
TF_XLA_FLAGS='--tf_xla_auto_jit=2' \
python run_pretraining.py \
  --bert_config_file=./download/bert_config.json \
  --output_dir=/tmp/output/ \
  --input_file="output/part*" \
  --nodo_eval \
  --do_train \
  --eval_batch_size=1 \
  --learning_rate=0.0001 \
  --init_checkpoint=./download/model.ckpt-28252 \
  --iterations_per_loop=10 \
  --max_predictions_per_seq=76 \
  --max_seq_length=512 \
  --num_train_steps=10 \
  --num_warmup_steps=2 \
  --optimizer=lamb \
  --save_checkpoints_steps=10 \
  --start_warmup_step=0 \
  --num_gpus=0 \
  --train_batch_size=1
exit
```
This command will install `mlperf-logging`, then start the training process. Finally, it will exit the container. No GPU is required. 

All commands above assume the host work directory is `bert/`

# Getting tensor shape

Since MLPerf only has tensorflow implementation for bert training, to get tensor shape and operator trace, we use implementation of BERT from HuggingFace's transformer. The `model_shape.py` code is a slight modification of Ruohui's code provided on Teams. To do so, start a different docker container
```
docker run -v "$PWD:/workspace" -it pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime
```
When container starts, run
```
pip install transformers
python model_shape.py
```
This command will install `transformers`, then run operator trace extraction and output a `bert-base-training.csv`. 
