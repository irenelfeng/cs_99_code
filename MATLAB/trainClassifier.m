% given X, Y, returns model and confusion matrix 
% calls model_selection.m, confusion_matrix.m
% change this line from LDA to SVM
type = 'LDA';
mode = 'top'; % whole, top, bottom, local, global, blurred_top, blurred_bottom.
foveated = 0; % 0 or 1, and mode has to be top or bottom.
cross_val = 0; % 0 or 1: whether you want to do cross validation or not (2:5 sizes, [6,8] orientations)

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

if cross_val == 1
    [MDL, s, o, comps] = model_selection(trainX, trainY, [2:5], 6, 5, type, mode, foveated);
else 
    s = 3;
    o = 8;
end
features = [];
for i=1:size(trainX,1)
    features = [features; image_features(trainX(i,:), s, o, mode, foveated)']; % call image features 
end 
if strcmp(type, 'ADA') == 1
    % no PCA for adaboost
    MDL = train_Ada(features,trainY);
    predY = MDL_predict(MDL, testX, s, o, mode, foveated);
else 
    % FOR LDA/PCA: also uncomment below lines if you want to specify comps. ran this. super similar 
    if strcmp(type, 'LDA') == 1 
        if cross_val == 0
            sprintf('not doing cross validation')
            [comps, points, resid] = bestPCA(features); 
            % [comps, points, resid] = pca(features); 
            % or just regular pca if you know how many

            MDL = train_Mc_LDA(points,trainY);
        end
        predY = MDL_predict(MDL, testX, s, o, mode, foveated, comps, mean(features));
    else 
        if cross_val == 0
            sprintf('not doing cross validation')
            MDL = train_Mc_SVM(features,trainY);
        end
        predY = MDL_predict(MDL, testX, s, o, mode, foveated);
    end
end
if foveated == 1
    save(sprintf('MDLcomps_foveated_%s_nonFERs%ss%do%d', mode, type, s, o), 'comps');
    save(sprintf('MDL_foveated_%s_%s_nonFERss%do%d', mode, type, s, o), 'MDL');
    confusion_matrix(predY, testY, sprintf('confusion%sTrainedFoveatedNonFER%s-s%d-o%d.fig', mode, type, s, o), ...
                sprintf('Confusion %sTrained Foveated NonFER%s-s%d-o%d', mode, type, s, o));
    
else
    save(sprintf('MDLcomps_%s_nonFERs%ss%do%d', mode, type, s, o), 'comps');
    save(sprintf('MDL_%s_%s_nonFERss%do%d', mode, type, s, o), 'MDL');
    confusion_matrix(predY, testY, sprintf('confusion%sTrainedNonFER%s-s%d-o%d.fig', mode, type, s, o), ...
               sprintf('Confusion %sTrained NonFER%s-s%d-o%d', mode, type, s, o));
end
