% for the CNN dataset
% create the dataset_names_values 
% get filenames, get Y and then create a txt file out of it 
% FER is the weird one when the files are NOT in order. 
% i think everything else the Y.mat and the files in the directory in same order.

ADFES_name = {'Anger', 'Disgust', 'Fear', 'Joy', 'Neutral', 'Sad', 'Surprise'};
emot = 0:6;
ADFES_map = containers.Map(ADFES_name, emot);
directory = '../../CNN_48_images'; 
DBs = dir(directory);
% need a validation set (1/25th) 

txt = fopen('../../CNN_48_images/file_labels.txt', 'w');
val_txt = fopen('../../CNN_48_images/file_labels_val.txt', 'w');
train_txt = fopen('../../CNN_48_images/file_labels_train.txt', 'w');
for db = DBs'
    if ~db.isdir || ~isempty(strfind(db.name,'.'))
        continue
    end
    db.name
    if strcmp(db.name,'FER') == 1
        load('data/X.mat');
        load('data/Y.mat');
        Y = fer_to_molla(Y);
        happy = find(Y == 3);
        idxperm = randperm(length(happy)); % number of happies
        exclude = happy(idxperm(1:8989-6198)); %exclude the first random 6198 indices 
        for i=setdiff(1:length(X), exclude)
            fprintf(txt, 'FER/%d.png %4d\n',i, Y(i));
        end
        
        % create val set 
        subY = Y(setdiff(1:length(X), exclude));
        numVals = round(histcounts(subY)/25);
        idxes = zeros([max(numVals), 7]); % load all the random idxes 
        for i=0:6 % all emots 
            emot_is = setdiff(find(Y == i), exclude);
            idxperm = randperm(length(emot_is));
            val = emot_is(idxperm(1:numVals(i+1))); % the random idxes to count as val
            train = setdiff(emot_is, val);
            for v = 1:length(val)
                fprintf(val_txt, 'FER/%d.png %d\n',val(v), Y(val(v)));
            end
            for t = 1:length(train)
                fprintf(train_txt, 'FER/%d.png %d\n',train(t), Y(train(t)));
            end
        end
        
    else
        load(['data/',db.name,'_Y.mat']);
        files = dir([directory,'/', db.name,'/*.*g']); % jpg or png hopefully
        
        numVals = round(histcounts(Y)/25);
        idxes = zeros([max(numVals), 7]); % load all the random idxes 
        for i=0:6 % all emots
            
            emot_is = find(Y == i);
            idxperm = randperm(length(emot_is));
            val = emot_is(idxperm(1:numVals(i+1))); % the random idxes to count as val
            train = setdiff(emot_is, val);
            for v = 1:length(val)
                fprintf(txt, '%s/%s %d\n',db.name, files(val(v)).name, Y(val(v)));
                fprintf(val_txt, '%s/%s %d\n',db.name, files(val(v)).name, Y(val(v)));
            end
            for t = 1:length(train)
                fprintf(txt, '%s/%s %4d\n',db.name, files(train(t)).name, Y(train(t)));
                fprintf(train_txt, '%s/%s %d\n',db.name, files(train(t)).name, Y(train(t)));
            end
        end
        % all done filling in train and val :) 
    end
end
fclose(txt);
fclose(val_txt);
fclose(train_txt);

