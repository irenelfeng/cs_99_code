% test existing model with top blur and bottom blur 
 
% loads existing model MDL here
s=2;
o=8;
load(sprintf('MDL_SVMs%do%d.mat', s, o));

load('X.mat');
load('topX.mat');
load('bottomX.mat');
load('Y.mat');

d = date;
disgust = find(Y==1);
X = X(setdiff(1:size(Y,1), disgust), :);
topX = topX(setdiff(1:size(Y,1), disgust), :);
bottomX = bottomX(setdiff(1:size(Y,1), disgust), :);
testY = Y(setdiff(1:size(Y,1), disgust));

subplot(3,2,1);
pred_Y = MDL_predict(MDL, X, s, o);
confusion_matrix(pred_Y, testY, sprintf('confusionSVMwhole%s-s%d-o%d.png', d, s, o), sprintf('Confusion Whole SVM%s-s%d-o%d', d, s, o));

subplot(3,2,5);
% top BLURRED. my bad
pred_Y2 = MDL_predict(MDL, topX, s, o);
confusion_matrix(pred_Y2, testY, sprintf('confusionSVMbottom%s-s%d-o%d.png', d, s, o), sprintf('Confusion Bottom SVM-s%d-o%d', s, o));

subplot(3,2,3);
pred_Y3 = MDL_predict(MDL, bottomX, s, o);
confusion_matrix(pred_Y3, testY, sprintf('confusionSVMtop%s-s%d-o%d.png', d, s, o), sprintf('Confusion Top SVM-s%d-o%d', s, o) );

