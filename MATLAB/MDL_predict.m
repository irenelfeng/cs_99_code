function [ predY ] = MDL_predict( MDL, testX, s, o, comps)
    
    predY = size(testX,1);
    features = size(testX, s*o*100*2);
    % fill in predY based on features
    for i=1:size(testX,1)
        features(i) = image_features(testX(i,:), s, o)'; 
    end
    f_mean = mean(features);
    if nargin >= 4
        % now project the test points into space by multiplying the components by
        % the new points 
        % make sure that the new points are zero-meaned 
        test_features = comps*(features - repmat(f_mean, size(features, 1),1));
    else
        % no comps
        test_features = features;
    end
    
    for i=1:size(testX,1)
        predY(i) = predict(MDL, test_features(i,:));
    end
       
end

