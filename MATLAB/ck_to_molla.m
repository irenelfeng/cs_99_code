% ck to molla oops 
function nowFer = ck_to_molla(labels)
nowFer = zeros(size(labels));
    c = [ 1 -1 2 3 5 6]; % no 4 because no neutral. 
    n = 1;
    for l = 1:length(labels)
        nowFer(n) = c(labels(l)); % converted
        n = n + 1;
    end
end