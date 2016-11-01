% INPUT: X - features [m*n], Y - predictions [m*1]
% OUTPUT: MDL 
function MDL = train_Mc_SVM(X, Y)

    MDL = fitcecoc(X, Y, 'Learners', 'discriminant'); % DEFAULT: onevsone (who said it was better onevall
    % let's make sure it is linear -> use 'discriminant' for discriminant analysis
    % if we do t=templateSVM(); and 'Learners', t, it is supposed to be
    % default kernel function as linear. but it takes a damn ass long time.
    % so the discriminant thing might work out 

end