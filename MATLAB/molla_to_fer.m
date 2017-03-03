% molla to fer
function nowFer = molla_to_fer(labels)
    nowFer = zeros(size(labels));
    c = [ 0 1 2 3 6 4 5 ];
    n = 1;
    for l = 1:length(labels)
        nowFer(n) = c(labels(l)+1); % converted
        n = n + 1;
    end
end