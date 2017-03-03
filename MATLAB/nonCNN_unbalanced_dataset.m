% create nonCNN 48x48 dataset by stacking everything 
total_X = [];
total_Y = []; 
load('data/ADFES_rmDisgustX.mat');
load('data/ADFES_rmDisgustY.mat');

total_X = X; 
total_Y = Y;
load('data/CK_X.mat');
load('data/CK_Y.mat');
X = ck_X;
total_X = [total_X; X];
total_Y = [total_Y; Y'];

load('data/Dartmouth_X.mat');
load('data/Dartmouth_Y.mat');

total_X = [total_X; X];
total_Y = [total_Y; Y'];

load('data/KDEF_X.mat');
load('data/KDEF_Y.mat');

total_X = [total_X; X];
total_Y = [total_Y; Y'];

load('data/MMI_rmDisgustX.mat');
load('data/MMI_rmDisgustY.mat');

total_X = [total_X; X];
total_Y = [total_Y; Y'];

idxperm = randperm(length(total_X));
X = total_X(idxperm,:);
Y = total_Y(idxperm);

save data/nonFERX.mat X
save data/nonFERY.mat Y

