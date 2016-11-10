function confusion_matrix(predY, testY)
    clf
    %% make testY and predY in matrix form 
    % not necessary for current confusion matrix, but maybe in the future.
%     matTestY = zeros(length(testY), range(testY)+1);
%     matPredY = zeros(length(testY), range(testY)+1);
%     for i=1:length(testY)
%         j = testY(i)+1; %0-6 -> 1 to 7 
%         matTestY(i, j) = 1;
%         m = predY(i)+1; % 0-6 -> 1 to 7
%         matPredY(i, m) = 1;
%     end
    % graph = plotconfusion(matTestY', matPredY'); % rows: output, cols:input 
    % Alternative is much cheaper, but no pretty graphics: confusionmat(testY, predY) rows: target, cols: output 
    Conf_Mat = confusionmat(testY, predY); % predictions across Y-axis, predictions across X-axis
    Percent_Conf_mat = zeros(size(Conf_Mat));
    for i=1:size(Conf_Mat,1)
        Percent_Conf_mat(i,:) = Conf_Mat(i,:)./sum(Conf_Mat(i,:)); %sum across row: as in output class
    end
    labels = {'Angry','Fear', 'Happy', 'Sad', 'Surprise', 'Neutral'}; 
    graph = heatmap(Conf_Mat, labels, labels, 1,'Colormap', 'red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
    xlabel('Output Class'); ylabel('Target Class');
    saveas(graph, 'conf_p.png');
   
end