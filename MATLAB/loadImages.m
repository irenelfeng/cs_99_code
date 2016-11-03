% function that loads all database images ( into a .mat file 

% emotion,pixels,Usage
fid = fopen('MATLAB/fer2013/fer2013.csv');
data = textscan(fid,'%s %s %*s','Delimiter',','); % ignore training data
fclose(fid);
% load Y (0 1 2 3 4 5 6)
Y = data{1}(2:end);
Y = cellfun(@str2num, Y);
m = size(data{2}, 1);

% load X as a size 2304 vector
X = zeros(m-1, 2304);
for i=2:m
    X(i-1,:) = cellfun(@str2num, strsplit(strjoin(data{2}(i)), ' '));
end % this is taking a grand old time. 

% TODO: load CK+ images and emotion labels if have time


save X.mat X 
save Y.mat Y


    

