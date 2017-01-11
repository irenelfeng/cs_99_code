function difference_conf_matrix(predY, testY, predY2, testY2, filename, titlee)
    % clf
    %% make testY and predY in matrix form 
    Conf_mat = confusionmat(testY, predY); % target across Y-axis, predictions across X-axis
    Conf_mat2 = confusionmat(testY2, predY2);
    Percent_Conf_mat = zeros(size(Conf_mat));
    for i=1:size(Conf_mat,1)
        if (sum(Conf_mat(i,:)) == 0)
            z1 = zeros(size(Conf_mat(i,:)));
        else
            z1 = Conf_mat(i,:)./sum(Conf_mat(i,:));
        end
        if (sum(Conf_mat2(i,:)) == 0)
            z2 = zeros(size(Conf_mat2(i,:)));
        else
            z2 = Conf_mat2(i,:)./sum(Conf_mat2(i,:));
        end
        
        Percent_Conf_mat(i,:) = (z1 - z2) * 100;
    end
    labels = {'Angry','Disgust','Fear', 'Happy', 'Sad', 'Surprise', 'Neutral'}; 
    graph = heatmap(Percent_Conf_mat, labels, labels, 1,'Colormap', 'money','ShowAllTicks',1,'UseLogColorMap',true);
    xlabel('Output Class'); ylabel('Target Class');
    title(titlee);
    saveas(graph, filename);
   
end