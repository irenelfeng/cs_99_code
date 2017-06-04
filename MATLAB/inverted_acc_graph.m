% upright inverted accuracy : save as nn_inversion.png
y = [.7548 .1372; .6284 .1883]; 
[phat_up_inv, pci_up_inv] = binofit(round(.1372*481), 481); %noFER
[phat_up_upr, pci_up_upr] = binofit(round(.7548 * 481), 481);

[phat_inv_inv, pci_inv_inv] = binofit(round(.1883*1805), 1805); %with FER
[phat_inv_upr, pci_inv_upr] = binofit(round(.6484*1805), 1805);

lower = [phat_up_inv-pci_up_inv(1) phat_up_upr-pci_up_upr(1); ... 
phat_inv_inv- pci_inv_inv(1) phat_inv_upr - pci_inv_upr(1)];
upper = [pci_up_inv(2)-phat_up_inv pci_up_upr(2)-phat_up_upr; ...
    pci_inv_inv(2)-phat_inv_inv pci_inv_upr(2)-phat_inv_upr];
errors = cat(3, lower, upper);
graphErrorBarsonGrouped(y, errors, {'','Trained only on upright','', 'Trained with random inversions',''}, {'Upright Images Test', 'Inverted Images Test'}); 
hline = refline([0 .1428]);
set(hline,'LineStyle',':', 'LineWidth', 5, 'Color', 'Red');
legend({'Upright', 'Inverted'});
ylabel('Proportion Correct');
xlabel('Model Type');