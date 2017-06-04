% create nonCNN 128x128 dataset by stacking everything 
total_X = [];
total_Y = []; 
load('data/ADFES_128rmDisgustX.mat');
load('data/ADFES_rmDisgustY.mat');

total_X = X; 
total_Y = Y;
load('data/CK_128X.mat');
load('data/CK_Y.mat');
total_X = [total_X; X];
total_Y = [total_Y; Y'];

load('data/Dartmouth256X.mat');
load('data/Dartmouth_Y.mat');

resized = zeros(size(X,1), 128*128);
for i = 1:size(X,1)
    m = reshape(X(i,:), [256, 256]);
    n = imresize(m, [128, 128]);
    resized(i,:) = n(:);
end
total_X = [total_X; resized];
total_Y = [total_Y; Y'];

load('data/KDEF_256X.mat');
load('data/KDEF_Y.mat');

resized = zeros(size(X,1), 128*128);
for i = 1:size(X,1)
    m = reshape(X(i,:), [256, 256]);
    n = imresize(m, [128, 128]);
    resized(i,:) = n(:);
end
total_X = [total_X; resized];
total_Y = [total_Y; Y'];

load('data/MMI_128rmDisgustX.mat');
load('data/MMI_rmDisgustY.mat');

total_X = [total_X; X];
total_Y = [total_Y; Y'];

idxperm = randperm(size(total_X, 1)); % randomly distribute X's 
X = total_X(idxperm,:);
Y = total_Y(idxperm);

save data/nonFER128X.mat X
save data/nonFER128Y.mat Y

