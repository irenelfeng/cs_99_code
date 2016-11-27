function [ predY ] = MDL_predict( MDL, testX, s, o, comps)
    
    predY = zeros(size(testX,1),1);
    features = zeros(size(testX,1), s*o*100*2);
    % fill in predY based on features
    for i=1:size(testX,1)
        features(i,:) = image_features(testX(i,:), s, o)'; 
    end
    f_mean = mean(features);
    if nargin >= 5
        % now project the test points into space by multiplying the components by
        % the new points 
        % make sure that the new points are zero-meaned 
        test_features = (features - repmat(f_mean, size(features, 1),1))*comps;
    else
        % no components
        test_features = features;
    end
    
    for i=1:size(testX,1)
        predY(i) = predict(MDL, test_features(i,:));
    end
       
end

