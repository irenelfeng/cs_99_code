function [h] = graphErrorBarsonGrouped(barplot, errors, Xlabels, legendCellString) 
    % barplot is a grouped bar graph: columns- how many bars per group.
    % rows = how many groups. 
    % errors is either the same size as barplot
    % a 3D bar plot of the group. numGroups * barsperGroup * 2
    % 3rd dimension is [lower bound, upper bound]
    if mod(prod(size(errors)), prod(size(barplot))) ~= 0
        disp('sorry, your errors does not have the same shape as your barplot');
        return;
    end
    if prod(size(errors)) == prod(size(barplot)) * 2 && size(errors, 3) ~= 2
        disp('if you are going to have more error measures than total bars, please make error array 3d');
        return
    end
    figure
    hold on
    h = bar(barplot, 'grouped');
    set(h,'BarWidth',1);    % The bars will now touch each other
    set(gca,'YGrid','on')
    set(gca,'GridLineStyle','-')
    set(gca,'XTicklabel',Xlabels);
    set(get(gca,'YLabel'),'String','Proportion Correct');
    set(get(gca,'Xlabel'),'String','Expression');
    set(gca, 'FontSize', 18);

    lh = legend(legendCellString);
    hold on;
    numgroups = size(barplot, 1); 
    numbars = size(barplot, 2); 
    groupwidth = min(0.8, numbars/(numbars+1.5));
    for i = 1:numbars
          % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
          x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
          if size(errors, 3) == 2
            errorbar(x, barplot(:,i), errors(:, i, 1), errors(:, i, 2), 'k', 'linestyle', 'none');
          else
           errorbar(x, barplot(:,i), errors(:, i), 'k', 'linestyle', 'none');
          end
    end
end
