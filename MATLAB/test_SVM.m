function prediction = test_SVM(filepath, MDL)
    % call gabor jet stuff 
    x = image_features(filepath);
    prediction = predict(MDL, x');
end