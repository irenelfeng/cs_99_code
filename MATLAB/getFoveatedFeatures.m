function [features] = getFoveatedFeatures(JetsMagnitude, JetsPhase, numSizes, numOrientations, halve)
    
    if strcmp(halve,'top') == 1
        [tx,ty] = meshgrid(-5:4, -2:7); % assuming grid of 10*10 
    else
        [tx,ty] = meshgrid(-5:4, -7:2); 
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