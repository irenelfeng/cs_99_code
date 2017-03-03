% MMI load without disgust for nonCNN 
directory = '../../mmi/face_detected';
files = dir([directory,'/','*.png']);
X = zeros(0, 128*128); 
new_Y = [];
load('data/MMI_Y.mat');
c = 1;
disgust_count = 0;
prev_disgust = 0;
% try to get 194 digsut faces total
for file = files'
    if Y(c) == 1 % disgust
        m = strsplit(file.name, '.');
        num = strsplit(m{1}, '_');
        
        if str2double(num{end}) > 25
            if disgust_count < 170  % try to get another face
                c = c+1;
                continue
            end
        end
        if disgust_count >= 194
            c = c+1;
            continue
        end
        disgust_count = disgust_count + 1;
        prev_disgust = 1;
    end
    
    im = imread([directory,'/',file.name]);
    noncnnim = imresize(rgb2gray(im), [128,128]);
    noncnnim = noncnnim'; % flip 
    X(end+1,:) = noncnnim(:);
    % new_Y(end+1) = Y(c);
    c  = c + 1;
end

save data/MMI_128rmDisgustX.mat X
% Y = new_Y;
% save data/MMI_rmDisgustY.mat Y 