% does a mini test run of test of model selection 

load('data/X.mat');
load('data/Y.mat');
s = 1;
o = 4;
trainX = X(1:2000,:);
trainY = Y(1:2000,:);

% 1. does multiclass LDA 
[MDL, s, o] = model_selection(trainX, trainY, s, o, 5, 'LDA');

% 2. does multiclass SVM 
[MDL, s, o] = model_selection(trainX, trainY, s, o, 5, 'SVM');

printf('TESTS PASSED');