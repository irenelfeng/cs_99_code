Xlabels_pos_neg = {'','Negative','','', 'Nonnegative'};
Xlabels_emotions = {'','Anger','Disgust','Sad','Fear','Surprise','Neutral','Happy'};

%% CNN bottom top
noFERtop = load('data/network_results_top_val_1mil_noFER.mat');
noFERtoptestY = reorder_alphabetical_answers(noFERtop.testY);
noFERtoppredY = reorder_alphabetical_answers(noFERtop.predY);
noFERbot = load('data/network_results_bot_val_320k_noFER.mat');
noFERbottestY = reorder_alphabetical_answers(noFERbot.testY);
noFERbotpredY =  reorder_alphabetical_answers(noFERbot.predY);
num = diag(confusionmat(noFERtoptestY, noFERtoppredY)); 
den = sum(confusionmat(noFERtoptestY, noFERtoppredY), 2);
numb = diag(confusionmat(noFERbottestY, noFERbotpredY)); 
denb = sum(confusionmat(noFERbottestY, noFERbotpredY), 2);
CNN_top = num./den;
CNN_bot = numb./denb;
CNN_bar = numb./denb - num./den;
CNN_top_bot = [CNN_top CNN_bot];
CNN_bottop_neg_pos = [sum(num(1:4))/sum(den(1:4)) sum(numb(1:4))/sum(denb(1:4));
    sum(num(5:7))/sum(den(5:7)) sum(numb(5:7))/sum(denb(5:7))];

totals = [327 327;154 154]; % neg/noneg row
errors = zeros(2, 2, 2);
for i=1:2
    for j=1:2
        [phat, pci] = binofit(round(CNN_bottop_neg_pos(i, j)*totals(i,j)), totals(i,j)); 
        errors(i, j, :) = [phat - pci(1), pci(2) - phat];
    end
end
graphErrorBarsonGrouped(CNN_bottop_neg_pos, errors, Xlabels_pos_neg,{'CNN top sharp', 'CNN bottom sharp'});
xlabel('Expression');
ylabel('Proportion Correct');

totalsNOFER = repmat([46   196    44    41    57    39    58]', 2); 
errors = zeros(7, 2, 2);
for i=1:7
    for j=1:2
        [phat, pci] = binofit(round(CNN_top_bot(i, j)*totalsNOFER(i,j)), totalsNOFER(i,j)); 
        errors(i, j, :) = [phat - pci(1), pci(2) - phat];
    end
end
graphErrorBarsonGrouped(CNN_top_bot, errors, Xlabels_pos_neg,{'CNN top sharp', 'CNN bottom sharp'});
xlabel('Expression');
ylabel('Proportion Correct');

% top_black = load('data/network_results_top_black_val_noFER.mat');
% top_blacktestY = reorder_alphabetical_answers(top_black.testY);
% top_blackpredY =  reorder_alphabetical_answers(top_black.predY);
bot_black = load('data/network_results_bottom_black_val_noFER.mat');
bot_blacktestY = reorder_alphabetical_answers(bot_black.testY);
bot_blackpredY =  reorder_alphabetical_answers(bot_black.predY);
% num = diag(confusionmat(top_blacktestY, top_blackpredY)); 
% den = sum(confusionmat(top_blacktestY, top_blackpredY), 2);
num = repmat(.5, 1, 7)';
den = ones(7, 1);
numb = diag(confusionmat(bot_blacktestY, bot_blackpredY)); 
denb = sum(confusionmat(bot_blacktestY, bot_blackpredY), 2);
CNN_top = num./den;
CNN_bot = numb./denb;
% CNN_bar = numb./denb - num./den;
CNN_top_bot = [CNN_top CNN_bot];
CNN_bottop_neg_pos = [sum(num(1:4))/sum(den(1:4)) sum(numb(1:4))/sum(denb(1:4));
    sum(num(5:7))/sum(den(5:7)) sum(numb(5:7))/sum(denb(5:7))];

totals = [327 327;154 154]; % neg/noneg row
errors = zeros(2, 2, 2);
for i=1:2
    for j=1:2
        [phat, pci] = binofit(round(CNN_bottop_neg_pos(i, j)*totals(i,j)), totals(i,j)); 
        errors(i, j, :) = [phat - pci(1), pci(2) - phat];
    end
end
graphErrorBarsonGrouped(CNN_bottop_neg_pos, errors, Xlabels_pos_neg,{'CNN top half', 'CNN bottom half'});
xlabel('Expression');
ylabel('Proportion Correct');

%% NON-CNN bottom top 
load('data/128Y.mat');
train = floor(9/10*length(Y));
testY = double(reorder_alphabetical_answers(Y(train+1:length(Y))));

load('predYbottomblurred.mat');
load('predYbottomfoveated.mat');
load('predYbottomhalve.mat');
load('predYglobal.mat');
load('predYlocal.mat');
load('predYtopblurred.mat');
load('predYtopfoveated.mat');
load('predYtophalve.mat');

load('predYbottomblurredAda.mat');
load('predYbottomfoveatedAda.mat');
load('predYbottomhalveAda.mat');
load('predYglobalAda.mat');
load('predYlocalAda.mat');
load('predYtopblurredAda.mat');
load('predYtopfoveatedAda.mat');
load('predYtophalveAda.mat');
predictions = [predYtophalve'; predYbottomhalve'; predYtopfoveated'; predYbottomfoveated'; ...
    predYtopblurred'; predYbottomblurred']; 
% predictions = [predictions; predYtophalveAda'; predYbottomhalveAda'; predYtopfoveatedAda'; predYbottomfoveatedAda'; ...
%    predYtopblurredAda'; predYbottomblurredAda'];
barplot = zeros(size(predictions, 1), 7);
sum_pos = zeros(size(predictions, 1)/2, 2);
sum_neg = zeros(size(predictions, 1)/2, 2);
for pred = 1:2:size(predictions,1)
    num = diag(confusionmat(testY, reorder_alphabetical_answers(predictions(pred,:)))); 
    den = sum(confusionmat(testY, reorder_alphabetical_answers(predictions(pred,:))), 2);
    % bottom
    numb = diag(confusionmat(testY, reorder_alphabetical_answers(predictions(pred+1,:)))); 
    denb = sum(confusionmat(testY, reorder_alphabetical_answers(predictions(pred+1,:))), 2);
    
    sum_neg(ceil(pred/2), :)= [sum(num(1:4))/sum(den(1:4)) sum(numb(1:4))/sum(denb(1:4))];
    sum_pos(ceil(pred/2), :) = [sum(num(5:7))/sum(den(5:7)) sum(numb(5:7))/sum(denb(5:7))]; 
    barplot(pred,:) = num./den;
    barplot(pred+1, :) = numb./denb; 
end

%% POS_NEG_STUFF
totals = [414 389;414 389]; % neg/noneg row (noFER / wFER) 
for test=1:size(sum_pos,1)
    neg_pos = [sum_neg(test, :); sum_pos(test, :)];
    errors = zeros(2, 2, 2);
    for i=1:2
        for j=1:2
            [phat, pci] = binofit(neg_pos(i, j)*totals(i,j), totals(i,j)); 
            errors(i, j, :) = [phat - pci(1), pci(2) - phat];            
        end
    end
    h = graphErrorBarsonGrouped(neg_pos, errors, {'','','Negative','','','','', 'Nonnegative',''}, {'Top Half','Bottom Half'});
    xlabel('Expression');
    ylabel('Proportion Correct');
    ylim([.5, 1]);
end

meansTD = [0.802994615
0.866089032
0.83627188
0.988096154
0.904181416
0.903901624
0.875588427];
meansASD = [0.661119498
0.713433105
0.694752427
0.956346036
0.838671875
0.79944013
0.826765734]; 
meansTD = [meansTD(1:2)', meansTD(6), meansTD(3), meansTD(7) meansTD(5) meansTD(4)]';
meansASD = [meansASD(1:2)', meansASD(6), meansASD(3), meansASD(7) meansASD(5) meansASD(4)]';
pos_neg_lit = [meansTD meansASD];
pos_neg_lit = [mean(pos_neg_lit(1:4, :)); mean(pos_neg_lit(5:7, :)) ];
% pos_neg_std = [mean(stds(1:4, :)); mean(stds(5:7, :))];

literature = [meansASD - meansTD]'; 
% totalbar = [ literature; barplot; CNN_bar'; ];% CNN results last row

%% OVERALL BAR PLOT FOR NON CNN EMOTIONS - BOTTOM TOP
totals = repmat([111    95   108   100   140    98   151]', 2); % emotion rows (method cols) 
for test=1:2:size(barplot,1)
    emotions = [barplot(test, :); barplot(test+1, :)]';
    errors = zeros(7, 2, 2);
    for i=1:7
        for j=1:2
            [phat, pci] = binofit(emotions(i, j)*totals(i,j), totals(i,j)); 
            errors(i, j, :) = [phat - pci(1), pci(2) - phat];            
        end
    end
    h = graphErrorBarsonGrouped(emotions, errors, {'Anger','Disgust','Sad', 'Fear', 'Surprise', 'Neutral', 'Happy'}, {'Top Half','Bottom Half'});
    ylim([.5, 1]);
    xlabel('Expression');
    ylabel('Proportion Correct'); 
    set(gca,'XTickLabel', {'', 'Anger','Disgust','Sad', 'Fear', 'Surprise', 'Neutral', 'Happy'}); 

end
% legend({'Literature','Gabor Halves', 'GaborHalvesAda', 'Gabor Blurred', 'Gabor BlurredAda', 'Gabor Foveated', 'GaborFoveatedAda','CNN Blurred'});
% legend({'Literature','Gabor Halves', 'Gabor Foveated', 'Gabor Blurred', 'CNN Blurred'});

difference_from_literature = (repmat(literature, size(barplot, 1), 1) - barplot).^2;
sum(difference_from_literature, 2); 

%% OVERALL EMOTION - LOCAL GLOBAL
locals = [predYglobal'; predYlocal']; %; predYglobalAda'; predYlocalAda';];
glocal = zeros(7,2);
% for pred = 1:2:4

num = diag(confusionmat(testY, reorder_alphabetical_answers(locals(1,:)))); 
den = sum(confusionmat(testY, reorder_alphabetical_answers(locals(1,:))), 2);
numb = diag(confusionmat(testY, reorder_alphabetical_answers(locals(2,:)))); 
denb = sum(confusionmat(testY, reorder_alphabetical_answers(locals(2,:))), 2);
glocal(:, 1) = num./den;
glocal(:, 2) = numb./denb;
% end
glocal_nonCNN_pos_neg = [sum(num(1:4))/sum(den(1:4)) sum(numb(1:4))/sum(denb(1:4));
    sum(num(5:7))/sum(den(5:7)) sum(numb(5:7))/sum(denb(5:7))];
totals = [414 414;389 389]; % neg/noneg row
errors = zeros(2, 2, 2);
for i=1:2
    for j=1:2
        [phat, pci] = binofit(round(glocal_nonCNN_pos_neg(i, j)*totals(i,j)), totals(i,j)); 
        errors(i, j, :) = [phat - pci(1), pci(2) - phat];
    end
end
h = graphErrorBarsonGrouped(glocal_nonCNN_pos_neg, errors, Xlabels_pos_neg, {'Global LDA','Local LDA'});
totalsMAT = repmat(histcounts(testY), 2)';
errors = zeros(7, 2, 2);
for i=1:7
    for j=1:2
        [phat, pci] = binofit(round(glocal(i, j)*totalsMAT(i,j)), totalsMAT(i,j)); 
        errors(i, j, :) = [phat - pci(1), pci(2) - phat];
    end
end
graphErrorBarsonGrouped(glocal, errors, Xlabels_emotions,{'Global LDA', 'Local LDA'});
xlabel('Expression');
ylabel('Proportion Correct');
ylim([.5 1]); 
% set(gca,'XTickLabel', {'Anger','Disgust','Fear', 'Happy', 'Neutral', 'Sad', 'Surprise'}); 
% xlabel('Expression');
% ylabel('Difference in Accuracy'); 
% legend({'Literature','Gabor Local-Global LDA','Gabor Local-Global Ada', 'CNN inverted-upright'});