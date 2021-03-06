% returns the number of comps and returns residual variance in percent.
function [comps, newpoints, d] = bestPCA(X) 
    x = .20; % the max residual variance tolerated
    [c, points, score] = pca(X);
    % turn varianace scores into running sum 
    cumscore = cumsum(score);
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
    end % e is the cumulative sum to 1
    a = find(e < x); 
    minimum = a(1); % find the minimum number of eigenvectors to take, gives 
    [maxVal, cutoff] = max(secondDeriv(minimum:end));
    % plot(1:length(secondDeriv), secondDeriv);
    % return up to the kth component and new points + calculate residual variance
    comps  = c(:,1:cutoff+minimum);
    newpoints = points(:,1:cutoff+minimum);
    d = sum(score(cutoff+minimum+1:end))/sum(score)*100;
    sprintf('residual variance in with %f (un)captured is %f percent',  size(comps, 2), d)
    
end