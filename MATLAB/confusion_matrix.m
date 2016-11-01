function confusion_matrix(MDL, testX, testY, s, o)
    %% graph the test errors/confusion matrix 
    predY = size(testY);
    % fill in predY based on features
    for i=1:size(testX,1)
        predY(i) = predict(MDL, image_features(testX(i,:), s, o)');
    end
    matTestY = zeros(length(testY), range(testY)+1);
    matPredY = zeros(length(testY), range(testY)+1);
    for i=1:length(testY)
        j = testY(i)+1; %0-6 -> 1 to 7 
        matTestY(i, j) = 1;
        m = predY(i)+1; % 0-6 -> 1 to 7
        matPredY(i, m) = 1;
    end
        
    %% make testY and predY in matrix form 
    graph = plotconfusion(matTestY', matPredY'); % rows: output, cols:input 
    % Alternative is much cheaper, but no pretty graphics: confusionmat(testY, predY) rows: target, cols: output 
    save conf.png graph
   
end