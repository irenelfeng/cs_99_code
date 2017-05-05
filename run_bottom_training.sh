cd /home/anthill/ifeng/cs99/caffe
./build/tools/caffe train -solver=models/mollahosseini_fer/train_val2_bottom_solver.prototxt -weights=models/mollahosseini_fer/snapshots/blurring_bottom_iter_320000.caffemodel
# ./build/tools/caffe train -solver=models/mollahosseini_fer/train_val2_bottom_solver.prototxt -weights=models/mollahosseini_fer/snapshots/blurring_bottom_iter_280000.caffemodel
# ./build/tools/caffe train -solver=models/mollahosseini_fer/train_val2_bottom_solver.prototxt -weights=models/mollahosseini_fer/training_snapshot_googlenet_quick_iter_100000.caffemodel -gpu 2
# ./build/tools/caffe train -solver=models/mollahosseini_fer/inverted_solver.prototxt -weights=models/mollahosseini_fer/training_snapshot_googlenet_quick_iter_100000.caffemodel > inverted_training_log
