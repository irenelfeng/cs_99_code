s = 1;
o = 4;
trainX = X(1:2000,:);
trainY = Y(1:2000,:);
train_features = zeros(size(trainX, 1), s*o*100*2); % grid size * 2. 
for i=1:size(trainX,1)
    train_features(i, :) = image_features(trainX(i,:), s, o)'; % call image features 
end

MDL = fitcdiscr(train_features, trainY);
MDL2 = train_Mc_SVM(train_features, trainY);
features = zeros(size(trainX, 1), s*o*100*2); % grid size * 2. 
for i=1:size(trainX,1)
    features(i, :) = image_features(trainX(i,:), s, o)'; % call image features 
end

testX = X(3000:4000,:);
testY = Y(3000:4000);
test_features = zeros(size(testX, 1), s*o*100*2); % grid size * 2. 
% predict
for i=1:size(testX,1)
    test_features(i, :) = image_features(testX(i,:), s, o)';
    % call image features on each file 
end
pred_Y = zeros(size(testY));
pred_Y2 = zeros(size(testY));
for i=1:length(pred_Y)
    pred_Y(i) = predict(MDL, test_features(i,:));
    pred_Y2(i) = predict(MDL, test_features(i,:));
end

% error - overall misclassification rate.
errors = sum(testY - pred_Y ~= 0)/length(testY);
errors = sum(testY - pred_Y2 ~= 0)/length(testY);