% this is just there to move ck images (the ones with most intensity) actually, not load them. 
% also creating only check for the validated emotions (should be 327) 
directory = '../cohn-kanade-plus/cohn-kanade';
emotdirectory = '../cohn-kanade-plus/cohn_kanade_emotion_labels';
mkdir('../cohn-kanade-plus/cohn-kanade/concat');

subjects = dir([directory,'/','S*']); % getting all pictures

for sub = subjects'
    emots = dir([directory,'/', sub.name,'/','0*']);
    for emotion = emots'
        if ~isempty(dir([emotdirectory,'/',sub.name,'/',emotion.name,'/*.txt']))
            imageset = dir([directory,'/', sub.name,'/', emotion.name]); 
            last = length(imageset); % last image- highest intensity
            fname = imageset(last).name;
            imwrite(imread([directory,'/',sub.name,'/', emotion.name, '/', fname]), ...
                    ['../cohn-kanade-plus/cohn-kanade/concat/',fname]);
        end
    end
end