I run python for caffe mainly. 

## Dependencies
To connect my matlab scripts to my python scripts, I installed a matlab engine for python 
For instructions to download the API go [here](https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html)
===
# Test the mollahosseini network 
call `test_mollahosseini.py /path/to/cs_99_code/ mode`
modes: 'fer' (not used to test anymore, too low), 'ck', 'val', 'MATLAB' 
so on anthill: `python caffe_scripts/test_mollahosseini.py /home/anthill/ifeng/cs99/ MATLAB`
on my own compy: `python caffe_scripts/test_mollahosseini.py /Users/irenefeng/Documents/Computer_Social_Vision/ MATLAB`

===
I also modified a FaceDetect algorithm from https://github.com/shantnu/FaceDetect
I performed it on FER so far. 61% of the faces have been registered. 

