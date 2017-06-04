function [Conf_mat] = makeDiffConfMat(M1, M2)
Conf_mat = zeros(size(M1));
    for i=1:size(M1,1)
    z1 = M1(i,:)./sum(M1(i,:));
    z2 = M2(i,:)./sum(M2(i,:));
    Conf_mat(i,:) = (z1 - z2) * 100;
    end
end