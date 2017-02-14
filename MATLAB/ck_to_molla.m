% ck to fer 
function nowFer = ck_to_molla(labels)
nowFer = zeros(size(labels));
    c = [ 4 1 -1 2 3 5 6];
    n = 1;
    for l = 1:length(labels)
        nowFer(n) = c(labels(l)+1); % converted
        n = n + 1;
    end
end