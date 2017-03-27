function [im_top_blur, im_bottom_blur] = blur_image(im)
    spatial = 1; % toggle 0 or 1 if you want there to be spatial differences
    f_width = 15; % needs to be an odd number
    im_mean = mean(im(:));
    rows = size(im,1);
    % do not use a sigma more than half the width. 
    step = 0.5;
    num_bars = 8;
    bar_size = rows/(num_bars); 
    blurs = step:step:step*num_bars/2; % number of blurs = half the number of bars 
    % pad rows - TODO: possibly make a better pad - currently padding with
    % mean intensity of image
    im_padded = cat(1, repmat(im_mean, floor(f_width/2), size(im, 2)), im, ... 
        repmat(im_mean, floor(f_width/2), size(im, 2)));
    % pad columns
    im_padded = cat(2, repmat(im_mean, size(im_padded, 1), floor(f_width/2)), im_padded, ...
        repmat(im_mean, size(im_padded, 1), floor(f_width/2)));
    
    for sigma=1:length(blurs)
        oneDgauss = exp(-(((1:f_width)-ceil(f_width/2)).^2)/(8*blurs(sigma)^2));
        % this is in the spatial domain 
        twoDgauss = oneDgauss'*oneDgauss; % cross product
        twoDgauss = twoDgauss/(sum(twoDgauss(:)));
        im_blurred(:,:,sigma) = conv2(double(im_padded), twoDgauss, 'valid');
        % what we could do instead of convolution is multiplication in fourier 
    end

    im_bottom_blur = zeros(size(im));
    for bar=0:num_bars-1
        % top half clear
        if(bar < num_bars/2)
            im_bottom_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im(1+bar_size*bar:bar_size+bar_size*bar, :);
        else
            if spatial == 1
                % as bar increases, blur increases.
                im_bottom_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im_blurred(1+bar_size*bar:bar_size+bar_size*bar, :, bar-num_bars/2+1);
            else
                % just the blurriest
                im_bottom_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im_blurred(1+bar_size*bar:bar_size+bar_size*bar, :, length(blurs));
            end
        end
    end
    
    im_top_blur = zeros(size(im));
    for bar=0:num_bars-1
        % bottom half clear
        if(bar >= num_bars/2)
            im_top_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im(1+bar_size*bar:bar_size+bar_size*bar, :);
        else
            if spatial  == 1
            % for bars 0 to num_bars/2 - 1, bar 0 gets the most blur
                im_top_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im_blurred(1+bar_size*bar:bar_size+bar_size*bar, :, num_bars/2-bar);
            else
                % just the blurriest
                im_top_blur(1+bar_size*bar:bar_size+bar_size*bar, :) = im_blurred(1+bar_size*bar:bar_size+bar_size*bar, :, length(blurs));
            end
        end
    end

end