function [rows] = row_count(row_divide, Conf_mat,weight)
    rows = row_divide; % copies 
    for r = 1:length(Conf_mat)
        if sum(Conf_mat(r,:)) ~= 0
            rows(r) = row_divide(r) + weight;
        end
    end
end