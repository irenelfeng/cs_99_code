load('/Users/irenefeng/Documents/Computer_Social_Vision/cs_99_code/MATLAB/data/128X.mat');
% X.mat 
% okay we have X.mat . then what? umm just output that into some files. 
s = '../../CNN_48_images/MATLAB_val';
mkdir(s)
train = floor(9/10*size(X,1));
trainX = X(1:train,:);
testX = X(train+1:size(X,1), :);
for i = 1:size(testX, 1)
    im = reshape(testX(i,:), [128 128])';
    im = imresize(im, [48, 48])/255.0; 
    imwrite(im, sprintf('%s/%d.jpg', s, i))
end

