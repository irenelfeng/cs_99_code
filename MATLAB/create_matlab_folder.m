% X.mat 
% okay we have X.mat . then what? umm just output that into some files. 
modes = {'bottom', 'top'}; % also '' for whole
for i=1:length(modes)
    if strcmp('bottom',modes{i}) == 1
       load('data/bottom128X.mat'); 
       X = bottomX;
    elseif strcmp('top', modes{i}) == 1
        load('data/top128X.mat'); 
        X = topX;
    else
       load('data/128X.mat');  
    end
    s = ['../../CNN_48_images/MATLAB_val', modes{i}]
    mkdir(s);
    train = floor(9/10*size(X,1));
    trainX = X(1:train,:);
    testX = X(train+1:size(X,1), :);
    for i = 1:size(testX, 1)
        im = reshape(testX(i,:), [128 128])';
        im = imresize(im, [48, 48])/255.0; 
        imwrite(im, sprintf('%s/%d.jpg', s, i))
    end
end

