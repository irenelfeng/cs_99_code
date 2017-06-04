Xlabels_emotions = {'','Anger','Disgust','Sad','Fear','Surprise','Neutral','Happy'};
Xlabels_pos_neg = {'','','Negative','','','','', 'Nonnegative',''};

inverted = load('data/network_results_inverted_on_upright_val.mat');
inverted_frozen = load('data/network_results_frozen_on_upright_val_FER.mat');
upright = load('data/network_results_whole_noFER_val_fd.mat');
uprighttestY = reorder_alphabetical_answers(upright.testY); 
uprightpredY = reorder_alphabetical_answers(upright.predY); 
invertedtestY = reorder_alphabetical_answers(inverted.testY); 
invertedpredY = reorder_alphabetical_answers(inverted.predY); 
invertedfrotestY = reorder_alphabetical_answers(inverted_frozen.testY); 
invertedfropredY = reorder_alphabetical_answers(inverted_frozen.predY); 


num = diag(confusionmat(uprighttestY, uprightpredY)); 
den = sum(confusionmat(uprighttestY, uprightpredY), 2);
numb = diag(confusionmat(invertedtestY, invertedpredY)); % wFER
denb = sum(confusionmat(invertedtestY, invertedpredY), 2);
numi = diag(confusionmat(invertedfrotestY, invertedfropredY)); % wFER
deni = sum(confusionmat(invertedfrotestY, invertedfropredY), 2);
CNN_upright = num./den;
CNN_inverted = numb./denb;
CNN_inverted_frozen = numi./deni;

CNN = [CNN_upright'; CNN_inverted'];
CNN_configural_diff = numb./denb - num./den;
CNN_configural_neg_pos = [sum(num([1:4], :))/sum(den([1:4])) sum(numb([1:4]))/sum(denb([1:4])) sum(numi([1:4]))/sum(deni([1:4]));
    sum(num([5:7]))/sum(den([5:7])) sum(numb([5:7]))/sum(denb([5:7])) sum(numi(5:7))/sum(deni(5:7))];
totals = [327 995 995;154 810 810]; % neg/noneg row (noFER / wFER) 
errors = zeros(2, 3, 2);
for i=1:2
    for j=1:2
        [phat, pci] = binofit(CNN_configural_neg_pos(i, j)*totals(i,j), totals(i,j)); 
        errors(i, j, :) = [phat - pci(1), pci(2) - phat];
    end
end
graphErrorBarsonGrouped(CNN_configural_neg_pos(:, 1:2), errors, Xlabels_pos_neg, {'CNN trained on upright', 'CNN trained on randomly inverted'});
% graphErrorBarsonGrouped(CNN_configural_neg_pos, errors, Xlabels_pos_neg, {'CNN trained on upright', 'CNN trained on randomly inverted',  'CNN trained on randomly inverted frozen conv. layers'});
xlabel('Expression');
ylabel('Proportion Correct');
ylim([.5 1]);

totalsEmotion = [histcounts(invertedtestY)', histcounts(invertedtestY)'];
% totalsEmotion = [histcounts(uprighttestY)', histcounts(invertedtestY)'];
CNN_emots = CNN';
errors = zeros(7, 2, 2);
for i=1:7
    for j=1:2
        [phat, pci] = binofit(round(CNN_emots(i, j)*totalsEmotion(i,j)), totalsEmotion(i,j)); 
        errors(i, j, :) = [phat - pci(1), pci(2) - phat];
    end
end
graphErrorBarsonGrouped(CNN_emots, errors, Xlabels_emotions,{'CNN trained on upright ', 'CNN trained on randomly inverted'});
xlabel('Expression');
ylabel('Proportion Correct');
ylim([0 1]); 
errors = zeros(7, 2, 2);