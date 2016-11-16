% given X, Y, returns model and confusion matrix 
% calls model_selection.m, confusion_matrix.m
% this is for LDA, change MDL_predict to SVM  
% comment out 

% gets date 
d = date; 

% X and Y
load('X.mat'); % images
load('Y.mat');  % labels
disgust = find(Y==1);
% remove all disgust indexes Y==1
trainX = X(setdiff(1:28709, disgust),:);
trainY = Y(setdiff(1:28709, disgust));
testX = X(setdiff(28710:32299, disgust),:);
testY = Y(setdiff(28710:32299, disgust));
[MDL, s, o] = model_selection(trainX, trainY, 1:3, [4, 8], 5);

% get testX and testY 
predY = MDL_predict(MDL, testX, s, o);
save(sprintf('MDL_SVMs%do%d', s, o), 'MDL');
confusion_matrix(predY, testY, [d,'-s',s,'-o',o,'.png']);
