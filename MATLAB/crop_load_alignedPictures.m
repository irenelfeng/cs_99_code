% crop aligned images, then resize to min size we have 
% thank you for being good souls and aligning them.  
KDEF = 'KDEF'; 
% manipulated to flatten, mv all out of subdirectories (and FS.JPG - front facing)
DART = 'DartmouthWhalen/Dartmouth100'; 
db = {'KDEF','Dartmouth'};
directories = {KDEF, DART};
keys = {'Anger', 'ANS', 'Disgust', 'DIS','Fear', 'AFS', 'Happy', 'HAS', 'Neutral', 'NES', 'Sad', 'SAS','Surprise', 'SUS'};
vals = floor(0:0.5:6.5);
map = containers.Map(keys, vals);

crop_corners = [[80, 240, 400, 400];[330,450,1700, 1700]]; % dart done 
for i = 1:length(directories)
    X = [];
    Y = [];
    filenames = {};
    mkdir(['../../', directories{i}, '/face_detected']);
    
    files = dir(['../../', directories{i},'/*.jpg']);
    
    for file = files' 
        emot = 0;
        for key = keys
            k = strfind(file.name,key);
            if ~isempty(k)
                emot = file.name(k:k+length(key{1})-1); % goddamn hate matlab
                break
            end
        end
        
        if emot == 0 % skip if not any of the files we are looking for
            continue
        end
        im = imread(['../../',directories{i},'/',file.name]);
        arr = num2cell(crop_corners(i,:));
        [x, y, w, h] = arr{:}; % dumb matlab 
        cropped = im(y:y+h, x:x+w); % if we want third channel... add the  
        im_resized = imresize(cropped, [48, NaN]); % auto-resize
        % they gotta be resized!!
        imwrite(im_resized, ['../../',directories{i},'/face_detected/',file.name]); 
        
        % bw 
        % cropped = rgb2gray(cropped);
        nonCNN = imresize(cropped, [256, NaN]);
        nonCNN = nonCNN'; % flip 
        X(end+1,:) = nonCNN(:); 
        Y(end+1) = map(emot);
        filenames{end+1} = [directories{i},'/',file.name];
        file.name
    end
    
    save(sprintf([db{i},'X.mat']),'X');
    save(sprintf([db{i},'Y.mat']),'Y');
    save(sprintf([db{i},'filenames.mat']),'filenames');
    
    
end