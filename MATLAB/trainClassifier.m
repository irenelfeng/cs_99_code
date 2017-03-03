% given X, Y, returns model and confusion matrix 
% calls model_selection.m, confusion_matrix.m
% change this line from LDA to SVM
type = 'SVM';

% gets date 
d = date; 

% X and Y
load('data/nonFERX.mat');
%load('topX.mat'); % images
%load('bottomX.mat');
load('data/nonFERY.mat');
%load('Y.mat');  % labels
% disgust = find(Y==1);
% neutral = find(Y==6);
disgust = [];
neutral = [];
% remove all disgust indexes Y==1
train = floor(9/10*size(X,1));
trainX = X(setdiff(1:train, [disgust; neutral]),:);
trainY = Y(setdiff(1:train, [disgust; neutral]));
testX = X(setdiff(train+1:size(X,1), [disgust; neutral]), :);
testY = double(Y(setdiff(train+1:size(X,1), [disgust;neutral])));
% testX = X(setdiff(28710:32299, [disgust; neutral]),:);
% testY = Y(setdiff(28710:32299, [disgust; neutral]));
% comment line if you want to do your own training


% comment next 1 and then uncomment next three if you want to specify
[MDL, s, o, comps] = model_selection(trainX, trainY, 3, 8, 5, type);
%s = 3;
%o = 8; 
%MDL = train_Mc_SVM(features,trainY);
%comps = 0;
features = zeros(size(trainX,1), s*o*200);
for i=1:size(trainX,1)
    features(i, :) = image_features(trainX(i,:), s, o)'; % call image features 
end  

predY = MDL_predict(MDL, testX, s, o, comps, mean(features));

save(sprintf('MDL_nonFER_PCA%ss%do%d', type, s, o), 'MDL');
confusion_matrix(predY, testY, sprintf('confusionWholeTrainedNonFER%s-s%d-o%d%s.png', type, s, o,d), ...
                sprintf('Confusion WholeTrained NonFER %s-s%d-o%d', type, s, o));