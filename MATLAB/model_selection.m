function M = model_selection(sizes, orientations, N)
    if nargin < 3
        sizes = 5; 
        orientations = 8; 
        N = 10;
    end
    %% get all files
    X = {'cohn-kanade/S010/006/S010_006_01594629.png' 
        'cohn-kanade/S011/006/S011_006_03142202.png'
        'cohn-kanade/S014/005/S014_005_02405904.png'
        'cohn-kanade/S022/003/S022_003_00023018.png'
        'cohn-kanade/S026/006/S026_006_01384000.png'
        'cohn-kanade/S032/006/S032_006_01350405.png'
        'cohn-kanade/S034/005/S034_005_02293929.png'
        'cohn-kanade/S035/006/S035_006_02501919.png'
        'cohn-kanade/S037/006/S037_006_00234318.png'
        'cohn-kanade/S042/006/S042_006_01435709.png'
        %%'cohn-kanade/S044/003/S044_003_00044801.png'
        %% sad 
        'cohn-kanade/S010/002/S010_002_01593902.png'
        'cohn-kanade/S011/001/S011_001_03141509.png'
        'cohn-kanade/S014/001/S014_001_02405128.png'
        'cohn-kanade/S022/001/S022_001_00021417.png'
        'cohn-kanade/S026/001/S026_001_01383511.png'
        'cohn-kanade/S032/001/S032_001_01345811.png'
        'cohn-kanade/S034/001/S034_001_02293403.png'
        'cohn-kanade/S035/001/S035_001_02500816.png'
        'cohn-kanade/S037/001/S037_001_00233525.png'
        'cohn-kanade/S042/001/S042_001_01435126.png'
        %%'cohn-kanade/S044/001/S044_001_00044207.png'
        };
    Y = [0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 ];
    
    rand('twister', 0);
    m = size(X,1);
    idxperm = randperm(m);
    
    error = zeros(length(sizes)*length(orientations),1); % s*o vector for s sizes and o orientations
    count = 1;
    %% change how many features we want
    for s=sizes
        for o=orientations
            %% do N=10 cross validation
            errors = zeros(N, 1);
            for k=0:N-1
                
                kth = floor(m / N * k + 1) : floor(m / N * (k + 1));
                
                idxes = idxperm(kth); % these are the indices of X and Y that serve to be test
                %% train everything but those elements
                train_idxes = idxperm(setdiff(1:m, kth));
                trainX = X(train_idxes,:);
                features = zeros(size(trainX, 1), s*o*100*2); % grid size * 2. 
                for i=1:size(trainX,1)
                    features(i, :) = image_features(trainX(i), s, o)'; % call image features on each file 
                end
                trainY = Y(train_idxes);
                % train
                MDL = train_Mc_SVM(features, trainY);
                
                testX = X(idxes,:);
                testY = Y(idxes);
                test_features = zeros(size(testX, 1), s*o*100*2); % grid size * 2. 
                % predict
                for i=1:size(testX,1)
                    test_features(i, :) = image_features(testX(i), s, o)';
                    % call image features on each file 
                end
                pred_Y = size(Y);
                for i=1:length(pred_Y)
                    pred_Y(i) = predict(MDL, test_features(i,:));
                end
          
                % error - overall misclassification rate.
                errors(i) = sum(testY - pred_Y ~= 0)/m; % counting how many don't == 0 (correct class)
            end
            % get mean and get error
            error(count) = mean(errors);
            count = count+1; 
            sprintf('finished with %dth run ', s)
        end
    end
    
    %% graph the errors. 
    
    %% return the sizes and orientations with the lowest mean error. 
    
    
    
end