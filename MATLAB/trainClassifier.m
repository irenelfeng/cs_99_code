% given X, Y, returns model and confusion matrix 
% calls model_selection.m, confusion_matrix.m
% change this line from LDA to SVM
type = 'LDA';

% gets date 
d = date; 

% X and Y
load('topX.mat'); % images
%load('bottomX.mat');
load('Y.mat');  % labels
disgust = find(Y==1);
neutral = find(Y==6);
% remove all disgust indexes Y==1
trainX = topX(setdiff(1:28709, [disgust; neutral]),:);
trainY = Y(setdiff(1:28709, [disgust; neutral]));
testX = topX(setdiff(1:32299, [disgust; neutral]),:);
testY = Y(setdiff(1:32299, [disgust; neutral]));
[MDL, s, o] = model_selection(trainX, trainY, 1:3, [4, 8], 5, type);

predY = MDL_predict(MDL, testX, s, o);
%predY = MDL_predict(MDL, testX, s, o, comps);

save(sprintf('MDL_BOTTOM%ss%do%d', type, s, o), 'MDL');
confusion_matrix(predY, testY, sprintf('confusionBottomTrained%s-s%ds-o%d%s.png', type, s, o,d), ...
                sprintf('Confusion BottomTrained %s-s%d-o%d', type, s, o));