% overall barplot 

predictions = [predYtophalve'; predYbottomhalve'; predYtopblurred'; predYbottomblurred'; predYtopfoveated'; predYbottomfoveated']; 
barplot = zeros(size(predictions, 1)/2, 7);
for pred = 1:2:size(predictions,1)
    num = diag(confusionmat(testY, predictions(pred,:))); 
    den = sum(confusionmat(testY, predictions(pred,:)), 2);
    numb = diag(confusionmat(testY, predictions(pred+1,:))); 
    denb = sum(confusionmat(testY, predictions(pred+1,:)), 2);
    
    barplot(ceil(pred/2),:) = numb./denb - num./den;
end

totalbar = [ -0.1028   -0.0729   -0.0578   -0.0108   -0.0135   -0.0401    0.0413; barplot;
            zeros(1, 7); ];% CNN results last row
bar(barplot')
set(gca,'XTickLabel', {'Anger','Disgust','Fear', 'Happy', 'Neutral', 'Sad', 'Surprise'}); 
legend({'Literature','Gabor Halves', 'Gabor Blurred', 'Gabor Foveated', 'CNN Blurred'});

y = [75.48 13.72; 0 0]; 
bar(y); % how to get the legend of upright test and inverted test. 
legend({'Upright', 'Inverted'});
set(gca,'XTickLabel', {'Trained only on Upright', 'Trained with random Inversions'});
