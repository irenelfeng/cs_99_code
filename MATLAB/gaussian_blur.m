addpath('helperfuncs');
% Spatially varying Gaussian Blur 
% both bottom_blur and top_blur and saves it into X_top and X_bottom
% matrices

% UNCOMMENT FOR OLD FER STUFF
% loop through all the files
% directory = 'fer2013imgs/original';

% files = dir([directory,'/','*.*g']);
% length(files')
% topX = zeros(length(files'),2304);
% bottomX = zeros(length(files'),2304);

% UNCOMMENT THESE 4 LINES FOR DOING ALL THE CNN IMAGES
directory = '../../CNN_48_images'; 
mkdir(directory,'/top');
mkdir(directory,'/bottom');
files = glob([directory,'/**.*G']);

for file = files'
    if ~isempty(strfind(file{1}, 'val')) || ~isempty(strfind(file{1}, 'bottom')) || ~isempty(strfind(file{1}, 'top'))
        continue
    end
    im =imread(file{1}); 
    if size(im, 3) == 3
        im = rgb2gray(im);
    end
    [root, name, ext] = fileparts(file{1}); 
    parts = strsplit(root, '/'); 
    folder = parts(end); % cell
    % im = imread([directory,'/',file.name]);
    % [~,num,ext] = fileparts(file.name);
    % num = str2num(num);
    
    % UNCOMMENT THESE FOUR LINES FOR BLURRING THE NONCNN STUFF
    % load('data/nonFER128X.mat'); 
    % 
    % for file = 1:size(X,1)
    %     im = reshape(X(file,:), [128, 128])';
    % imagesc(im);
    
    [im_top_blur, im_bottom_blur] = blur_image(im);
    
    % imwrite(uint8(im_top_blur),['fer2013imgs/topblur/',file.name]);
    % imwrite(uint8(im_bottom_blur),['fer2013imgs/bottomblur/',file.name]);
    imwrite(uint8(im_top_blur),sprintf('%s/bottom/%s/%s%s',directory,folder{1},name,ext));
    imwrite(uint8(im_bottom_blur),sprintf('%s/top/%s/%s%s',directory,folder{1},name,ext));
    % add to X.mat 
%     im_top_blur = im_top_blur'; % store it column wise because stupid
%     im_bottom_blur = im_bottom_blur'; % store it column wise because stupid
%     bottomX(file,:) = im_top_blur(:);  
%     topX(file,:) = im_bottom_blur(:);
    
end

% save topX.mat topX
% save bottomX.mat bottomX