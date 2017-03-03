function features = image_features(imvec, numSizes, numOrientations, halve, foveated)
if nargin < 4
    halve = 0;
    foveated = 0;
elseif nargin < 5
    foveated = 1; % automatically foveated
end

J= reshape(imvec, [48 48])';
[JetsMagnitude, JetsPhase, GridPosition] = GWTWgrid_Simple(J,0,0, 2*pi, numSizes, numOrientations); 
% we can ignore grid pos because they are the same for every image 
if foveated
    features = getFoveatedFeatures(JetsMagnitude, JetsPhase, numSizes, numOrientations, halve);
else
switch halve
    case 'top'
        % for every column of Jets Magnitude (a different filter), reshape
        % it and get only the top half of it
            Total = zeros(numSizes * numOrientations * 200, 1);
            for i = 0:size(JetsMagnitude, 2)-1
                mags = reshape(JetsMagnitude(:, i+1), [10 10]); % reshapes it into a grid, columnwise
                phases = reshape(JetsPhase(:, i+1), [10 10]); % reshapes it to a grid
                columnphases = phases(1:5, :);
                columnmags = mags(1:5, :);
                Total(i*100+1:i*100+50) = columnmags(:);
                Total(i*100+51:i*100+100) = columnphases(:);
            end
            features = Total;
        
        
    case 'bottom'

        Total = zeros(numSizes * numOrientations * 200, 1);
        for i = 0:size(JetsMagnitude, 2)-1
            mags = reshape(JetsMagnitude(:, i+1), [10 10]);
            phases = reshape(JetsPhase(:, i+1), [10 10]);
            columnphases = phases(6:10, :);
            columnmags = mags(6:10, :);
            Total(i*100+1:i*100+50) = columnmags(:);
            Total(i*100+51:i*100+100) = columnphases(:);
        end
        features = Total;
    otherwise
        features = [JetsMagnitude(:); JetsPhase(:)];
    
end
    %% complex = 0 simple = 0 for 2nd param
end