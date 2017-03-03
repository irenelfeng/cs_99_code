# saves array to .mat file 
# specifically, cohn-kanade
import scipy.io as sio
import sys
import os
sys.path.append(os.path.abspath('../helperfuncs'))
import emotion_label_conversions as ec
import numpy as np

# load in all the emotion labels 
def ck_to_mat():
    files = glob.glob('../../cohn-kanade-plus/cohn_kanade_emotion_labels/*/*/*.txt')
    mat = []
    for fileName in files:
        data_list = open(fileName, "rb").readlines()[0].strip()
        label = int(float(data_list))
        if label != 2: mat.append(ck_to_molla[label])

    # save it AS mollahosseini. 
    sio.savemat('ck_Y.mat',{'ck_Y':mat})

# in molla format
def dartmouth_to_mat():
    m = np.loadtxt(open('../../../DartmouthWhalen/dart7wayconfusion.csv',"rb"),delimiter=",",usecols=[4, 5],skiprows=1)
    # wish i could be more elegant 
    predY = []
    testY = []
    # to molla 
    d_to_m = ec.emot_conversion(ec.molla_dic(), ec.dartmouth_dic())
    for i,c in enumerate(m[:,1]):
        if c != -1: 
            testY.append(d_to_m[m[i, 0]])
            predY.append(d_to_m[m[i, 1]])
    sio.savemat('dartmouthTDResults.mat',{'predY':predY, 'testY':testY})


