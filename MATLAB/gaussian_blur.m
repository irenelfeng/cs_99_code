% Spatially varying Gaussian Blur 
% both bottom_blur and top_blur and saves it into X_top and X_bottom
% matrices
f_width = 15; 

% loop through all the files
directory = 'fer2013imgs/original';
files = dir([directory,'/','*.png']);

length(files')
topX = zeros(length(files'),2304);
bottomX = zeros(length(files'),2304);
for file = files'
    im = imread([directory,'/',file.name]);
    [~,num,ext] = fileparts(file.name)
    num = str2num(num);
    im_mean = mean(im(:));
    rows = size(im,1);
    % do not use a sigma more than half the width. 
    step = .5;
    blurs = 1:step:ceil(f_width/4); % number of different sigmas
    % need one less of the number of sigmas because one is no blur
    bar_size = rows/(length(blurs)+1); 
    
    % pad rows - TODO: possibly make a better pad
    im_padded = cat(1, repmat(im_mean, floor(f_width/2), size(im, 2)), im, ... 
        repmat(im_mean, floor(f_width/2), size(im, 2)));
    % pad columns
    im_padded = cat(2, repmat(im_mean, size(im_padded, 1), floor(f_width/2)), im_padded, ...
        repmat(im_mean, size(im_padded, 1), floor(f_width/2)));
    
    count = 1;
    for sigma=blurs
        oneDgauss = exp(-(((1:f_width)-ceil(f_width/2)).^2)/(2*sigma^2));
        twoDgauss = oneDgauss'*oneDgauss;
        twoDgauss = twoDgauss/(sum(twoDgauss(:)));
        im_blurred(:,:,count) = conv2(double(im_padded), twoDgauss, 'valid');
        count = count+1;
    end

    im_bottom_blur = zeros(size(im));
    for bar=0:length(blurs)
        % top half clear
        if(bar < length(blurs)/2)
            im_bottom_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im(1+bar_size*bar:bar_size+bar_size*bar, :);
        else
            im_bottom_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im_blurred(1+bar_size*bar:bar_size+bar_size*bar, :, bar);
        end
    end
    
    im_top_blur = zeros(size(im));
    for bar=0:length(blurs)
        % bottom half clear
        if(bar > length(blurs)/2)
            im_top_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im(1+bar_size*bar:bar_size+bar_size*bar, :);
        else
            im_top_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im_blurred(1+bar_size*bar:bar_size+bar_size*bar, :, length(blurs)-bar);
        end
    end
    
    imwrite(uint8(im_top_blur),['fer2013imgs/topblur/',file.name]);
    imwrite(uint8(im_bottom_blur),['fer2013imgs/bottomblur/',file.name]);
   
    % add to X.mat 
    im_top_blur = im_top_blur'; % store it column wise because stupid
    im_bottom_blur = im_bottom_blur'; % store it column wise because stupid
    topX(num,:) = im_top_blur(:); % is it the same 
    bottomX(num,:) = im_bottom_blur(:);
    
end
