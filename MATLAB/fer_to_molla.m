function nowFer = fer_to_molla(labels)
    nowFer = zeros(size(labels));
    c = [ 0 1 2 3 5 6 4 ];
    n = 1;
    for l = 1:length(labels)
        nowFer(n) = c(labels(l)+1); % converted
        n = n + 1;
    end
end