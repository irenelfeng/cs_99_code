function [features] = getFoveatedFeatures(JetsMagnitude, JetsPhase, numSizes, numOrientations, halve)
    gridSize = sqrt(size(JetsMagnitude, 1));
    half = floor(gridSize/2); 
    fifth = floor(gridSize/5);
    if strcmp(halve,'top') == 1
        if mod(gridSize, 2) == 0
            [tx,ty] = meshgrid(-half:half-1, -fifth:4*fifth-1);
        else
            [tx,ty] = meshgrid(-half:half, -fifth:4*fifth);
        end
    else
        if mod(gridSize, 2) == 0
            [tx,ty] = meshgrid(-half:half-1, -fifth:4*fifth-1);
        else
            [tx,ty] = meshgrid(-half:half, -fifth:4*fifth);
        end
    end
    
    Total = [];
    distanceGrid = min(numSizes - 1, floor(sqrt(tx.^2 + ty.^2))); 
    % telling you how many filters we are excluding, can only exclude up to
    % numSizes - 1
    filters = distanceGrid(:); % how many filters we /aren't/ taking
    for i=1:size(filters,1)
        numFilters = (numSizes-filters(i))*numOrientations;
        % sprintf('taking %d filters at this point', numFilters)
        
        Total = [Total; reshape(JetsMagnitude(i, filters(i)*numOrientations+1:end), [numFilters,1])];
        Total = [Total; reshape(JetsPhase(i, filters(i)*numOrientations+1:end), [numFilters,1])];
    end
    features = Total;
end