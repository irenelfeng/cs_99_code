#mollahosseini.py 
import caffe
import numpy as np
from PIL import Image
import scipy.io as sio
import sys 
import os
import lmdb
sys.path.append(os.path.abspath('../helperfuncs'))
import emotion_label_conversions

database = 'val'
modes = ['face_detected']
names = ['fd']
# modes = ['whole','flipped', 'bottomblur', 'topblur'] # different modes:
# face_detected as well. 
# names = ['whole,','flipped', 'top', 'bottom']
# modes = ['inverted'] 
# names = ['inverted'] 

#PARENT_DIR = '/Users/irenefeng/Documents/Computer_Social_Vision/'
#CAFFE_DIR = PARENT_DIR + 'caffe/'
PARENT_DIR = '/home/anthill/ifeng/cs99/'
#PARENT_DIR = '/Users/irenefeng/Documents/Computer_Social_Vision/'
CAFFE_DIR = PARENT_DIR + 'caffe/'

if database == 'fer':
	#test_set = (28710, 32299) 
	test_set = (32299,35888)
	IMAGE_DIR = PARENT_DIR + 'cs_99_code/MATLAB/fer2013imgs/'
	LABELS_FILE = PARENT_DIR + 'cs_99_code/MATLAB/fer2013/fer2013.csv'
	labels = np.loadtxt(open(LABELS_FILE,"rb"),delimiter=",",usecols=[0],skiprows=1)
	acc_set = labels[test_set[0] - 1:test_set[1] - 1]
	to_molla = emotion_label_conversions.fer_to_molla() 
	acc_set_conv = map(lambda x: to_molla[x], acc_set)
elif database == 'ck': # cohn-kanade
	IMAGE_DIR = PARENT_DIR + 'cohn-kanade-plus/cohn-kanade/for-molla/'
	LABELS_FILE = PARENT_DIR + 'cs_99_code/MATLAB/data/CK_Y.mat'
	labels = sio.loadmat(LABELS_FILE)['Y']
	acc_set_conv = labels[0] # already in molla code oops 
	test_set = ()
elif database == 'val':
	IMAGE_DIR = '/home/ifsdata/scratch/cooperlab/irene/CNN_48_images/val/'
	LABELS_FILE = IMAGE_DIR + '../file_labels_val_no_space.txt'
	# acc_set_conv = np.loadtxt(open(LABELS_FILE,"rb"),delimiter=" ",usecols=[1])

	test_set = ()
	dictionary = open(LABELS_FILE).readlines()
	filenames = [x.split(' ')[0] for x in dictionary]

	# comment these three lines if you want FER included
	nonFER = filter(lambda x: 'FER' not in x.split(' ')[0], dictionary)
	acc_set_conv = np.array(map(lambda x: int(x.split(' ')[1]), nonFER))
	filenames = map(lambda x: x.split(' ')[0] , nonFER)

	filenames = [x.split('/')[-1] for x in filenames]

# meanR = 79
# meanG = 86
# meanB = 108
# mean = [meanR, meanG, meanB];

mean_blob = caffe.io.caffe_pb2.BlobProto()
with open('/home/ironfs/scratch/cooperlab/irene/CNN_48_images/LMDB/40_mean.binaryproto') as f:
    mean_blob.ParseFromString(f.read())
mean_array = np.asarray(mean_blob.data, dtype=np.float32).reshape(
    (mean_blob.channels, mean_blob.height, mean_blob.width))
mean = mean_array.mean(1).mean(1)

net = caffe.Net(CAFFE_DIR + 'models/mollahosseini_fer/deploy_ft.prototxt', 1,
								weights=CAFFE_DIR + 'models/mollahosseini_fer/snapshots/ft__iter_1000000.caffemodel')

# need to transform for some reason
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})

transformer.set_mean('data', np.array(mean))
transformer.set_transpose('data', (2,0,1)) # i don't know what the transpose is for 
transformer.set_channel_swap('data', (2,1,0)) # from RGB to BGR order 
transformer.set_raw_scale('data', 255.0) # just in case not 0-255. 

for n in range(len(modes)):
	predictions = []
	if database == 'fer':
		loop = map(lambda x: '{0}.png'.format(x), range(test_set[0], test_set[1]))
	elif database == 'ck': # ck - didn't do the formatting too right
		loop = sorted(os.listdir(IMAGE_DIR+'/'+modes[n]))
	else: 
		loop = filenames

	for i in loop:	

		#load the image in the data layer
		if database == 'val':
			im = caffe.io.load_image(IMAGE_DIR+'/'+i)
		else:
			im = caffe.io.load_image(IMAGE_DIR+'/'+modes[n]+'/'+i)

		# generate crops 
		crops = caffe.io.oversample([im], (40, 40))
		# uncomment if not using crops 
		#net.blobs['data'].reshape(1,3,120,120) 
		#net.blobs['data'].data[...] = transformer.preprocess('data', im)
		for j in range(10):
			net.blobs['data'].data[j, ...] = transformer.preprocess('data', crops[j])
		
		out = net.forward()
		print out 
		# previous, out would be loss1/classifier
		p = np.argmax(np.average(out['prob'], axis=0))
		# p = np.argmax(np.average(out['loss1/classifier'], axis=0))
		predictions.append(p)
		# print 'label for {0}, {1}'.format(i, p)

		if (len(predictions) % 100 == 0):
			print 'finished testing for image {0}'.format(i)

	predictions = np.array(predictions)
	print p
	print 
	
	acc = (len(acc_set_conv) - np.count_nonzero(acc_set_conv - predictions)) * 1.0 / len(acc_set_conv)
	print 'accuracy is {0}'.format(acc)

	sio.savemat('mollahosseini_test_results_noFER_{1}_{0}'.format(names[n], database, '_'.join(map(lambda x: str(x), test_set))),
	 			{'predY':predictions[0], 'testY':acc_set_conv[0]})

# in matlab, then we can call confusion_matrix(predY, testY, stringpng, stringtitle)
# for confusion matrix




