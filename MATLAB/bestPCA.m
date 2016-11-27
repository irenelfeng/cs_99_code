% returns the number of comps and returns residual variance in percent.
function [comps, newpoints, d] = bestPCA(X) 
    x = .40; % the max value of residual variance
    figure
    [c, points, score] = pca(X);
    % turn varianace scores into running sum 
    cumscore = cumsum(score);
    plot(1:length(cumscore), cumscore);
    % calculate 2nd deriv to find steepest 
    secondDeriv = zeros(length(score),1);
    % edge case - first 
    secondDeriv(1) = abs(cumscore(2) - 2*cumscore(1));
    for i=2:length(score)-1
        secondDeriv(i) = abs(cumscore(i+1)+ cumscore(i-1) - 2 * cumscore(i));
    end
    % find component that counts for at most x% residual variance, then
    % find elbow there. 
    e = zeros(length(score), 1);
    for i=1:length(score)
        e(i) = sum(score(i+1:end))/sum(score);
    end
    a = find(e < x);
    minimum = a(1); % find the minimum number of eigenvectors
    [maxVal, cutoff] = max(secondDeriv(minimum:end));
    hold on 
    plot(1:length(secondDeriv), secondDeriv);
    % return up to the kth component and new points + calculate residual variance
    comps  = c(:,1:cutoff+minimum);
    newpoints = points(:,1:cutoff+minimum);
    d = sum(score(cutoff+minimum+1:end))/sum(score)*100;
    sprintf('residual variance in percent not captured is %d', d)
    
end