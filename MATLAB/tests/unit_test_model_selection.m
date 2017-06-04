% does a mini test run of test of model_selection.m script 

load('data/128X.mat');
load('data/128Y.mat');
s = 1;
o = 4;
trainX = X(1:100,:);
trainY = Y(1:100,:);

% 0. checks for mode error 
MDL = model_selection(trainX, trainY, s, o, 5, 'dumbo');
assert(strcmp(MDL, 'error') == 1);

% 1. does multiclass LDA 
[MDL, s, o, comps] = model_selection(trainX, trainY, s, o, 5, 'LDA');

% 2. does multiclass SVM 
[MDL, s, o] = model_selection(trainX, trainY, 1, 4, 5, 'SVM');

disp('TESTS PASSED')