% ADFES make Y.mat 
ADFES_name = {'Anger', 'Disgust', 'Fear', 'Joy', 'Neutral', 'Sad', 'Surprise'};
labels = 0:6;
ADFES_map = containers.Map(ADFES_name, labels);
ADFES_Y = zeros(2353, 1);
directory = '../../ADFES';
files = dir([directory,'/','*.jpg']);
i = 1;
for file = files'
    emot = 0;
    for key = ADFES_name
        k = strfind(file.name,key);
        if ~isempty(k)
            emot = file.name(k:k+length(key{1})-1); % goddamn hate matlab
            break
        end
    end
    
    fprintf(txt, 'ADFES/%s %4d\n',file.name, ADFES_map(emot));
    ADFES_Y(i) = ADFES_map(emot);
    i = i + 1;
end