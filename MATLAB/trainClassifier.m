% given X, Y, returns model and confusion matrix 
% calls model_selection.m, confusion_matrix.m
% change this line from LDA to SVM
type = 'LDA';
mode = 'whole'; % whole, top, bottom, local, global, blurred_top_, blurred_bottom_.
foveated = 0;
% gets date 
d = date; 

% X and Y
if isempty(strfind(mode, 'blurred_'))
    load('data/128X.mat');
else 
    if ~isempty(strfind(mode, 'bottom'))
        load('data/bottom128X.mat');
        X = bottomX;
    else
        load('data/top128X.mat');
        X = topX;
    end
end
load('data/128Y.mat');
train = floor(9/10*size(X,1));
trainX = X(1:train,:);
trainY = Y(1:train);
testX = X(train+1:size(X,1), :);
testY = double(Y(train+1:size(X,1)));

% comment next 1 and then uncomment next two if you want to specify
[MDL, s, o, comps] = model_selection(trainX, trainY, [2:5], 6, 5, type, mode, foveated);
s = 3;
o = 8;
features = [];
for i=1:size(trainX,1)
    features = [features; image_features(trainX(i,:), s, o, mode, foveated)']; % call image features 
end 
% FOR LDA/PCA: also uncomment below lines if you want to specify comps. ran this. super similar 
if strcmp(type, 'LDA') == 1 
    [comps, points, resid] = bestPCA(features); 
    % [comps, points, resid] = pca(features); 
    % or just regular pca if you know how many
    
    MDL = train_Mc_LDA(points,trainY);
    predY = MDL_predict(MDL, testX, s, o, mode, foveated, comps(:,1:159), mean(features));
    f = '';
    if foveated == 1
        f = '_foveated';
    end
    save(sprintf('MDLcomps%s_%s_nonFERs%ss%do%d', f, mode, type, s, o), 'comps');
else 
    MDL = traitrainClassifiern_Mc_SVM(features,trainY);
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