function [ predY ] = MDL_predict( MDL, testX, s, o, halve, foveated, comps, f_mean) % need f_mean if doing principal components
    
    predY = zeros(size(testX,1),1);
    features = [];
    % fill in predY based on features
    for i=1:size(testX,1)
        features = [features; image_features(testX(i,:), s, o, halve, foveated )']; 
    end
    if nargin >= 7
        % now project the test points into space by multiplying the components by
        % the new points 
        % make sure that the new points are zero-meaned to the TRAINING set
        test_features = (features - repmat(f_mean, size(features, 1),1))*comps;
        
    end
    
    for i=1:size(testX,1)
        predY(i) = predict(MDL, test_features(i,:));
    end
       
end

