% INPUT: X - features [m*n], Y - predictions [m*1]
% OUTPUT: MDL 
function MDL = train_Mc_LDA(X, Y)
    MDL = fitcdiscr(X,Y); 
end