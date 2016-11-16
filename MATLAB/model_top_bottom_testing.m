% test existing model with top blur and bottom blur 
 
% loads existing model MDL here
s=2;
o=8;
load(sprintf('MDLs%do%d.mat', s, o));

load('topX.mat');
load('bottomX.mat');
load('Y.mat');

d = date;
disgust = find(Y==1);
testY = Y(setdiff(1:size(Y,1), disgust));

for i=0:1 % top = 0, bottom = 1 
    if (i == 0)
        pred_Y = MDL_predict(MDL, topX, s, o);
        confusion_matrix(pred_Y, testY, sprintf('confusiontop%s-s%ds-o%d.png', d, s, o));
    else
        pred_Y = MDL_predict(MDL, bottomX, s, o);
        confusion_matrix(pred_Y, testY, sprintf('confusionbottom%s-s%ds-o%d.png', d, s, o));
    end
    
end
