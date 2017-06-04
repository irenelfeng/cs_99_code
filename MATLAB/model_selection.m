% input: 
% sizes vector (how many sizes you want to try)
% orientations vector (how many orientations you want to try)
% N = how many cross-validation runs
% type = right now 'LDA' or 'SVM' 
% output: 
% si = number of sizes best fit
% or = number of orientations best fit 
% comps = PCA components reduced to
function [MDL, si, or, comps] = model_selection(X, Y, sizes, orientations, N, type, halve, foveated)
    if nargin < 5
        sizes = 1:3; 
        orientations = [4,8]; 
        N = 10;
    end
    comps = 0;
    
    rand('twister', 0);
    m = size(X,1);
    idxperm = randperm(m);
    
    error = zeros(length(sizes)*length(orientations),1); % s*o vector for s sizes and o orientations
    count = 1;
    %% change how many features we want
    for s=sizes
        for o=orientations
            %% do N cross validation
            % get features for X
            features = []; % oh no it's no longer grid size * 2. 
            for i=1:size(X,1)
                features = [features; image_features(X(i,:), s, o, halve, foveated)']; % call image features 
            end
            
            errors = zeros(N, 1);
            for k=0:N-1
                
                kth = floor(m / N * k + 1) : floor(m / N * (k + 1)); % gets indices of kth test set
                % get indices for testing and training
                test_idxes = idxperm(kth); % these are the indices of X and Y that serve to be test
                train_idxes = idxperm(setdiff(1:m, kth));
                testY = Y(test_idxes);
                test_features = features(test_idxes, :); 
                
                pred_Y = zeros(size(testY));
                trainX = features(train_idxes,:);
                trainY = Y(train_idxes);
                % I test by taking the test_features -
                % mean(train) * comps, to get the new points in the new
                % feature space... oh yeah. 
                feat_mean = mean(trainX); 
                
                if (strcmp(type, 'LDA') == 1)
                    % do PCA on these features 
                    pca_features = trainX; 
                    % comment below if you don't want to do pca_features
                    [c, pca_features, resid] = bestPCA(trainX);
                    MDL = train_Mc_LDA(pca_features, trainY);
                    
                    test_features_pca = (test_features - repmat(feat_mean,size(test_features, 1), 1))*c;
                    for i=1:length(pred_Y)
                        pred_Y(i) = predict(MDL, test_features_pca(i,:));
                    end
                elseif (strcmp(type, 'SVM') == 1)
                    disp('SVM');
                    pca_features = trainX; 
                    % comment below if you don't want to do pca_features
                    [c, pca_features, resid] = bestPCA(trainX);
                    MDL = train_Mc_SVM(pca_features, trainY); 
                    test_features_pca = (test_features - repmat(feat_mean,size(test_features, 1), 1))*c;
                    for i=1:length(pred_Y)
                        pred_Y(i) = predict(MDL, test_features_pca(i,:));
                    end
                elseif (strcmp(type, 'Ada') == 1)
                    MDL = train_Ada(trainX, trainY); 
                    for i=1:length(pred_Y)
                        pred_Y(i) = predict(MDL, test_features(i,:));
                    end
                else 
                    disp('Sorry, model type not recognized');
                    MDL = 'error';
                    si = 'error';
                    or = 'error';
                    k = 'error';
                    return
                end
                              
                % error - overall misclassification rate.
                sprintf('error calculated for run %d of sizes = %d, ors = %d', k, s, o)
                errors(k+1) = sum(double(testY) - pred_Y ~= 0)/(length(pred_Y)); % counting how many don't == 0 (correct class)
                
            end
            % get mean and get error
            error(count) = mean(errors);
            sprintf('finished with %dth run ', count);
            disp(error(count));
            count = count+1; 
        end
    end
    
    % get the index with smallest error 
    plot(1:length(error), error);
    error
    %% reget gabor-jet features with least error: 
    [m,idx] = min(error);
    si = sizes(ceil(idx/(length(orientations)))); % get the size at the index of error
    or = orientations(mod(idx-1, length(orientations))+1);% get the orientations
    features = []; 
    for i=1:size(X,1)
        features = [features ; image_features(X(i,:), si, or, halve, foveated)']; % call image features on each file 
    end
    
    %% retrain with these features

    sprintf('%s sizes and %s orientations', si, or);
    if (strcmp(type, 'LDA') == 1)
        [comps,pca_features, resid] = bestPCA(features);
        MDL = train_Mc_LDA(pca_features, Y);
    elseif (strcmp(type, 'SVM') == 1)
        [comps,pca_features, resid] = bestPCA(features);
        MDL = train_Mc_SVM(pca_features, Y);
    elseif (strcmp(type, 'Ada') == 1)
        MDL = train_Ada(features, Y);
    end 
       
end
