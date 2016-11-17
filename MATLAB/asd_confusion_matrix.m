% confusion matrices based off Porges numbers (only have error for each variable)
% ASD = 16/17 participants, and 36/35 Controls.

% ASD times wrong (MEANS) 
% anger: 1.88 per person ** the only significantly different 
% disgust: 1.25 per person - don't need
% fear: 1.47 per person 
% happiness: 0.00 
% sadness: .06 
% surprise: .35 per person 

% 'Angry','Fear', 'Happy', 'Sad', 'Surprise', 'Neutral'

% When I actually get the results: call confusion_matrix on test_y and pred_y. 
Conf_mat = [ 2.22 0 0 0 0 1.88; 
			  0 2.53 0 0 0 1.47; 
			  0 0 4.00 0 0 0;
			  0 0 0 3.94 0 .06;
			  0 0 0 0 3.65 .35];
TD_Conf_mat = [ 3.00 0 0 0 0 1.00;
				0 2.72 0 0 0 1.28;
				0 0 3.97 0 0 0.03;
				0 0 0 3.78 0 0.22; 
				0 0 0 0 3.69 0.31];
Percent_Conf_mat = zeros(size(Conf_mat));
for i=1:size(Conf_mat,1)
    if(sum(Conf_mat(i,:)) == 0)
        Percent_Conf_mat(i,:) = Conf_mat(i,:); % don't do division if all zeros    
    else
        Percent_Conf_mat(i,:) = Conf_mat(i,:)./sum(Conf_mat(i,:))*100; %sum across row: as in output class
        TD_Percent_Conf_mat(i,:) = TD_Conf_mat(i,:)./sum(TD_Conf_mat(i,:))*100; %sum across row: as in output class
    end
end
subplot(3,1,2);
labels = {'Angry','Fear', 'Happy', 'Sad', 'Surprise', 'Neutral'}; 
graph = heatmap(Percent_Conf_mat, labels, labels, 1,'Colormap', 'red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
xlabel('Output Class'); ylabel('Target Class');
title('ASD individuals Confusion Matrix (Porges)');
saveas(graph, 'asdconfmatrixporges.png');

subplot(3,1,3);
graph = heatmap(TD_Percent_Conf_mat, labels, labels, 1,'Colormap', 'red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
xlabel('Output Class'); ylabel('Target Class');
title('TD individuals Confusion Matrix (Porges)');
saveas(graph, 'tdconfmatrixporges.png');







