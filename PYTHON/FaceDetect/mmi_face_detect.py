# adapt from face_detect_cv3: for mmi 

import cv2
import sys
import os
import math
import numpy as np
# Get user supplied values
directory = '../../../mmi'
cascPath = 'haarcascade_frontalface_default.xml'

# Create the haar cascade
faceCascade = cv2.CascadeClassifier(cascPath)

# save directory 
facedir = directory+'/../face_detected'
if not os.path.exists(facedir):
    os.makedirs(facedir)
# Read the image
for root, dirs, files in os.walk(directory):
    for file in files: 
        if '.png' in file:
            image = cv2.imread(root+'/'+file, 0) # autoconverts to grayscale
            # gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
            # Detect faces in the image
            faces = faceCascade.detectMultiScale(
                image,
                scaleFactor=1.01,
                minNeighbors=5,
                minSize=(100, 100), # (30,30) for FER images 
            )

            if len(faces) == 0: 
                # then we have to rotate the image to the left, i think
                print 'found no face for file {0}, so i rotate!'.format(file) 
                image = np.rot90(image,3)
                faces = faceCascade.detectMultiScale(
                    image,
                    scaleFactor=1.01,
                    minNeighbors=5,
                    minSize=(100, 100), # (30,30) for FER images 
                )

            elif len(faces) > 1: 
                print 'there is more than 1 face founded in file {0}'.format(file)
                # maybe to make it better, do eye detect and choose the one with the biggest eyes. 
                faces = sorted(faces, key=lambda x: (x[2],x[3]), reverse=True)

            # crops the image at this rectangle 
            (x, y, w, h) = faces[0]
            # print (x, y, w, h)
            crop_img = image[y:y+h, x:x+w] # Crop from x, y, w, h -> 100, 200, 300, 400
            # NOTE: its img[y: y + h, x: x + w] and *not* img[x: x + w, y: y + h]
            # scales crop to be square, i guess the closest square <= area 
            s = int(round(math.sqrt(w*h)))
            square = cv2.resize(crop_img, (s,s))
            cv2.imwrite(facedir+'/'+file, square)