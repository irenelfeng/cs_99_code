% given X, Y, returns model and confusion matrix 
% calls model_selection.m, confusion_matrix.m
% change this line from LDA to SVM
type = 'LDA';
mode = 'top'; % whole, top, bottom, local, global, blurred_top_, blurred_bottom_.
foveated = 1;
% gets date 
d = date; 

% X and Y
if isempty(strfind(mode, 'blurred_'))
    load('data/nonFER128X.mat');
else 
    if ~isempty(strfind(mode, 'bottom'))
        load('data/bottom120X.mat');
        X = bottomX;
    else
        load('data/top120X.mat');
        X = topX;
    end
end
load('data/nonFER128Y.mat');
train = floor(9/10*size(X,1));
trainX = X(1:train,:);
trainY = Y(setdiff(1:train, [disgust; neutral]));
testX = X(setdiff(train+1:size(X,1), [disgust; neutral]), :);
testY = double(Y(setdiff(train+1:size(X,1), [disgust;neutral])));


% comment next 1 and then uncomment next two if you want to specify
% [MDL, s, o, comps] = model_selection(trainX, trainY, [2,3,5], 8, 5, type, mode);
s = 3;
o = 8;
features = [];
for i=1:size(trainX,1)
    features = [features; image_features(trainX(i,:), s, o, mode, foveated)']; % call image features 
end 
% FOR LDA/PCA: also uncomment below lines if you want to specify comps. ran this. super similar 

% predY = MDL_predict(MDL, testX, s, o, mode, comps(:,1:79), mean(features));
if strcmp(type, 'LDA') == 1 
    % [comps, points, resid] = bestPCA(features); 
    [comps, points, resid] = bestPCA(features); 
    % or just regular pca if you know how many
    
    MDL = train_Mc_LDA(points,trainY);
    predY = MDL_predict(MDL, testX, s, o, mode, foveated, comps, mean(features));
    save(sprintf('MDLcomps_%s_nonFERs%ss%do%d', mode, type, s, o), 'comps');
else 
    predY = MDL_predict(MDL, testX, s, o, mode, foveated);
end

if foveated == 1
    save(sprintf('MDL_foveated_%s_%s_nonFERss%do%d', mode, type, s, o), 'MDL');
    confusion_matrix(predY, testY, sprintf('confusion%sTrainedFoveatedNonFER%s-s%d-o%d.fig', mode, type, s, o), ...
                sprintf('Confusion %sTrained Foveated NonFER%s-s%d-o%d', mode, type, s, o));
else
    save(sprintf('MDL_%s_%s_nonFERss%do%d', mode, type, s, o), 'MDL');
    confusion_matrix(predY, testY, sprintf('confusion%sTrainedNonFER%s-s%d-o%d.fig', mode, type, s, o), ...
                sprintf('Confusion %sTrained NonFER%s-s%d-o%d', mode, type, s, o));
end