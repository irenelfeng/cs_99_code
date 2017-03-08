% given X, Y, returns model and confusion matrix 
% calls model_selection.m, confusion_matrix.m
% change this line from LDA to SVM
type = 'LDA';
halve = 'top'; % whole, top, or bottom. 
% gets date 
d = date; 

% X and Y
load('data/nonFER128X.mat');
%load('topX.mat'); % images
%load('bottomX.mat');
load('data/nonFER128Y.mat');
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


% comment next 1 and then uncomment next two if you want to specify
%[MDL, s, o, comps] = model_selection(trainX, trainY, 3, 8, 5, type, halve);
% s = 3;
% o = 8;
features = [];
for i=1:size(trainX,1)
    features = [features; image_features(trainX(i,:), s, o, halve)']; % call image features 
end 
% also uncomment this if you want to specify comps. ran this. super similar 
[comps, points, resid] = bestPCA(features); % or bestPCA
MDL = train_Mc_LDA(points,trainY);
% predY = MDL_predict(MDL, testX, s, o, halve, comps(:,1:79), mean(features));

predY = MDL_predict(MDL, testX, s, o, halve, comps, mean(features));
save(sprintf('compsp128f1_%s_nonFER_PCAss%do%d', halve, type, s, o), 'comps');
save(sprintf('MDLp128f1_%s_nonFER_PCAss%do%d', halve, type, s, o), 'MDL');
confusion_matrix(predY, testY, sprintf('confusion%sTrainedNonFER%s-s%d-o%d%s128pf1.fig', halve, type, s, o,d), ...
                sprintf('Confusion %sTrained NonFER%s-s%d-o%d', halve, type, s, o));