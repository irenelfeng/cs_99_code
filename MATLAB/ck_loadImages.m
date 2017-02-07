% loads CK images as image vectors. ugh oh no they are different sizes.
% OUTPUT: X, Y of all the image intensities + emotion label. 

% only some of the emotions are validated. only get those 327 images. 
% 309 without contempt

directory = '../cohn-kanade-plus/cohn-kanade/face_detected';
mkdir('../cohn-kanade-plus/cohn-kanade/for-molla');
files = dir([directory,'/','*.png']);
c = 1;
ck_X = zeros(length(files'), 2304); 
for file = files'
    im = imread([directory,'/',file.name]);
    im = imresize(im, [48,48]);
    imwrite(im, ['../cohn-kanade-plus/cohn-kanade/for-molla/',file.name]); % they gotta be resized!!
    im = im'; % flip 
    ck_X(c,:) = im(:); 
    c  = c + 1;
end
save data/CK_X.mat ck_X 


    
