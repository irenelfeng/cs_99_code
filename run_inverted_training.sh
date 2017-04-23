cd ~/cs99/caffe
./build/tools/caffe train -solver=models/mollahosseini_fer/inverted_solver.prototxt -snapshot=models/mollahosseini_fer/snapshots/inverted__iter_680000.solverstate
# ./build/tools/caffe train -solver=models/mollahosseini_fer/inverted_solver.prototxt -snapshot=models/mollahosseini_fer/snapshots/inverted__iter_320000.solverstate
#./build/tools/caffe train -solver=models/mollahosseini_fer/inverted_solver.prototxt -weights=models/mollahosseini_fer/training_snapshot_googlenet_quick_iter_100000.caffemodel > inverted_training_log
