function nowFer = mmi_to_fer(labels)
    % labels are always 1-6
    nowFer = zeros(size(labels));
    c = [ 4 0 1 2 3 5 6]; % 0  -> neutral + 1 -> 4
    n = 1;
    for l = 1:length(labels)
        nowFer(n) = c(labels(l) + 1); % converted
        n = n + 1;
    end
end