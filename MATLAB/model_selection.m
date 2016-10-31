% input: 
% sizes vector (how many sizes you want to try)
% orientations vector (how many orientations you want to try)
% output: 
function [MDL, s, o] = model_selection(X, Y, sizes, orientations, N)
    if nargin < 5
        sizes = 1:3; 
        orientations = [4,8]; 
        N = 10;
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
            errors = zeros(N, 1);
            for k=0:N-1
                
                kth = floor(m / N * k + 1) : floor(m / N * (k + 1));
                
                idxes = idxperm(kth); % these are the indices of X and Y that serve to be test
                %% train everything but those elements
                train_idxes = idxperm(setdiff(1:m, kth));
                trainX = X(train_idxes,:);
                features = zeros(size(trainX, 1), s*o*100*2); % grid size * 2. 
                for i=1:size(trainX,1)
                    features(i, :) = image_features(trainX(i,:), s, o)'; % call image features 
                end
                trainY = Y(train_idxes);
                % train
                
                % MDL = train_Mc_SVM(features, trainY);
                MDL = train_Mc_LDA(features, trainY);
                              
                testX = X(idxes,:);
                testY = Y(idxes);
                test_features = zeros(size(testX, 1), s*o*100*2); % grid size * 2. 
                % predict
                for i=1:size(testX,1)
                    test_features(i, :) = image_features(testX(i,:), s, o)';
                    % call image features on each file 
                end
                pred_Y = zeros(size(testY));
                for i=1:length(pred_Y)
                    pred_Y(i) = predict(MDL, test_features(i,:));
                end
          
                % error - overall misclassification rate.
                errors(i) = sum(testY - pred_Y ~= 0)/m; % counting how many don't == 0 (correct class)
                
            end
            % get mean and get error
            error(count) = mean(errors);
            sprintf('finished with %dth run ', count)
            count = count+1; 
        end
    end
    
    % get the index with smallest error 
    error
    %% reget gabor-jet features with least error: 
    [m,idx] = min(error);
    si = sizes(ceil(idx/length(sizes))); % get the size at the index of error
    or = orientations(mod(idx-1, length(orientations))+1);% get the orientations
    features = zeros(size(X, 1), si*or*100*2); % grid size * 2. 
    for i=1:size(X,1)
        features(i, :) = image_features(X(i,:), si, or)'; % call image features on each file 
    end
     
    %% retrain with these features 
    MDL = train_Mc_SVM(features, Y);
    fprintf('%s sizes and %o orientations', s, o);
    
end