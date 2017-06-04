function features = image_features(imvec, numSizes, numOrientations, mode, foveated)
if nargin < 4
    mode = 0;
    foveated = 0;
elseif nargin < 5
    foveated = 0; 
end

J= reshape(imvec, [sqrt(length(imvec)), sqrt(length(imvec))])';
[JetsMagnitude, JetsPhase, GridPosition] = GWTWgrid_Simple(J,0,0, pi, numSizes, numOrientations); 
% we can ignore grid pos because they are the same for every image 
if (strcmp(mode, 'local') == 1 || strcmp(mode, 'global') ==1) % either local or global
    [JetsMagnitude, JetsPhase] = getGlocalizedFeatures(JetsMagnitude,JetsPhase, numSizes, numOrientations,mode);
    if foveated
        features = getFoveatedFeatures(JetsMagnitude, JetsPhase, floor(numSizes*2/3), numOrientations, mode);
    else
        features = [JetsMagnitude(:); JetsPhase(:)];
    end
elseif foveated
    features = getFoveatedFeatures(JetsMagnitude, JetsPhase, numSizes, numOrientations, mode);
else
switch mode
    case 'top'
        % for every column of Jets Magnitude (a different filter), reshape
        % it and get only the top half of it
            gridSize = size(JetsMagnitude, 1);
            gridLength = sqrt(size(JetsMagnitude, 1));
            rows = floor(gridLength/2);
            Total = zeros(numSizes * numOrientations * gridLength * rows *2, 1);
            for i = 0:size(JetsMagnitude, 2)-1
                mags = reshape(JetsMagnitude(:, i+1), [gridLength gridLength]); % reshapes it into a grid, columnwise
                phases = reshape(JetsPhase(:, i+1), [gridLength gridLength]); % reshapes it to a grid
                columnphases = phases(1:rows, :);
                columnmags = mags(1:rows, :);
                Total(i*(gridLength*rows*2)+1:i*(gridLength*rows*2)+rows*gridLength) = columnmags(:);
                Total(i*(gridLength*rows*2)+rows*gridLength+1:i*(gridLength*rows*2)+2*rows*gridLength) = columnphases(:);
            end
            features = Total;
        
        
    case 'bottom'

        gridSize = size(JetsMagnitude, 1);
        gridLength = sqrt(size(JetsMagnitude, 1));
        rows = floor(gridLength/2);
        Total = zeros(numSizes * numOrientations * gridLength*rows*2, 1);
        for i = 0:size(JetsMagnitude, 2)-1
            mags = reshape(JetsMagnitude(:, i+1), [gridLength gridLength]);
            phases = reshape(JetsPhase(:, i+1), [gridLength gridLength]);
            columnphases = phases(ceil(gridLength/2)+1:gridLength, :);
            columnmags = mags(ceil(gridLength/2)+1:gridLength, :);
            Total(i*(gridLength*rows*2)+1:i*(gridLength*rows*2)+rows*gridLength) = columnmags(:);
            Total(i*(gridLength*rows*2)+rows*gridLength+1:i*(gridLength*rows*2)+2*rows*gridLength) = columnphases(:);

        end
        features = Total;
    otherwise % blurred_top, blurred_bottom also all the features. 9680
        features = [JetsMagnitude(:); JetsPhase(:)];
    
end
    %% complex = 0 simple = 0 for 2nd param
end