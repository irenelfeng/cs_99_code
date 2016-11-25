% returns the number of comps and returns residual variance in percent.
function [comps, newpoints, d] = bestPCA(X) 
    figure
    [c, points, score] = pca(X);
    % turn varianace scores into running sum 
    size(score)
    cumscore = cumsum(score);
    plot(1:length(cumscore), cumscore);
    % calculate 2nd deriv to find steepest 
    secondDeriv = zeros(length(score),1);
    % edge case - first 
    secondDeriv(1) = abs(cumscore(2) - 2*cumscore(1));
    for i=2:length(score)-1
        secondDeriv(i) = abs(cumscore(i+1)+ cumscore(i-1) - 2 * cumscore(i));
    end
    [maxVal, cutoff] = max(secondDeriv);
    hold on 
    plot(1:length(secondDeriv), secondDeriv);
    % return up to the kth component and new points + calculate residual variance
    comps  = c(:,1:cutoff);
    newpoints = points(:,1:cutoff);
    d = sum(score(cutoff+1:end))/sum(score)*100;
    sprintf('residual variance in percent not captured is %d', d)
    
end