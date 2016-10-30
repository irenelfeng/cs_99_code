function confusion_matrix(MDL, testX, testY)
    %% graph the test errors/confusion matrix 
    predY = predict(MDL, testX);
    matTestY = zeros(length(testY), range(testY));
    matPredY = zeros(length(testY), range(testY));
    for i=1:length(testY)
        j = testY(i);
        matTestY(i, j) = 1;
        m = predY(i);
        matPredY(i, j) = 1;
    end
        
    %% make testY and predY in matrix form 
    graph = plotconfusion(matTestY, matPredY);
    save conf.png graph
   
end