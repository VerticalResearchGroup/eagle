# this script is a compilation of the commands mentioned at the link: https://github.com/mlcommons/inference/tree/master/vision/classification_and_detection
# for running inference on resnet50 on imagenet dataset.


python -m pip install ck --user


# ck version
python3 -m ck

#command for installing
python3 -m ck install package --tags=image-classification,dataset,imagenet,val,original,full

#command for detecting
python3 -m ck detect soft:dataset.imagenet.val --search_dir=/u/c/s/cs838-1/public/imagenet/validation
#press enter


# command for installing
# python3 -m ck install package --tags=image-classification,dataset,imagenet,val,original,full
python3 -m ck install package --tags=image-classification,dataset,imagenet,aux


# checking the locations.
python3 -m ck locate env --tags=image-classification,dataset,imagenet,val,original,full
# result : /home/dvdt/CK-TOOLS/dataset-imagenet-ilsvrc2012-val

python3 -m ck locate env --tags=image-classification,dataset,imagenet,aux
# result : /home/dvdt/CK-TOOLS/dataset-imagenet-ilsvrc2012-aux

cp `python3 -m ck locate env --tags=aux`/val.txt `python3 -m ck locate env --tags=val`/val_map.txt
#permission denied.

export MODEL_DIR=/u/v/y/vyom/private/CS_838_Next_Gen_systems/inference/
export DATA_DIR=/u/c/s/cs838-1/public/imagenet

# handling mlperf error
git clone https://github.com/mlperf/logging.git mlperf-logging
pip3 install -e mlperf-logging

./run_local.sh tf resnet50 cpu