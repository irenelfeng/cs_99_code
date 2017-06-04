% determine which nodes in Adaboost are the most 

nodes = {}; 
numFeatures = size(MDL.X, 2);
hashArray = zeros(numFeatures, 1);
sizeArray = zeros(3,1);
for i = 1:7
    for t = 1:100
        predictors = MDL.BinaryLearners{i}.Trained{t}.CutPredictor; 
        x = str2double(predictors{1}(2:end));
        for pred = 2:length(predictors)
            if strcmp(predictors{pred}, '') == 0 % if not empty
                i, t
            end
        end
        % count up
        hashArray(x) = hashArray(x) + 1;
        sizeArray(ceil(x/(numFeatures/3))) =  sizeArray(ceil(x/(numFeatures/3))) + 1;
    end
   
end

bar(sizeArray); 
colormap parula;
set(gca, 'YScale', 'linear');
xlabel('Size of filter(smallest to largest)');
set(gca, 'XTickLabel', {1, 2, 5});
ylabel('Number of features selected');