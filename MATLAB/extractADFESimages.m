% just getting disgust images to sample
directory = '../../ADFES/ADFES_videos_Faceforward/';
saved = [directory,'../extracted_pics/'];
mkdir(saved);
sessions = dir([directory,'/*.mpeg']);

for session = sessions'
    if ~isempty(strfind(session.name, 'Disgust'))
        v = VideoReader([directory,'/', session.name]);
        [~, filename] = fileparts(session.name);
        % make a whatever you know? like a Y value. lmao 
        while v.hasFrame
            video = readFrame(v);
            if v.CurrentTime >= v.Duration/2 - .04*35 % middle 50 frames
                break
            end
        end
        for i = 1:100  % 100/25 = 4 seconds also not in the right order but it should be okay cause it's within the folder
            if ~v.hasFrame
                break
            end
            mid = readFrame(v);
            imwrite(mid, sprintf('%s/%s_%d.jpg', saved, filename, i));
        end
    end
end