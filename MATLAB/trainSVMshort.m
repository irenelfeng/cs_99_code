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
% get the mean for the features 
[comps, pca_features, resid] = bestPCA(features); 

disp('finished creating features!');

%% train with these features 
MDL = train_Mc_SVM(pca_features(setdiff(1:28709, disgust),:), trainY);
save(sprintf('MDL_SVMPCAs%do%d', si, or), 'MDL');
save(sprintf('MDL_comps%do%d', si, or), 'comps');

predY = MDL_predict(MDL, testX, si, or, comps);

error = sum(testY - predY ~= 0)/(length(predY));
confusion_matrix(predY, testY, sprintf('confusionSVMandPCA%s-s%ds-o%d.png', d, si, or), sprintf('SVM Whole, s%ds-o%d', si, or));


    