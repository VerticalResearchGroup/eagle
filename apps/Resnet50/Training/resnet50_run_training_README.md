
# Project EAGLE
# Resnet50 Training script readme.
Before running the script : resnet50_run_training.sh

run the command
`export IMAGENET_HOME=/path/to/imagenetHome`

You can get the path: /path/to/imagenetHome by going through the script: resnet50_download_preprocess.sh
You basically need to have the training data, validation data and the synset_labels.txt file all located at : /path/to/imagenetHome
and then run in bash:

`sh resnet50_run_training.sh`
