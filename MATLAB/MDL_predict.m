function [ predY ] = MDL_predict( MDL, testX, s, o )
    predY = size(testX,1);
    % fill in predY based on features
    for i=1:size(testX,1)
        predY(i) = predict(MDL, image_features(testX(i,:), s, o)');
    end
       
end

