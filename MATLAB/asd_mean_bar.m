% asd error bars ( SEs)  
meansTD = [0.802994615
0.866089032
0.83627188
0.988096154
0.904181416
0.903901624
0.875588427];
meansTD = [meansTD(1:2)', meansTD(6), meansTD(3), meansTD(7) meansTD(5) meansTD(4)]';
meansASD = [0.661119498
0.713433105
0.694752427
0.956346036
0.838671875
0.79944013
0.826765734]; 
% reordering
meansASD = [meansASD(1:2)', meansASD(6), meansASD(3), meansASD(7) meansASD(5) meansASD(4)]';

means = [meansTD meansASD]; 
stds = [0.01896322	0.029669914
0.024197801	0.036066806
0.024109519	0.029346903
0.008654156	0.008686907
0.007756072	0.017949013
0.017210882	0.020343078
0.012077081	0.012715399];
stds = [stds(1:2, :); stds(6, :); stds(3, :); stds(7, :); stds(5, :); stds(4, :)];

h = graphErrorBarsonGrouped(means, stds, ...
{'0','Anger','Disgust','Sad','Fear','Surprise','Neutral','Happy'}, {'TD','ASD'});
ylim([.5, 1]); 

pos_neg_lit = [meansTD, meansASD];
% this is actually wrong because not weighted. but oh well :P 
pos_neg_lit = [mean(pos_neg_lit(1:4, :)); mean(pos_neg_lit(5:7, :)) ];
pos_neg_std = [mean(stds(1:4, :)); mean(stds(5:7, :))];

h = graphErrorBarsonGrouped(pos_neg_lit, pos_neg_std, {'','','Negative','','','','', 'Nonnegative',''}, {'TD','ASD'});

