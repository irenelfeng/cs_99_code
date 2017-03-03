% after face detection
% loads CK images as image vectors. ugh oh no they are different sizes.
% OUTPUT: X, Y of all the image intensities + emotion label. 

% only some of the emotions are validated. only get those 327 images. 
% 309 without contempt

% directory = '../../cohn-kanade-plus/cohn-kanade/face_detected';
% molladir = '../../cohn-kanade-plus/cohn-kanade/for-molla';
directory = '../../mmi/face_detected';
molladir = '../../mmi/for_molla/';
% directory = '../../ADFES/face_detected';
% molladir = '../../ADFES/for_molla';

mkdir(molladir);
files = dir([directory,'/','*.*g']);
c = 1;
X = zeros(length(files'), 48*48); 
for file = files'
    im = imread([directory,'/',file.name]);
    cnnim = imresize(im, [48,48]);
    imwrite(cnnim, [molladir,'/',file.name]); % they gotta be resized!!
    noncnnim = imresize(im, [48, 48]); %can change size?
    noncnnim = noncnnim'; % flip 
    X(c,:) = noncnnim(:); 
    c  = c + 1;
end

save data/MMI_X.mat X 


    
