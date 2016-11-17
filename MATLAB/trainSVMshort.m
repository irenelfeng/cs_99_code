% train an SVM. too lazy for the cross val. 
si = 2;
or = 8;
load('X.mat'); % images
load('Y.mat');  % labels
disgust = find(Y==1);
% remove all disgust indexes Y==1
trainX = X(setdiff(1:28709, disgust),:);
trainY = Y(setdiff(1:28709, disgust));
testX = X(setdiff(28710:32299, disgust),:);
testY = Y(setdiff(28710:32299, disgust));

features = zeros(size(trainX, 1), si*or*100*2); % grid size * 2. 
for i=1:size(X,1)
    features(i, :) = image_features(X(i,:), si, or)'; % call image features on each file 
end

disp('finished creating features!')

%% train with these features 
MDL = train_Mc_SVM(features(setdiff(1:28709, disgust),:), trainY);
save(sprintf('MDL_SVMs%do%d', si, or), 'MDL');

predY = MDL_predict(MDL, testX, si, or);
error = sum(testY - predY ~= 0)/(length(predY))
confusion_matrix(predY, testY, sprintf('confusionSVM%s-s%ds-o%d.png', d, si, or), sprintf('SVM Whole, s%ds-o%d', si, or));


    