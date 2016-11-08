% make FER image folder puts all images into this folder 
% DEPENDENCIES: you need X.mat and Y.mat created from loadImages.m script 

load('X.mat');
load('Y.mat');

dir = 'fer2013imgs';
mkdir(dir); 

[m,n] = size(X);

for i=1:m 
    im = reshape(X(i,:), [48 48])';
    imwrite(im,colormap('gray'),[dir,'/',num2str(i),'.png']);
    ['Wrote image ', num2str(i)]
end

'Done with all images!';


