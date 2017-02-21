directory = '../../mmi';
sessions = dir(directory);
Y = [];
disgustFrames = 100; 
peakoffset = 0;

for session = sessions'
    files = dir([directory,'/',session.name,'/','*.avi']);
    if length(files) == 1 % skips the ., .. nonsense
        [~, fname] = fileparts(files(1).name);
        neut = [];
        frames = 25;
        try
            v = VideoReader([directory,'/', session.name,'/', files(1).name]);
        catch
            session.name, 'avi not working'
            v =  VideoReader([directory,'/', session.name,'/', fname, '.mp4']);
        end
        for i=1:3
            neut(:,:,:,i) = readFrame(v); 
        end

        DOMnode = xml2struct(xmlread([directory,'/',session.name,'/', fname, '.xml']));
        emot_tag = DOMnode.ActionUnitCoding.Metatag(2);
        emot = str2double(emot_tag{1}.Attributes.Value);
        if emot <= 6 
            % make a whatever you know? like a Y value. lmao 
            if emot == 2
                frames = disgustFrames;
                peakoffset = disgustFrames/2;
            end
            
            while v.hasFrame
                video = readFrame(v);
                if v.CurrentTime >= v.Duration/2 - peakoffset*.04; % peak is middle
                    break
                end
            end
            
            for i = 1:frames  % 25 frames = 1 second % also not in the right order but it should be okay cause it's within the folder
                if ~v.hasFrame
                    break
                end
                mid = readFrame(v);
%                 imwrite(mid, sprintf('%s/%s/%s_%d.png', directory, session.name, fname, i));
                Y(end+1) = emot;
            end
        end
        % this comes later because neutral comes later
        for i=1:3
%             imwrite(uint8(neut(:,:,:,i)), sprintf('%s/%s/%s_neut%d.png', directory, session.name, fname, i));
            Y(end+1) = 0;
        end
        fname, session.name
    end
end

Y = mmi_to_molla(Y);
save data/MMI_Y.mat Y
    
