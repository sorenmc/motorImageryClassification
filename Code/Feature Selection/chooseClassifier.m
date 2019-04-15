function [model,modelNr] = chooseClassifier(models,features,classes)
% DESCRIPTION OF FUNCTION
% This function chooses which classifier should be used for evaluation, by
% calculating the scores for training data, and then returns the classifier
% that has the highest training score.
%
% INPUT
% models:       A cell vector containing the trained classifiers.
% features:     The features used to describe the training data
% classes:      The classes used to describe the training data
%
% OUTPUT:
% model:        The model with highest accuracy on training data
% modelNr:      The number of the model in the input models cell vector
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



% Number of models
nModels = length(models);

% Creating arrays for storing data
scores = zeros(nModels,1);
preds = zeros(nModels,1);

for i = 1:nModels
    [pred,score] = predict(models{1,i},features);
    
    if iscell(pred)
        pred = str2double(pred);
    end
    
    [~,score] = combinePredictionsOurData(pred, length(pred) ,score,"sum");
    
    [~,scores(i)] = findKappaValue(classes,score,5);
end

[~,modelNr] = max(scores);

% Finding which model scores highest
model = models{modelNr};

end