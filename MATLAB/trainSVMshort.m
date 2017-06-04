% train an SVM. can't wait for the crossval. 
si = 3;
or = 8;
load('X.mat'); % images
load('Y.mat');  % labels
disgust = find(Y==1);
% neutral = find(Y==6);

% remove all disgust + neutral indexes Y==1
trainX = X(setdiff(1:28709, disgust),:);
trainY = Y(setdiff(1:28709, disgust));
testX = X(setdiff(28710:32299, disgust),:);
testY = Y(setdiff(28710:32299, disgust));

features = zeros(size(trainX, 1), si*or*100*2); % grid size * 2. 
for i=1:size(X,1)
    features(i, :) = image_features(X(i,:), si, or)'; % call image features on each file 
end

%% train with these features 
MDL = train_Mc_SVM(features(setdiff(1:28709, disgust),:), trainY);
predY =  MDL_predict(MDL, testX, si, or);
% uncomment next 4 lines (and comment previous 2 lines)  if you want pca
% [comps, pca_features, resid] = bestPCA(features); 
% sprintf('reduced to %d features', size(comps,2))
% MDL = train_Mc_SVM(pca_features(setdiff(1:28709, disgust),:), trainY);
% save(sprintf('MDL_comp s%do%d', si, or), 'comps');
% predY = MDL_predict(MDL, testX, si, or, comps);

save(sprintf('MDL_SVMs%do%d', si, or), 'MDL'); % add PCA to line if you want PCA

error = sum(testY - predY ~= 0)/(length(predY));
confusion_matrix(predY, testY, sprintf('confusionSVMandPCA%s-s%ds-o%d.png', size(comps,2), si, or), sprintf('SVM Whole, s%ds-o%d', si, or));


    