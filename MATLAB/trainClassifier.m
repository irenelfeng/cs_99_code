% given X, Y, returns model and confusion matrix 
% calls model_selection.m, confusion_matrix.m

% X and Y
load('X.mat');
load('Y.mat'); 
trainX = X(1:28709,:);
trainY = Y(1:28709,:);
testX = X(28710:32299,:);
testY = Y(28710:32299,:);
MDL = model_selection(trainX, trainY, 1:3, [4, 8], 5);

% get testX and testY 
confusion_matrix(MDL, testX, testY);
