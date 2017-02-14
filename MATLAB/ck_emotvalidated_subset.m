% create concat 
% this is just there to move ck images (the ones with most intensity) actually, not load them. 
% also creating only check for the validated emotions (should be 327) 
% added option to include more disgust
directory = '../../cohn-kanade-plus/cohn-kanade';
emotdirectory = '../../cohn-kanade-plus/cohn_kanade_emotion_labels';
mkdir('../../cohn-kanade-plus/cohn-kanade/concat');

subjects = dir([directory,'/','S*']); % getting all pictures
Y = [];
for sub = subjects'
    emots = dir([directory,'/', sub.name,'/','0*']);
    for emotion = emots'
        emotionlabel = dir([emotdirectory,'/',sub.name,'/',emotion.name,'/*.txt']);
        if ~isempty(emotionlabel)
            imageset = dir([directory,'/', sub.name,'/', emotion.name,'/*.png']); 
            label = fscanf(fopen([emotdirectory,'/',sub.name,'/',emotion.name,'/',emotionlabel.name]), '%f')
            
            if label == 2 % this is contempt
                continue
            end
            
            % highest image intensity = greatest frame
            last = 0;
            frames = cell(length(imageset), 1); 
            for i = 1:length(imageset)
                name = strsplit(imageset(i).name,'.');
                parts = strsplit(name{1},'_');
                frame = str2double(parts{3});
                if frame > last
                    last = frame;
                end
                frames{frame} = imageset.name; % put it in sorted order
            end

            if label == 999999 % decided not to do disgust! 
                fnames = frames{end-9:end};
                for f = fnames'
                   imwrite(imread([directory,'/',sub.name,'/', emotion.name, '/', f]), ...
                   [directory, '/concat/',f]);
                   Y(end+1) = label;
                end
                
            else
                fname = imageset(last).name;
                 imwrite(imread([directory,'/',sub.name,'/', emotion.name, '/', fname]), ...
                                     [directory,'/concat/',fname]);
                Y(end+1) = label;
            end
            
        end
    end
end

Y
CK_Y = ck_to_molla(Y);
save CK_Y.mat CK_Y
