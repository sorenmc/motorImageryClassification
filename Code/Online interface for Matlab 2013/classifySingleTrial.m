function [class, score] = classifySingleTrial(miData, recOpt, classifier)
% DESCRIPTION OF FUNCTION
% This function classifies a single trial in real time using OVO.
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
wMiData = FBCSP(dataToEval, recOpt.bandFilters, classifier.w);

% Combining features
features = combineFeatures(wMiData);

% Creating probability matrix
probabilityMatrix = cell(recOpt.nClasses);

% Finding number of classifiers and classes
nClassifiers = length(classifier.model);

% Performing classification for all OVO classifiers
for i = 1:nClassifiers
    classify = classifier.model{i};
    useFeatures = features{i};
    
    if sum(sum(isnan(useFeatures)))
        2+2;
    end
    
    [label,score] = classifysvm(classify,useFeatures);
    
    %Used to know which classes are 1v1
    a = classifier.trainOpt.OVO(i,1);
    b = classifier.trainOpt.OVO(i,2);
    
    %get previous probs for all trials
    aMatrix = probabilityMatrix{a};
    bMatrix = probabilityMatrix{b};
    
    %concatenate new probs with old probs
    aMatrix = [aMatrix,score(:,1)];
    bMatrix = [bMatrix,score(:,2)];
    
    
    probabilityMatrix{a} = aMatrix;
    probabilityMatrix{b} = bMatrix; 
end

%This matrix contains the sum of probabilities for each class on each trial
probMatrix = zeros(1,recOpt.nClasses);
for i = 1:recOpt.nClasses
   useProb = probabilityMatrix{i}; 
   probMatrix(:,i) = sum(useProb')';
end

% Finding maximum value of probability which is the 
[~,class] = max(probMatrix);
score = probMatrix;

end