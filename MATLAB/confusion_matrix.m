function confusion_matrix(predY, testY, filename, titlee)
    clf
    %% make testY and predY in matrix form 
    Conf_mat = confusionmat(testY, predY); % predictions across Y-axis, predictions across X-axis
    Percent_Conf_mat = zeros(size(Conf_mat));
    for i=1:size(Conf_mat,1)
        if(sum(Conf_mat(i,:)) == 0)
            Percent_Conf_mat(i,:) = Conf_mat(i,:); % don't do division if all zeros
        else
            Percent_Conf_mat(i,:) = Conf_mat(i,:)./sum(Conf_mat(i,:))*100; %sum across row: as in output class
        end
    end
    labels = {'Angry','Fear', 'Happy', 'Sad', 'Surprise', 'Neutral'}; 
    graph = heatmap(Percent_Conf_mat, labels, labels, 1,'Colormap', 'red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
    xlabel('Output Class'); ylabel('Target Class');
    title(titlee);
    saveas(graph, filename);
   
end