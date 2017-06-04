% python spits out face detected images, i'm just saving it into a mat
% file. 

directory = 'fer2013imgs/face_detected';
files = dir([directory,'/','*.png']);

load('data/Y.mat'); % get corresponding Y vals
fregX = zeros(size(Y, 1), 2304); 
face_reg_files = zeros(length(files'),1);
c = 1;
for file = files'
    im = imread([directory,'/',file.name]);
    [~,num,ext] = fileparts(file.name);
    num = str2double(num);
    face_reg_files(c) = num;
    im = imresize(im, [48,48]);
    % imwrite(im, ['fer2013imgs/face_detected/',file.name]); % they gotta be resized!!
    % need to resize back to 48*48 
    im = im'; % i think you put them back in like this
    fregX(num,:) = im(:); 
    c = c + 1;
end

load('data/X.mat'); % just have to fill in failures with original images
unface_reg_files = setdiff(1:size(Y,1), face_reg_files);
fregX(unface_reg_files, :) = X(unface_reg_files, :);
save data/f_regX.mat fregX 