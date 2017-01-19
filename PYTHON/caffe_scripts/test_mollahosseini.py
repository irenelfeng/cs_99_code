#mollahosseini.py 
import caffe
import numpy as np
from PIL import Image
import scipy.io as sio
import sys 
import os
sys.path.append(os.path.abspath('../helperfuncs'))
import emotion_label_conversions

PARENT_DIR = '/Users/irenefeng/Documents/Computer_Social_Vision/'
CAFFE_DIR = PARENT_DIR + 'caffe/'
IMAGE_DIR = PARENT_DIR + 'cs_99_code/MATLAB/fer2013imgs/'
FER_CSV = PARENT_DIR + 'cs_99_code/MATLAB/fer2013/fer2013.csv'

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

test_set = (28710, 32299) 
# test_set = (32299,35888)
predictions = []
# modes = ['original', 'bottomblur', 'topblur']
# names = ['whole', 'top', 'bottom']
modes = ['face_detected']
names = ['face_detected']
for n in range(len(modes)):
	for i in range(test_set[0], test_set[1]):
		#load the image in the data layer
		im = caffe.io.load_image(IMAGE_DIR + '{0}/{1}.png'.format(modes[n],i))
		# generate crops 
		crops = caffe.io.oversample([im], (40, 40))
		# uncomment if not using crops 
		#net.blobs['data'].reshape(1,3,120,120) 
		#net.blobs['data'].data[...] = transformer.preprocess('data', im)
		for j in range(10):
			net.blobs['data'].data[j, ...] = transformer.preprocess('data', crops[j])
		
		out = net.forward() 
		p = np.argmax(np.average(out['loss1/classifier'], axis=0))
		predictions.append(p)
		# print 'label for {0}, {1}'.format(i, p)

		if (i % 100 == 0):
			print 'finished testing for image {0}'.format(i) 

	predictions = np.array(predictions)
	labels = np.loadtxt(open(FER_CSV,"rb"),delimiter=",",usecols=[0],skiprows=1)
	# starts counting from 0... so -1
	acc_set = labels[test_set[0] - 1:test_set[1] - 1]
	# map acc_set which is FER to the mollahosseini scores
	fer_to_molla = emotion_label_conversions.fer_to_molla() 
	acc_set_conv = map(lambda x: fer_to_molla[x], acc_set)

	acc = (len(acc_set) - np.count_nonzero(acc_set_conv - predictions)) * 1.0 / len(acc_set)
	print 'accuracy is {0}'.format(acc)

	sio.savemat('mollahosseini_fd_test_results_{2}_{0}_{1}'.format(test_set[0], test_set[1], names[n]),
	 			{'predY':predictions, 'testY':acc_set_conv})

# in matlab, then we can call confusion_matrix(predY, testY, stringpng, stringtitle)
# for confusion matrix




