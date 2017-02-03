#mollahosseini.py 
import caffe
import numpy as np
from PIL import Image
import scipy.io as sio
import sys 
import os
sys.path.append(os.path.abspath('../helperfuncs'))
import emotion_label_conversions

database = 'fer'
modes = ['original']
names = ['whole']
# modes = ['whole','flipped', 'bottomblur', 'topblur'] # different modes:
# face_detected as well. 
# names = ['whole,','flipped', 'top', 'bottom']
# modes = ['inverted'] 
# names = ['inverted'] 

PARENT_DIR = '/Users/irenefeng/Documents/Computer_Social_Vision/'
CAFFE_DIR = PARENT_DIR + 'caffe/'

if database == 'fer':
	# test_set = (28710, 32299) 
	test_set = (32299,35888)
	IMAGE_DIR = PARENT_DIR + 'cs_99_code/MATLAB/fer2013imgs/'
	LABELS_FILE = PARENT_DIR + 'cs_99_code/MATLAB/fer2013/fer2013.csv'
	labels = np.loadtxt(open(LABELS_FILE,"rb"),delimiter=",",usecols=[0],skiprows=1)
	acc_set = labels[test_set[0] - 1:test_set[1] - 1]
	to_molla = emotion_label_conversions.fer_to_molla() 
	acc_set_conv = map(lambda x: to_molla[x], acc_set)
else: # cohn-kanade
	IMAGE_DIR = PARENT_DIR + 'cohn-kanade-plus/cohn-kanade/for-molla/'
	LABELS_FILE = PARENT_DIR + 'cs_99_code/MATLAB/data/ck_Y.mat'
	labels = sio.loadmat(LABELS_FILE)['ck_Y']
	acc_set = labels[0] # already in molla code oops 
	acc_set_conv = acc_set
	test_set = ('','')

# need to add on for ck+ 

net = caffe.Net(CAFFE_DIR + 'models/mollahosseini_fer/deploy.prototxt', 1,
								weights=CAFFE_DIR + 'models/mollahosseini_fer/training_snapshot_googlenet_quick_iter_100000.caffemodel')


# net = caffe.Net(CAFFE_DIR+'models/bvlc_reference_caffenet/deploy.prototxt', 1,
#  weights=CAFFE_DIR+'models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel')

# need to transform for some reason
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})

# mean=np.zeros((3,40,40), dtype=np.int);
	   # mean[0,:,:]=channelWiseMeanR;
	   # mean[1,:,:]=channelWiseMeanG;
	   # mean[2,:,:]=channelWiseMeanB;
meanR = 79
meanG = 86
meanB = 108
transformer.set_mean('data', np.array([meanR, meanG, meanB]))
transformer.set_transpose('data', (2,0,1)) # i don't know what the transpose is for 
transformer.set_channel_swap('data', (2,1,0)) # from RGB to BGR order 
transformer.set_raw_scale('data', 255.0) # just in case not 0-255. 

for n in range(len(modes)):
	predictions = []
	if database == 'fer':
		loop = map(lambda x: '{0}.png'.format(x), range(test_set[0], test_set[1]))
	else: # ck - didn't do the formatting too right
		loop = os.listdir(IMAGE_DIR+'/'+modes[n])

	for i in loop:
		#load the image in the data layer
		im = caffe.io.load_image(IMAGE_DIR+'/'+modes[n]+'/'+i)
		# generate crops 
		crops = caffe.io.oversample([im], (40, 40))
		# uncomment if not using crops 
		#net.blobs['data'].reshape(1,3,120,120) 
		#net.blobs['data'].data[...] = transformer.preprocess('data', im)
		for j in range(10):
			net.blobs['data'].data[j, ...] = transformer.preprocess('data', crops[j])
		
		out = net.forward() 
		# previous, out would be loss1/classifier
		p = np.argmax(np.average(out['prob'], axis=0))
		predictions.append(p)
		# print 'label for {0}, {1}'.format(i, p)

		if (len(predictions) % 100 == 0):
			print 'finished testing for image {0}'.format(i)

	predictions = np.array(predictions)
	
	# map acc_set to the mollahosseini scores

	acc = (len(acc_set) - np.count_nonzero(acc_set_conv - predictions)) * 1.0 / len(acc_set)
	print 'accuracy is {0}'.format(acc)

	sio.savemat('mollahosseini_test_results_{1}_{0}_{2}_{3}'.format(names[n], database, test_set(0), test_set(1)),
	 			{'predY':predictions, 'testY':acc_set_conv})

# in matlab, then we can call confusion_matrix(predY, testY, stringpng, stringtitle)
# for confusion matrix




