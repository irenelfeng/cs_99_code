% Spatially varying Gaussian Blur 
% both bottom_blur and top_blur and saves it into X_top and X_bottom
% matrices

% UNCOMMENT FOR OLD FER STUFF
% loop through all the files
% directory = 'fer2013imgs/original';

% files = dir([directory,'/','*.*g']);
% length(files')


% UNCOMMENT THESE TO MAKE topX and bottomX! 
% load('data/128X.mat');
% top128X = zeros(length(files'),128*128);
% bottom128X = zeros(length(files'),128*128);
% 
% for file = 1:size(X,1)
%     
%     im = reshape(X(file,:), [128, 128])';

% UNCOMMENT THESE ALL THESE LINES FOR DOING ALL THE CNN IMAGES
% directory = '../../CNN_48_images'; 
% mkdir(directory,'/top');
% mkdir(directory,'/bottom');
% files = glob([directory,'/**.*G'], '-ignorecase');

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
    
% END CNN stuff
    [im_top_blur, im_bottom_blur] = blur_image(im);
    
     %imwrite(uint8(im_top_blur),['fer2013imgs/topblur/',file.name]);
     %imwrite(uint8(im_bottom_blur),['fer2013imgs/bottomblur/',file.name]);
     imwrite(uint8(im_top_blur),sprintf('%s/bottom/%s/%s%s',directory,folder{1},name,ext));
     imwrite(uint8(im_bottom_blur),sprintf('%s/top/%s/%s%s',directory,folder{1},name,ext));
    
% add to X.mat 
%     im_top_blur = im_top_blur'; % store it column wise because stupid
%     im_bottom_blur = im_bottom_blur'; % store it column wise because stupid
%     bottom128X(file,:) = im_top_blur(:);  
%     top128X(file,:) = im_bottom_blur(:);
    
end

% save top128X.mat top128X
% save bottom128X.mat bottom128X