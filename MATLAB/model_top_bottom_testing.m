% test existing model with top blur and bottom blur 

% loads existing model MDL here 
load('MDLs2o8.mat');

load('topX.mat');
load('bottomX.mat');
load('Y.mat');

d = date;
testY =Y; % all of Y serves as testing. gonna be a whole ton.  

for i=0:1 % top = 0, bottom = 1 
    if (i == 0)
        pred_Y = MDL_predict(MDL, topX, s, o);
        confusion_matrix(predY, testY, sprintf('confusiontop%s-s%ds-o%d.png', d, s, o));
    else
        pred_Y = MDL_predict(MDL, bottomX, s, o);
        confusion_matrix(predY, testY, sprintf('confusionbottom%s-s%ds-o%d.png', d, s, o));
    end
    
end
