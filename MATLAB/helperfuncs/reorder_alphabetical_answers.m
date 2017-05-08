% 
function [reordered] = reorder_alphabetical_answers(vec)
    reordered = zeros(size(vec));
    c = [ 1 2 4 7 6 3 5]; % 1.anger 2.disgust 3.sad 4.fear 5. surprise 6. neutral 7. happy 
    n = 1;
    for l = 1:length(vec)
        reordered(n) = c(vec(l)+1); % converted
        n = n + 1;
    end
end