function MDL = train_Mc_SVM()
    %% get all files
    % chose like 30 images, 15 happy 15 sad lol 
    X = {'cohn-kanade/S010/006/S010_006_01594629.png' 
        'cohn-kanade/S011/006/S011_006_03142202.png'
        'cohn-kanade/S014/005/S014_005_02405904.png'
        'cohn-kanade/S022/003/S022_003_00023018.png'
        'cohn-kanade/S026/006/S026_006_01384000.png'
        'cohn-kanade/S032/006/S032_006_01350405.png'
        'cohn-kanade/S034/005/S034_005_02293929.png'
        'cohn-kanade/S035/006/S035_006_02501919.png'
        'cohn-kanade/S037/006/S037_006_00234318.png'
        'cohn-kanade/S042/006/S042_006_01435709.png'
        'cohn-kanade/S044/003/S044_003_00044801.png'
        %% sad 
        'cohn-kanade/S010/002/S010_002_01593902.png'
        'cohn-kanade/S011/001/S011_001_03141509.png'
        'cohn-kanade/S014/001/S014_001_02405128.png'
        'cohn-kanade/S022/001/S022_001_00021417.png'
        'cohn-kanade/S026/001/S026_001_01383511.png'
        'cohn-kanade/S032/001/S032_001_01345811.png'
        'cohn-kanade/S034/001/S034_001_02293403.png'
        'cohn-kanade/S035/001/S035_001_02500816.png'
        'cohn-kanade/S037/001/S037_001_00233525.png'
        'cohn-kanade/S042/001/S042_001_01435126.png'
        'cohn-kanade/S044/001/S044_001_00044207.png'
        };
    Y = {'happy' 'happy' 'happy' 'happy' 'happy' 'happy' 'happy' 'happy' 'happy' 'happy' 'happy' 'surd' 'surd' 'surd' 'surd' 'surd' 'surd' 'surd' 'surd' 'surd' 'surd' 'surd'};
    all_features = zeros(size(X,1), 8000); % 8000 ist 
    for i=1:size(X,1)
        all_features(i, :) = image_features(X(i))';
    end
    size(all_features)
    MDL = fitcecoc(all_features, Y); 
end