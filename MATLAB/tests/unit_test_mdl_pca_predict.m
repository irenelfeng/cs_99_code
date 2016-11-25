% does a mini test run of prediction using a PCA-ed model 

load('data/X.mat');
load('data/Y.mat');
load('MDLPCAs2o8.mat');
load('PCAcomps.mat'); % TODO: need to save these after doing model selection
testX = X(1:100,:);
testY = Y(1:100,:);







