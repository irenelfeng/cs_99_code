#mollahosseini.py 
import caffe
import numpy as np
from PIL import Image

PARENT_DIR = '/Users/irenefeng/Documents/Computer_Social_Vision/'
CAFFE_DIR = PARENT_DIR + 'caffe/'
IMAGE_DIR = PARENT_DIR + 'cs_99_code/MATLAB/fer2013imgs/'
net = caffe.Net(CAFFE_DIR + 'models/mollahosseini_fer/deploy.prototxt', 1,
                weights=CAFFE_DIR + 'models/mollahosseini_fer/training_snapshot__iter_100000.caffemodel')

# net = caffe.Net(CAFFE_DIR+'models/bvlc_reference_caffenet/deploy.prototxt', 1,
#  weights=CAFFE_DIR+'models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel')

# need to transform for some reason
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})

# i don't think i have a mean picture so meh 
#transformer.set_mean('data', np.load('python/caffe/imagenet/ilsvrc_2012_mean.npy').mean(1).mean(1))
transformer.set_transpose('data', (2,0,1)) # i don't know what the transpose is for 
transformer.set_channel_swap('data', (2,1,0)) # from RGB to BGR order 
transformer.set_raw_scale('data', 255.0) # just in case not 0-255. 


#load the image in the data layer
im = caffe.io.load_image(IMAGE_DIR + 'original/1.png')
# generate crops 
crops = caffe.io.oversample([im], (40, 40))
# uncomment if not using crops 
#net.blobs['data'].reshape(1,3,120,120) 
#net.blobs['data'].data[...] = transformer.preprocess('data', im)
for i in range(10):
  net.blobs['data'].data[i, ...] = transformer.preprocess('data', crops[i])

out = net.forward() 