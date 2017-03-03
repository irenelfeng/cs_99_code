import lmdb 
import caffe
import numpy as np

LMDB_path = '/home/ifsdata/scratch/cooperlab/irene/CNN_48_images/LMDB/'
mean_blob = caffe.io.caffe_pb2.BlobProto()
with open(LMDB_path+'40_mean.binaryproto') as f:
    mean_blob.ParseFromString(f.read())
mean_array = np.asarray(mean_blob.data, dtype=np.float32).reshape(
    (mean_blob.channels, mean_blob.height, mean_blob.width))
mean = mean_array.mean(1).mean(1)

PARENT_DIR = '/home/anthill/ifeng/cs99/'
#PARENT_DIR = '/Users/irenefeng/Documents/Computer_Social_Vision/'
CAFFE_DIR = PARENT_DIR + 'caffe/'
net = caffe.Net(CAFFE_DIR + 'models/mollahosseini_fer/deploy_ft.prototxt', 1,
                                weights=CAFFE_DIR + 'models/mollahosseini_fer/snapshots/ft__iter_240000.caffemodel')
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})

transformer.set_mean('data', np.array(mean))
transformer.set_transpose('data', (2,0,1)) # i don't know what the transpose is for 
transformer.set_channel_swap('data', (2,1,0)) # from RGB to BGR order 
transformer.set_raw_scale('data', 255.0) # just in case not 0-255. 


lmdb_env = lmdb.open(LMDB_path+'val_shuf_lmdb_40')
lmdb_txn = lmdb_env.begin()
lmdb_cursor = lmdb_txn.cursor()

predictions = []
values = []
for key, value in lmdb_cursor:
    datum = caffe.proto.caffe_pb2.Datum()
    datum.ParseFromString(value)
    label = int(datum.label)
    image = caffe.io.datum_to_array(datum)
    image = image.astype(np.uint8)
    # change channels from 3, 48, 48 to 48, 48, 3
    image = np.swapaxes(image, 2, 0)
    image = np.swapaxes(image, 0, 1)
    crops = caffe.io.oversample([image], (40, 40))
        # uncomment if not using crops 
        #net.blobs['data'].reshape(1,3,120,120) 
        #net.blobs['data'].data[...] = transformer.preprocess('data', im)
    for j in range(10):
        net.blobs['data'].data[j, ...] = transformer.preprocess('data', crops[j])
    
    out = net.forward() 
    p = np.argmax(np.average(out['prob'], axis=0))
    predictions.append(p)
    values.append(label)

acc = (len(predictions) - np.count_nonzero(np.array(values) - np.array(predictions))) * 1.0 / len(predictions)
print acc 

sio.savemat('ft_400000_test_results_whole_valmdb',
                {'predY':predictions, 'testY':values})

    