% get Glocalized Features
function [JetsMagsGlocal, JetsPhaseGlocal] = getGlocalizedFeatures(JetsMagnitude, JetsPhase, numSizes, numOrientations, mode)
    sub = floor(numSizes*2/3);
    if strcmp(mode,'local') == 1
        % get the s smallest sizes, every orientation        
        for i=0:numSizes-1
            m = [m i*numOrientations+1:i*numOrientations+sub+1];
        end
        JetsMagsGlocal = JetsMagnitude(:, m);
        % check the size of this is 
        % size(JetsMagnitude, 1), sub*numOrientations)
        JetsPhaseGlocal = JetsPhase(:, m);
        
    else
        % get the 1 smallest size and the n-s:n biggest sizes
        for i=0:numSizes-1
            m = [m i*numOrientations+1 (i+1)*numOrientations-sub+1:(i+1)*numOrientations];
        end
        JetsMagsGlocal = JetsMagnitude(:, m);
        JetsPhaseGlocal = JetSPhase(:, m);
    end
end