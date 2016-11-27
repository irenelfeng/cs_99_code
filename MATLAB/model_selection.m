% input: 
% sizes vector (how many sizes you want to try)
% orientations vector (how many orientations you want to try)
% N = how many cross-validation runs
% type = right now 'LDA' or 'SVM' 
% output: 
% si = number of sizes best fit
% or = number of orientations best fit 
% comps = PCA components reduced to
function [MDL, si, or, comps] = model_selection(X, Y, sizes, orientations, N, type)
    if nargin < 5
        sizes = 1:3; 
        orientations = [4,8]; 
        N = 10;
        comps = 0;
    end
    
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
            features = zeros(size(X, 1), s*o*100*2); % grid size * 2. 
            for i=1:size(X,1)
                features(i, :) = image_features(X(i,:), s, o)'; % call image features 
            end
            
            errors = zeros(N, 1);
            for k=0:N-1
                
                kth = floor(m / N * k + 1) : floor(m / N * (k + 1)); % gets indices of kth test set
                % get indices for testing and training
                test_idxes = idxperm(kth); % these are the indices of X and Y that serve to be test
                train_idxes = idxperm(setdiff(1:m, kth));
                
                trainX = features(train_idxes,:);
                trainY = Y(train_idxes);
                
                % do PCA on these features 
%                 [~, pca_features, resid] = bestPCA(trainX);
                
                size(features)
                if (strcmp(type, 'LDA') == 1)
                    MDL = train_Mc_LDA(trainX, trainY);
                elseif (strcmp(type, 'SVM') == 1)
                    MDL = train_Mc_SVM(trainX, trainY);
                else 
                    disp('Sorry, model type not recognized');
                    MDL = 'error';
                    si = 'error';
                    or = 'error';
                    k = 'error';
                    return
                end
                              
                testX = X(test_idxes,:);
                testY = Y(test_idxes);
                test_features = features(test_idxes, :); % grid size * 2. 
%                 % need to select the same number of features for pca
%                 [~, points] = pca(test_features);
%                 test_features_pca = points(:, size(pca_features, 2));

                pred_Y = zeros(size(testY));
                for i=1:length(pred_Y)
                    pred_Y(i) = predict(MDL, test_features(i,:));
                end
          
                % error - overall misclassification rate.
                sprintf('error calculated for run %d of sizes = %d, ors = %d', k, s, o); 
                errors(k+1) = sum(testY - pred_Y ~= 0)/(length(pred_Y)); % counting how many don't == 0 (correct class)
                
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
    features = zeros(size(X, 1), si*or*100*2); % grid size * 2. 
    for i=1:size(X,1)
        features(i, :) = image_features(X(i,:), si, or)'; % call image features on each file 
    end
    
    %[comps,pca_features, resid] = bestPCA(features);
    %% retrain with these features

    sprintf('%s sizes and %s orientations and reduced to %s PCA components', si, or, k);
    if (strcmp(type, 'LDA') == 1)
        MDL = train_Mc_LDA(features, Y);
    elseif (strcmp(type, 'SVM') == 1)
        MDL = train_Mc_SVM(features, Y);
    end 
       
end
