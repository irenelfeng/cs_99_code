# adapt from face_detect_cv3: for mmi 

import cv2
import sys
import os
import math
import numpy as np
# Get user supplied values
directory = '../../../mmi'
cascPath = 'haarcascade_frontalface_default.xml'
eyePath = 'haarcascade_eye_eyeglasses.xml'

# Create the haar cascade
faceCascade = cv2.CascadeClassifier(cascPath)
eyeCascade = cv2.CascadeClassifier(eyePath)
rotateLeft3 = ['S028', 'S030', 'S031', 'S032', 'S033', 'S034',
'S035', 'S036', 'S037', 'S038', 'S039', 'S040', 'S041',
'S042', 'S043', 'S044','S045', 'S046', 'S047', 'S048', 'S049', 'S050'];
frontLeft = ['S003', 'S005', 'S006', 'S016'];
frontRight = ['S001', 'S002', 'S017'];

# Read the image
for root, dirs, files in os.walk(directory):
    for file in files: 
        if '.png' in file and 'face_detected' not in root:
            image = cv2.imread(root+'/'+file) # autoconverts to grayscale
            gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
            # Detect faces in the image
            SUBJECT = file.split('-')[0]
            if file.split('-')[0] == 'S021':
                image = np.rot90(image)
                gray = np.rot90(gray) # rotate left once, stupid
            elif SUBJECT in rotateLeft3: 
                image = np.rot90(image,3)
                gray = np.rot90(gray,3) # rotate left 3 times, as in righht

            faces = faceCascade.detectMultiScale(
                gray,
                scaleFactor=1.01,
                minNeighbors=5,
                minSize=(180, 180), # (30,30) for FER images 
            )


            if len(faces) == 0: 
                print 'found no face for file {0}'.format(file)
                Exception('impossible :c')  

            elif len(faces) > 1: 
                # maybe to make it better, do eye detect
                center_x = round(image.shape[0]/2); 
                left = 0
                if SUBJECT in frontLeft:
                    left = 1
                    faces = filter(lambda x: not(x[0] < center_x and left),faces)

                elif SUBJECT in frontRight:
                    left = 0
                    faces = filter(lambda x: not(x[0] < center_x and left),faces)

                else:
                    Exception
                print 'there is more than 1 face founded in file {0}'.format(file)
                # get biggest on the side it should be on. ~XOR
                faces = sorted(faces, key=lambda x: (x[2],x[3]), reverse=True) 

            # crops the image at this rectangle 
            (x, y, w, h) = faces[0]
            # why is the image still not saved as rotated? o.o
            crop_img = image[y:y+h, x:x+w, :] # Crop from x, y, w, h 
            # NOTE: its img[y: y + h, x: x + w] and *not* img[x: x + w, y: y + h]
            # scales crop to be square, i guess the closest square <= area 
            s = int(round(math.sqrt(w*h)))
            square = cv2.resize(crop_img, (s,s))
            parts = root.split('/')
            flat = '/'.join(parts[:len(parts)-1]) 
            m = cv2.imwrite(flat + '/face_detected/'+parts[-1]+'_'+file, square)