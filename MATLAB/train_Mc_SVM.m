function MDL = train_Mc_SVM(X, Y)
    MDL = fitcecoc(X, Y,  'Coding', 'onevsall');
end