# Create/load datasets: 
#### Download a bunch of different datasets: 
- ADFES, KDEF, MMI, CK+ (all available online with educational license), and FER if you want to do CNN training 
#### For CNN dataset: 
Many scripts to create 48x48 images out of the given datasets. 

#### For nonCNN dataset: 
Run `nonCNN_unbalanced_dataset.m` to get a smaller but higher-resolution, more balanced dataset
Related scripts before running `nonCNN_unbalanced_dataset`: 
`load_ADFES_take_away_disgust.m` and `load_MMI_take_away_disgust.m` (requires download in certain folders of different datasets) 

# non-CNN methods
The non-CNN methods are executed in MATLAB. 
## MATLAB toolboxes to download
[heatmap toolbox for confusion matrices](https://www.mathworks.com/matlabcentral/fileexchange/24253-customizable-heat-maps)

## Tests to Run 

### For training: 

#### Run `trainClassifier.m` to get back a trained classifier and display a confusion matrix for you! - options to change from LDA to SVM. 

#### run `gaussian_blur.m` to generate topX.mat and bottomX.mat (blurred images)
#### run `model_top_bottom_testing.m` to now test your model given blurred images.

#### change `trainClassifier.m` if you want to also train a model with blurred images, and then test with blurred images. 

## Naming Conventions 
`MDL_*s*o*.mat` = type, sizes, orientations 
- the model classifier
`MDL_comps_*s*o*.mat` = type, sizes, orientations
- the components for this certain model (for transformation purposes) 

# FOR CAFFE TRAINING AUGMENTED LAYERS: 
make sure you put this in your bash: 
`export PYTHONPATH=~/path/to/cs_99_code/PYTHON/InvertedLayerRandom:$PYTHONPATH`
so that when you run caffe train, you can add the inverted layer in! 

# Deprecated Files 
```
loadImages.m

```
