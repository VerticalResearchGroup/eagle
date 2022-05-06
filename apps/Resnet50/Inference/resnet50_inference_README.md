# Project EAGLE
# Resnet50 Inference readme.

This script is a compilation of the commands mentioned at the link: https://github.com/mlcommons/inference/tree/master/vision/classification_and_detection
for running inference on resnet50 on Imagenet dataset.

You can download the dataset: Imagenet using:
[http://image-net.org/challenges/LSVRC/2012/](http://image-net.org/challenges/LSVRC/2012/)

OR 
Alternatively, you can download the datasets using the [Collective Knowledge](http://cknowledge.org/) framework (CK) for collaborative and reproducible research.
`python -m pip install ck --user`


ck version
`python3 -m ck`

command for installing imagenet package
`python3 -m ck install package --tags=image-classification,dataset,imagenet,val,original,full`

command for detecting imagenet package
`python3 -m ck detect soft:dataset.imagenet.val --search_dir=/u/c/s/cs838-1/public/imagenet/validation`
press enter after running this


command for installing
python3 -m ck install package --tags=image-classification,dataset,imagenet,val,original,full
`python3 -m ck install package --tags=image-classification,dataset,imagenet,aux`


For checking the locations.
`python3 -m ck locate env --tags=image-classification,dataset,imagenet,val,original,full`
example : result : /home/dvdt/CK-TOOLS/dataset-imagenet-ilsvrc2012-val

`python3 -m ck locate env --tags=image-classification,dataset,imagenet,aux`
result : /home/dvdt/CK-TOOLS/dataset-imagenet-ilsvrc2012-aux

`cp `python3 -m ck locate env --tags=aux`/val.txt `python3 -m ck locate env --tags=val`/val_map.txt`

Download the model and dataset for the model you want to benchmark.
Set the below variables.
`export MODEL_DIR=/u/v/y/vyom/private/CS_838_Next_Gen_systems/inference/`
`export DATA_DIR=/u/c/s/cs838-1/public/imagenet`

For Handling mlperf error
`git clone https://github.com/mlperf/logging.git mlperf-logging`
`pip3 install -e mlperf-logging`


Now to run the inference script.
`./run_local.sh tf resnet50 cpu`

Here, 
backend is one of [tf|onnxruntime|pytorch|tflite]
model is one of [resnet50|mobilenet|ssd-mobilenet|ssd-resnet34]
device is one of [cpu|gpu]


For example:

./run_local.sh tf resnet50 cpu
