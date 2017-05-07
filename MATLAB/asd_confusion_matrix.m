% create matrices
function [Total_TD, Total_ASD] = asd_confusion_matrix
figure;
addpath('helperfuncs');
load('../PYTHON/helperfuncs/dartmouthTDResults.mat'); 
Conf_mat = confusionmat(reorder_alphabetical_answers(testY), reorder_alphabetical_answers(predY)); % target across Y-axis, response across X-axis
    Percent_Conf_mat = zeros(size(Conf_mat));
    for i=1:size(Conf_mat,1)
        if(sum(Conf_mat(i,:)) == 0)
            Percent_Conf_mat(i,:) = Conf_mat(i,:); % don't do division if all zeros
        else
            Percent_Conf_mat(i,:) = Conf_mat(i,:)./sum(Conf_mat(i,:))*100; %sum across row: as in output class
        end
    end
    
labels = {'Angry','Disgust','Sad', 'Fear', 'Surprise','Neutral', 'Happy'}; 
graph = heatmap(Percent_Conf_mat, labels, labels, 1, 'Colormap', 'red','ShowAllTicks',1,'UseLogColorMap',true);
title('Dartmouth Confusion TD Results');
xlabel('Output Class'); ylabel('Target Class');


% Wallace
ASD_Wallace = [62,20,5,0,4,7,2;18,72,2,1,2,4,1;17,6,62,1,2,2,10;0,1,0,93,2,0,4;7,1,3,1,77,6,3;7,5,6,0,12,68,2;2,1,22,3,3,1,68];
TD_Wallace = [73,10,6,0,3,5,3;11,88,0,0,0,0,1;1,1,85,0,1,2,10;0,0,0,99,0,0,1;2,0,0,3,89,6,0;1,0,3,0,5,86,5;0,0,13,0,2,1,84];
% changed from alphabetical to valence-order: actually a pain. 
temp = ASD_Wallace([1 2 6 3 7 5 4], :); 
reordered_ASD_Wallace = temp(:, [1 2 6 3 7 5 4]);
temp = TD_Wallace([1 2 6 3 7 5 4], :); 
reordered_TD_Wallace = temp(:, [1 2 6 3 7 5 4]);
Percent_Wallace_Conf = makeDiffConfMat(reordered_ASD_Wallace,reordered_TD_Wallace);
figure; 
labels = {'Angry','Disgust','Sad', 'Fear', 'Surprise','Neutral', 'Happy'}; 
graph = heatmap(Percent_Wallace_Conf, labels, labels, 1, 'Colormap', 'money','ShowAllTicks',1);
title('Wallace ASD-TD Results');
xlabel('Output Class'); ylabel('Target Class');

% Eack (transposed remember) no disgust or surprise
ASD_Eack = [60.83, 10.28, 2.78, 11.67, 14.44; 
            2.22, 82.78, 1.67, 6.94, 6.39;
            2.78, .56, 90.56, 4.72, 1.39;
            5.28, .56, 1.39, 78.89, 13.89;
            4.17, 5.00, 3.61, 13.06, 74.17;
            ];
TD_Eack = [65.42, 11.25, 2.92, 11.25, 9.17;
            1.25, 89.58, .42, 3.33, 5.42;
            .42, .42, 98.75, 0.0, .42;
            1.67, 0, 2.50, 88.75, 7.08;
            4.58, 1.25, .83, 6.67, 86.67;
            ];
figure; 
temp = ASD_Eack([1 5 2 4 3], :); 
reordered_ASD_Eack = temp(:, [1 5 2 4 3]);
temp = TD_Eack([1 5 2 4 3 ], :); 
reordered_TD_Eack = temp(:, [1 5 2 4 3]);
labels = {'Angry','Sad','Fear','Neutral', 'Happy'}; 
graph = heatmap(reordered_ASD_Eack-reordered_TD_Eack, labels, labels, 1, 'Colormap', 'money','ShowAllTicks',1);
title('Eack ASD-TD Results');
xlabel('Output Class'); ylabel('Target Class');
%Wbach (haven't manually transposed this one so i do it here) 
ASD_Wbach = [73	20	1	0	1	1	0	0	0	0;
4	76	8	1	0	3	1	1	1	0;
1	0	47	0	2	3	3	1	0	0;
0	0	0	96	1	1	1	9	6	48;
3	1	1	1	91	8	0	30	11	1;
4	1	1	0	1	76	0	1	3	0;
1	0	40	1	1	3	94	3	0	1;
10	2	0	0	1	0	0	34	4	1;
3	0	3	0	1	3	1	10	74	0;
0	0	0	2	0	1	0	10	0	49]';
TD_Wbach = [88	15	0	0	1	1	0	1	0	0;
3	83	2	0	1	4	0	1	0	0;
2	1	78	0	1	3	7	0	2	0;
0	0	0	96	0	0	0	3	1	27;
0	0	0	1	89	3	1	17	3	1;
2	0	0	0	5	88	0	10	3	0;
0	0	20	0	0	0	92	3	0	0;
5	1	0	0	3	0	0	49	6	2;
0	0	0	1	0	1	0	13	85	0;
0	0	0	3	0	0	0	2	1	70;]';
temp = ASD_Wbach([1 2 6 3 7 5 4], :); 
reordered_ASD_Wbach = temp(:, [1 2 6 3 7 5 4]);
temp = TD_Wbach([1 2 6 3 7 5 4], :); 
reordered_TD_Wbach = temp(:, [1 2 6 3 7 5 4]);
labels = {'Angry','Disgust','Sad','Fear','Surprise','Neutral','Happy'}; 
graph = heatmap(reordered_ASD_Wbach-reordered_TD_Wbach, labels, labels, 1, 'Colormap', 'money','ShowAllTicks',1);
title('Wingenbach ASD-TD Results');
xlabel('Output Class'); ylabel('Target Class');

% no surprise or neutral
ASD_Philip = [ 65 25 5 0 6; 
    16 73 6 2 3;
    3 9 84 1 3;
    0 2 0 98 0;
    1 8 5 1 85;
    ];
TD_Philip = [
    85 12 1 0 2 ;
    7 91 2 0 0;
    1 12 87 0 1;
    0 0 0 100 0 ;
    0 1 4 0 95;
    ];
figure; 
temp = ASD_Philip([1 2 5 3 4], :); 
reordered_ASD_Philip = temp(:, [1 2 5 3 4]);
temp = TD_Philip([1 2 5 3 4 ], :); 
reordered_TD_Philip = temp(:, [1 2 5 3 4]);
labels = {'Angry','Disgust','Sad','Fear', 'Happy'}; 
graph = heatmap(reordered_ASD_Philip-reordered_TD_Philip, labels, labels, 1, 'Colormap', 'money','ShowAllTicks',1);
title('Philip ASD-TD Results');
xlabel('Output Class'); ylabel('Target Class');
% Weighted Aggregate Conf.
% wallace, eack, wbach, philip.
Weights_TD = [208, 240, 144, 161];

Weights_ASD = [208, 360, 144, 161];
Total_TD = zeros(size(7,7));
% to expand matrix to 7x7
% create zeros for emotions not tested
reordered_TD_Philip = [reordered_TD_Philip(1:4,:); zeros(2,5); reordered_TD_Philip(5,:);];
reordered_TD_Philip = [reordered_TD_Philip(:,1:4) zeros(7,2) reordered_TD_Philip(:,5)]; 
reordered_ASD_Philip = [reordered_ASD_Philip(1:4,:); zeros(2,5); reordered_ASD_Philip(5,:)];
reordered_ASD_Philip = [reordered_ASD_Philip(:,1:4) zeros(7,2) reordered_ASD_Philip(:,5)];

% expand matrix to 7x7 - disgust and neutral
reordered_TD_Eack = [reordered_TD_Eack(1,:); zeros(1,5); reordered_TD_Eack(2:4,:); zeros(1,5); reordered_TD_Eack(5,:);];
% add columns
reordered_TD_Eack = [reordered_TD_Eack(:,1) zeros(7,1) reordered_TD_Eack(:,2:4) zeros(7,1) reordered_TD_Eack(:,5)];
reordered_ASD_Eack = [reordered_ASD_Eack(1,:); zeros(1,5); reordered_ASD_Eack(2:4,:); zeros(1,5); reordered_ASD_Eack(5,:)];
reordered_ASD_Eack = [reordered_ASD_Eack(:,1) zeros(7,1) reordered_ASD_Eack(:,2:4) zeros(7,1) reordered_ASD_Eack(:,5)];

% dartmouth conf in actual numbers already
ASD_Matrices = zeros(7,7, length(Weights_TD));
TD_Matrices = zeros(7,7, length(Weights_TD));
ASD_Matrices(:,:,1) = reordered_ASD_Wallace;
ASD_Matrices(:,:,2) = reordered_ASD_Eack;
ASD_Matrices(:,:,3) = reordered_ASD_Wbach;
ASD_Matrices(:,:,4) = reordered_ASD_Philip;

TD_Matrices(:,:,1) = reordered_TD_Wallace;
TD_Matrices(:,:,2) = reordered_TD_Eack;
TD_Matrices(:,:,3) = reordered_TD_Wbach(1:7, 1:7);
TD_Matrices(:,:,4) = reordered_TD_Philip;

% multiply each cell by weights. 
Total_TD =  zeros(size(Conf_mat));
row_divide =zeros(size(Total_TD,1),1);
Total_ASD = zeros(size(Conf_mat));
row_ASDdivide = zeros(size(Total_ASD,1),1);

% number to calculate for row divide
for i = 1:length(Weights_ASD)
    row_ASDdivide = row_count(row_ASDdivide, ASD_Matrices(:,:,i), Weights_ASD(i)); 
    Total_ASD = Total_ASD + ASD_Matrices(:,:,i)*Weights_ASD(i)*.01; % percentage 
end

for i = 1:length(Weights_TD)
    row_divide = row_count(row_divide, TD_Matrices(:,:,i), Weights_TD(i)); 
    Total_TD = Total_TD + TD_Matrices(:,:,i)*Weights_TD(i)*.01; % percentage 
end

% then divide each row by row_divide
% Perc_Total_ASD = Total_ASD ./ repmat(row_ASDdivide, 1, 7);
% Perc_Total_TD = Total_TD ./ repmat(row_divide, 1, 7);
% why do i need to do this... i can just get the sum for each row haha
Perc_Total_ASD = Total_ASD ./ repmat(sum(Total_ASD, 2), 1, 7);
Perc_Total_TD = Total_TD ./ repmat(sum(Total_TD, 2), 1, 7);

figure;
ASD_TD_TOTAL = makeDiffConfMat(Perc_Total_ASD, Perc_Total_TD); 
labels = {'Angry','Disgust','Sad', 'Fear', 'Surprise','Neutral', 'Happy'}; 
graph = heatmap(ASD_TD_TOTAL, labels, labels, 1, 'FontSize', 15, 'Colormap', 'money');
title(sprintf('Total ASD-TD Confusions (%d studies)', length(Weights_TD)));
xlabel('Output Class'); ylabel('Target Class');

end

