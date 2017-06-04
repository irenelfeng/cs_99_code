function MDL = train_Ada(X, Y)
    temp = templateEnsemble('AdaboostM1', 100, 'tree');
    MDL = fitcecoc(X, Y,  'Coding', 'onevsall', 'Learners', temp);
    % let's make sure it is linear -> use 'discriminant' for discriminant analysis
    % if we do t=templateSVM(); and 'Learners', t, it is supposed to be
    % default kernel function as linear. but it takes a damn ass long time.

end