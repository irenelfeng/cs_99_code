directory = 'fer2013imgs/original';
files = dir([directory,'/','*.png']);
mkdir('fer2013imgs/flipped')

for file = files'
    im = imread([directory,'/',file.name]);
    im_flipped = flipud(im);
    imwrite(uint8(im_flipped),['fer2013imgs/flipped/',file.name]);
end