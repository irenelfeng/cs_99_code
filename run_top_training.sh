cd /home/anthill/ifeng/cs99/caffe/
./build/tools/caffe train -solver=models/mollahosseini_fer/train_val2_top_solver.prototxt -snapshot=models/mollahosseini_fer/snapshots/blurring_top_iter_640000.solverstate -gpu 1
# ./build/tools/caffe train -solver=models/mollahosseini_fer/train_val2_top_solver.prototxt -snapshot=models/mollahosseini_fer/snapshots/blurring_top_iter_320000.solverstate -gpu 1
#./build/tools/caffe train -solver=models/mollahosseini_fer/train_val2_top_solver.prototxt -weights=models/mollahosseini_fer/training_snapshot_googlenet_quick_iter_100000.caffemodel -gpu 1 > top_log
# ./build/tools/caffe train -solver=models/mollahosseini_fer/inverted_solver.prototxt -weights=models/mollahosseini_fer/training_snapshot_googlenet_quick_iter_100000.caffemodel > inverted_training_log
