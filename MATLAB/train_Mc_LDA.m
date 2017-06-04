% INPUT: X - features [m*n], Y - predictions [m*1]
% OUTPUT: MDL 
function MDL = train_Mc_LDA(X, Y)
    MDL = fitcdiscr(X,Y); 
    % I mean maybe it can be with Adaboost, 
    % t = templateDiscriminant('DiscrimType','linear');
    % temp = templateEnsemble('AdaboostM1', 100, 'tree');
    % MDL = fitcecoc(X, Y, 'Learners', 'discriminant', t);
    % i don't think this is what we want to do lol 

end