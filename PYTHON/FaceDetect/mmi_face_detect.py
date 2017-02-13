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
rotateLeft3 = ['S028', 'S030', 'S031', 'S032', 'S033',
'S035', 'S036', 'S037', 'S038', 'S039', 'S040', 'S041',
'S042', 'S045', 'S046', 'S047', 'S048', 'S049', 'S050'];

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
            SUBJECT = file.split('-')[0]
            if file.split('-')[0] == 'S021':
                image = np.rot90(image) # rotate left once, stupid
            elif SUBJECT in rotateLeft3: 
                image = np.rot90(image,3) # rotate left 3 times, as in righht

            faces = faceCascade.detectMultiScale(
                image,
                scaleFactor=1.01,
                minNeighbors=5,
                minSize=(100, 100), # (30,30) for FER images 
            )


            if len(faces) == 0: 
                # ugh but it's not capturing all the rotated images because sometimes it detects something stupid as a face. 
                # then we have to rotate the image 90 to the right, i think
                # sad not all of them are rotated right. 
                print 'found no face for file {0}'.format(file) 

            elif len(faces) > 1: 
                print 'there is more than 1 face founded in file {0}'.format(file)
                # maybe to make it better, do eye detect 
                most_centered = 0
                most_centered_dist = 1000
                for i,(x,y,w,h) in enumerate(faces):
                    crop_img = image[y:y+h, x:x+w]
                    closest_distance = 1000
                    most_centered = 0

                    eyes = eyeCascade.detectMultiScale(crop_img)
                    if len(eyes) == 2: # this is probably the face we want
                        eyes = sorted(eyes, key=lambda x: (x[0])) # x coordinate is COLUMNS
                        print '2 eyes for this face {0}'.format(i)
                        # left eye nearest the center
                        # or maybe the midpoint of left eye and right eye
                        # left eye edge (left eye start + left eye end + right eye end)
                        midpoint = (eyes[0][0] + eyes[0][2] + eyes[1][0])/2.0
                        # choose closest midpoint
                        if abs((x+w) / 2.0 - midpoint) < closest_distance: 
                            most_centered = i
                            closest_distance = abs((x+w) / 2.0 - midpoint)

                print 'most centered face is index {0}'.format(most_centered)
                faces[0] = faces[most_centered]


            # crops the image at this rectangle 
            (x, y, w, h) = faces[0]
            # why is the image still not saved as rotated? o.o
            crop_img = image[y:y+h, x:x+w] # Crop from x, y, w, h 
            # NOTE: its img[y: y + h, x: x + w] and *not* img[x: x + w, y: y + h]
            # scales crop to be square, i guess the closest square <= area 
            s = int(round(math.sqrt(w*h)))
            square = cv2.resize(crop_img, (s,s))
            cv2.imwrite(facedir+'/'+ root + '/'+file, square)