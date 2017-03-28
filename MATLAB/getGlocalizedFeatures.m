% get Glocalized Features
function [JetsMagsGlocal, JetsPhaseGlocal] = getGlocalizedFeatures(JetsMagnitude, JetsPhase, numSizes, numOrientations, mode)
    sub = floor(numSizes*2/3);
    m = [];
    if strcmp(mode,'local') == 1
        % get the sub smallest sizes, every orientation 
        m = 1:sub*numOrientations;
        JetsMagsGlocal = JetsMagnitude(:, m);
        % check the size of this is 
        % size(JetsMagnitude, 1), sub*numOrientations)
        JetsPhaseGlocal = JetsPhase(:, m);
        
    else % global
        % get the 1 smallest size and the sub:n biggest sizes
        m = [1:numOrientations (sub)*numOrientations+1:numSizes*numOrientations];  
        JetsMagsGlocal = JetsMagnitude(:, m);
        JetsPhaseGlocal = JetsPhase(:, m);
    end
end