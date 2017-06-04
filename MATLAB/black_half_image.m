% blackout halves CNN images
directory = '../../CNN_48_images'; 
mkdir(directory,'/top_black');
mkdir(directory,'/bottom_black');
directories = {'ADFES', 'FER', 'Dartmouth', 'MMI', 'CK', 'KDEF'}; 
for i=1:length(directories)
    mkdir(directory, '/top_black/', directories{i});
    mkdir(directory, '/bottom_black/', directories{i});
end
files = glob([directory,'/**.*G'], '-ignorecase');

for file = files'
    if ~isempty(strfind(file{1}, 'val')) || ~isempty(strfind(file{1}, 'bottom')) || ~isempty(strfind(file{1}, 'top'))
        continue
    end
   im =imread(file{1}); 
    if size(im, 3) == 3
        im = rgb2gray(im);
    end
    [root, name, ext] = fileparts(file{1}); 
    parts = strsplit(root, '/'); 
    folder = parts(end); % cell
    
% END CNN stuff
    im_top = [im(1:24, :); zeros(24, 48)];
    im_bottom = [zeros(24, 48); im(25:48, :)];
    
     imwrite(uint8(im_top),sprintf('%s/bottom_black/%s/%s%s',directory,folder{1},name,ext));
     imwrite(uint8(im_bottom),sprintf('%s/top_black/%s/%s%s',directory,folder{1},name,ext));

end
