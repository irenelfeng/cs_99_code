% ADFES load without disgust for nonCNN 

ADFES_name = {'Anger', 'Disgust', 'Fear', 'Joy', 'Neutral', 'Sad', 'Surprise'};
labels = 0:6;
ADFES_map = containers.Map(ADFES_name, labels);
directory = '../../ADFES/face_detected';
files = dir([directory,'/','*.jpg']);
X = zeros(22*7+455, 128*128); 
Y = zeros(22*7+455, 1);
c = 1;
disgust_count = 0;
prev_disgust = 0;
% need to take away 1767 pictures to get 456 + 22 disgust (apex) = 478 total 
for file = files'
    if ~isempty(strfind(file.name, 'Embarrass')) || ...
        ~isempty(strfind(file.name, 'Contempt')) || ~isempty(strfind(file.name, 'Pride'))
        continue
    end
    if ~isempty(strfind(file.name, 'Forward'))
        m = strsplit(file.name, '.');
        num = strsplit(m{1}, '_');
        
        if str2double(num{end}) < 79
            if disgust_count < 440  % extra because we need 15 more
                continue
            end
        end
        if disgust_count > 455
            continue
        end
        disgust_count = disgust_count + 1;
        prev_disgust = 1;
    end
    
    emot = -1;
    for key = ADFES_name
        k = strfind(file.name,key);
        if ~isempty(k)
            emot = file.name(k:k+length(key{1})-1); % goddamn hate matlab
            break
        end
    end
    im = imread([directory,'/',file.name]);
    noncnnim = imresize(rgb2gray(im), [128,128]);
    noncnnim = noncnnim'; % flip 
    X(c,:) = noncnnim(:);
    Y(c) = ADFES_map(emot);
    c  = c + 1;
end
save data/ADFES_128rmDisgustX.mat X
