% INPUT: X - features [m*n], Y - predictions [m*1]
% OUTPUT: MDL 
function MDL = train_Mc_SVM(X, Y)
    MDL = fitcecoc(X, Y); 
end