# MATLAB toolboxes to download
[heatmap toolbox for confusion matrices](https://www.mathworks.com/matlabcentral/fileexchange/24253-customizable-heat-maps)


# Files to Run 

## For training toy example: 
### To get the training set, run `loadImages.m` to get X.mat and Y.mat, and generate .png files 
	* this might take 30+ minutes to load. 
### Then run `trainClassifier.m` to get back a trained classifier and display a confusion matrix for you! - options to change from LDA to SVM. 

### run `gaussian_blur.m` to generate topX.mat and bottomX.mat (blurred images)
### run `model_top_bottom_testing.m` to now test your model given blurred images.

### change `trainClassifier.m` if you want to also train a model with blurred images, and then test with blurred images. 
