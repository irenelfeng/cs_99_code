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


# Test the mollahosseini network with lmdb
(NOT WORKING)
call `python ../cs_99_code/PYTHON/caffe_scripts/test_network_with_lmdb.py blurring_bottom` 
or `python ../cs_99_code/PYTHON/caffe_scripts/test_network_with_lmdb.py ft_` for the original fine-tuned model. 
It doesn't get the right image for some reason. 

===
I also modified a FaceDetect algorithm from https://github.com/shantnu/FaceDetect
I did not perform it on FER since it would crop already tiny images. 
I used it for CK+, MMI, and ADFES. 



