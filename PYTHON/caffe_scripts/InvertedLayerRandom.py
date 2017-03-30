import numpy as np
import cv2
from random import randint
import caffe
from distortions import add_grid

class InvertedLayerRandom(caffe.Layer):

    def setup(self, bottom, top):
        """
        Checks the correct number of bottom inputs.
        
        :param bottom: bottom inputs
        :type bottom: [numpy.ndarray]
        :param top: top outputs
        :type top: [numpy.ndarray]
        """
        self.top_names = ['data', 'label']

        self.k = 1 # how many times we want to multiply the labels by 
        # i'm not adding here, so cool. 
        pass
 
    def reshape(self, bottom, top):
        """
        Make sure all involved blobs have the right dimension.
        
        :param bottom: bottom inputs
        :type bottom: caffe._caffe.RawBlobVec
        :param top: top outputs
        :type top: caffe._caffe.RawBlobVec
        """
        #top[1].reshape(self.k*bottom[1].data.shape[0])
        top[0].reshape(self.k*bottom[0].data.shape[0], bottom[0].data.shape[1], bottom[0].data.shape[2], bottom[0].data.shape[3])
        
    def forward(self, bottom, top):
        """
        Forward propagation.
        
        :param bottom: bottom inputs
        :type bottom: caffe._caffe.RawBlobVec
        :param top: top outputs
        :type top: caffe._caffe.RawBlobVec
        """
        
        batch_size = bottom[0].data.shape[0]
        top[0].data[...] = bottom[0].data # start out the same
        for i in range(batch_size):
            x = randint(0, 1) # 2 numbers, 50% probability 
            if x == 1: # flip 
                im = bottom[0].data[0, :, :, :]
                inv = np.flipud(im)
                top[0].data[i, :, :,:] = inv


    def backward(self, top, propagate_down, bottom):
        """
        Backward pass.
        
        :param bottom: bottom inputs
        :type bottom: caffe._caffe.RawBlobVec
        :param propagate_down:
        :type propagate_down:
        :param top: top outputs
        :type top: caffe._caffe.RawBlobVec
        """
             
        pass