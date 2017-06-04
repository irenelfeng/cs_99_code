# code framework from https://github.com/shantnu/FaceDetect

import cv2
import sys
import os
import math
# Get user supplied values
directory = sys.argv[1]
cascPath = sys.argv[2]

# Create the haar cascade
faceCascade = cv2.CascadeClassifier(cascPath)

# save directory 
facedir = directory+'../face_detected'
if not os.path.exists(facedir):
    os.makedirs(facedir)
# Read the image
for imagePath in os.listdir(directory):
    if 'jpg' not in imagePath:
        continue 
    image = cv2.imread(directory+'/'+imagePath) # 0 autoconverts to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    # Detect faces in the image
    faces = faceCascade.detectMultiScale(
        gray,
        scaleFactor=1.01,
        minNeighbors=5,
        minSize=(200, 200), # (30,30) for FER images 
    )

    if len(faces) == 0: 
        # then just leave face how it is
        print 'found no face for file {0}'.format(imagePath)
        continue

    elif len(faces) > 1: 
        print 'Weird, there is more than 1 face founded in file {0}'.format(imagePath)
        print 'will just use the biggest (widest) one'
        faces = sorted(faces, key=lambda x: (x[2],x[3]), reverse=True)

    # crops the image at this rectangle 
    (x, y, w, h) = faces[0]
    # print (x, y, w, h)
    crop_img = image[y:y+h, x:x+w, :] # Crop from x, y, w, h -> 100, 200, 300, 400
    # NOTE: its img[y: y + h, x: x + w] and *not* img[x: x + w, y: y + h]
    # scales crop to be square, i guess the closest square <= area 
    s = int(round(math.sqrt(w*h)))
    square = cv2.resize(crop_img, (s,s))
    cv2.imwrite(facedir+'/'+imagePath, square)
    
    


