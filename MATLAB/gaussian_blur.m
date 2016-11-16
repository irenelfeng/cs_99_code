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
    [~,num,ext] = fileparts(file.name);
    num = str2num(num);
    im_mean = mean(im(:));
    rows = size(im,1);
    % do not use a sigma more than half the width. 
    step = .5;
    num_bars = 8;
    bar_size = rows/(num_bars); 
    blurs = step:step:step*num_bars/2; % number of blurs = half the number of bars 
    % pad rows - TODO: possibly make a better pad
    im_padded = cat(1, repmat(im_mean, floor(f_width/2), size(im, 2)), im, ... 
        repmat(im_mean, floor(f_width/2), size(im, 2)));
    % pad columns
    im_padded = cat(2, repmat(im_mean, size(im_padded, 1), floor(f_width/2)), im_padded, ...
        repmat(im_mean, size(im_padded, 1), floor(f_width/2)));
    
    for sigma=1:length(blurs)
        oneDgauss = exp(-(((1:f_width)-ceil(f_width/2)).^2)/(2*blurs(sigma)^2));
        twoDgauss = oneDgauss'*oneDgauss;
        twoDgauss = twoDgauss/(sum(twoDgauss(:)));
        im_blurred(:,:,sigma) = conv2(double(im_padded), twoDgauss, 'valid');
    end

    im_bottom_blur = zeros(size(im));
    for bar=0:num_bars-1
        % top half clear
        if(bar < num_bars/2)
            im_bottom_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im(1+bar_size*bar:bar_size+bar_size*bar, :);
        else
            im_bottom_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im_blurred(1+bar_size*bar:bar_size+bar_size*bar, :, bar-num_bars/2+1);
        end
    end
    
    im_top_blur = zeros(size(im));
    for bar=0:num_bars-1
        % bottom half clear
        if(bar >= num_bars/2)
            im_top_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im(1+bar_size*bar:bar_size+bar_size*bar, :);
        else
            % not very blurry for eyes (since the eyes are the 3rd bar
            % really) so i made it increase by 1
            im_top_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im_blurred(1+bar_size*bar:bar_size+bar_size*bar, :, min(num_bars/2-bar+1, num_bars/2));
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
