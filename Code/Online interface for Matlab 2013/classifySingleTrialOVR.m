function [class, score] = classifySingleTrialOVR(miData, recOpt, classifier)
% DESCRIPTION OF FUNCTION
% This function classifies a single trial in real time using OVR.
%
% INPUT
% miData:       Structure that contains MI snippets and corresponding
%               information.
% recOpt:       Struct containing the classification options
% classifier:   The trained classifier
%
% OUTPUT:
% class:        Vector containing the predicted classes
% score:        Matrix containing the predicted probabilities of the trial
%               belonging to a certain class.
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


% Removing NaN from data
noNan = isnan(miData(1,:));
miData(:,noNan) = [];

% Performing FBCSP on single trial
dataToEval.miData = miData;
dataToEval.nClasses = recOpt.nClasses;
dataToEval.nTrials = 1;
dataToEval.trials = 1;
features = FBCSP(dataToEval, recOpt.bandFilters, classifier.w);

% Combining features
features = combineFeatures(features);

% Creating probability matrix
probabilityMatrix = zeros(1,recOpt.nClasses);

% Finding number of classifiers and classes
nClassifiers = length(classifier.model);

% Performing classification for all OVO classifiers
for i = 1:nClassifiers
    classify = classifier.model{i};
    useFeatures = features{i};
    
    [label,score] = classifysvm(classify,useFeatures);
    
     probabilityMatrix(:,i) = score(:,1);
end


% Finding maximum value of probability which is the 
[~,class] = max(probabilityMatrix);
score = probabilityMatrix;

end