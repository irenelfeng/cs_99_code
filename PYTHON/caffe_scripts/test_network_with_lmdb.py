import lmdb 
import caffe
import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt
import sys 

which_val = sys.argv[1] # blurring_bottom, blurring_top, ft_
LMDB_path = '/home/ifsdata/scratch/cooperlab/irene/CNN_48_images/LMDB/'
mean_blob = caffe.io.caffe_pb2.BlobProto()
with open(LMDB_path+'40_mean.binaryproto') as f:
    mean_blob.ParseFromString(f.read())
mean_array = np.asarray(mean_blob.data, dtype=np.float32).reshape(
    (mean_blob.channels, mean_blob.height, mean_blob.width))
mean = mean_array.mean(1).mean(1)

if 'bottom' in which_val:
    lmdb_env = lmdb.open(LMDB_path+'bottom_val_lmdb_40')
elif 'top' in which_val:
    lmdb_env = lmdb.open(LMDB_path+'top_val_lmdb_40')
else: 
    lmdb_env = lmdb.open(LMDB_path+'val_shuf_lmdb_40')
lmdb_txn = lmdb_env.begin()
lmdb_cursor = lmdb_txn.cursor()

PARENT_DIR = '/home/anthill/ifeng/cs99/'
#PARENT_DIR = '/Users/irenefeng/Documents/Computer_Social_Vision/'
CAFFE_DIR = PARENT_DIR + 'caffe/'
net = caffe.Net(CAFFE_DIR + 'models/mollahosseini_fer/deploy.prototxt', 1,
                                weights=CAFFE_DIR + 'models/mollahosseini_fer/snapshots/'+which_val+'_iter_80000.caffemodel')
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})

transformer.set_mean('data', np.array(mean))
transformer.set_transpose('data', (2,0,1)) # (48,48,3) to (3, 48, 48) 
transformer.set_channel_swap('data', (2,1,0)) # from RGB to BGR order 
transformer.set_raw_scale('data', 255.0) # just in case not 0-255. 


predictions = []
values = []
f = open('testfile', 'w')
for key, value in lmdb_cursor:
    datum = caffe.proto.caffe_pb2.Datum()
    datum.ParseFromString(value)
    label = int(datum.label)
    image = caffe.io.datum_to_array(datum)
    # print image
    image = image/255.0 # omg apparently you NEED TO DO THIS 
    # i fucking hate this stupid thing 
    image = np.transpose(image, (1, 2, 0))    # -> height, width, channels
    image = image[:,:,::-1]                   # BGR -> RGB
    # i have to make it go back w/ the transformer lmao this is so stupid. 
    # image.tofile(f)
    # change channels from 3, 48, 48 to 48, 48, 3
    crops = caffe.io.oversample([image], (40, 40))
        # uncomment if not using crops 
        #net.blobs['data'].reshape(1,3,120,120) 
        #net.blobs['data'].data[...] = transformer.preprocess('data', im)
    for j in range(10):
        net.blobs['data'].data[j, ...] = transformer.preprocess('data',crops[j])
    
    out = net.forward() 
    #print out
    p = np.argmax(np.average(out['prob'], axis=0))
    predictions.append(p)
    values.append(label)

acc = (len(predictions) - np.count_nonzero(np.array(values) - np.array(predictions))) * 1.0 / len(predictions)
print acc
print len(predictions)
sio.savemat('network_results_{0}_val'.format(which_val),
                {'predY':predictions, 'testY':values})
    