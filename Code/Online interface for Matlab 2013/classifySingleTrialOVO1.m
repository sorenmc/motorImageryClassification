function predicted = classifySingleTrialOVO1(miData, recOpt, classifier)
% DESCRIPTION OF FUNCTION
% This function classifies a single trial in real time using OVO extended.
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

nClasses = dataToEval.nClasses;


% Combining features
features = combineFeatures(features);

% Creating probability matrix
probabilityMatrix = cell(recOpt.nClasses);

% Finding number of classifiers and classes
nClassifiers = length(classifier.model);

labelMatrix = zeros(1,nClassifiers);

% Performing classification for all OVO classifiers
for i = 1:nClassifiers
    classify = classifier.model{i};
    useFeatures = features{i};
    
    
    [label,score] = classifysvm(classify,useFeatures);
    
    %will hold all labels in the end
    
    labelMatrix(:,i) = classifier.trainOpt.OVO(i,label);
    
    %used to know which two classes are 1v1 this time
    a = classifier.trainOpt.OVO(i,1);
    b = classifier.trainOpt.OVO(i,2);
    
    %get previous probability
    aMatrix = probabilityMatrix{a};
    bMatrix = probabilityMatrix{b};
    
    %get new scores
    aMatrix = [aMatrix,score(:,1)];
    bMatrix = [bMatrix,score(:,2)];
    
    
    probabilityMatrix{a} = aMatrix;
    probabilityMatrix{b} = bMatrix;
end

probMatrix = zeros(1,nClasses);
for class = 1:nClasses
    useProb = probabilityMatrix{class};
    probMatrix(:,class) = sum(useProb')';
end

%The class with higher propability is stored in this vector
predicted = zeros(length(class),1);


%find the class(es) that are guessed most often
[~,~,res] = mode(labelMatrix(1,:));

%contain class(es) that are selected most often
res = res{1}';
lRes = length(res);
if(lRes == 1)
    predicted(1) = res;
elseif(lRes == 2)
    %find the classifiers that is the OVO of the 2 selected classes
    %the coloumn index of the max value corresponds to the classifier.
    temp = zeros(size(classifier.trainOpt.OVO==res(1)));
    for i = 1:length(res)
        temp = temp + classifier.trainOpt.OVO==res(i);
    end
    
    [~,useClassifier] = max(sum((temp)'));
    
    %the label of the OVO classifier between the two
    % confliciting classes is chosen
    predicted(1) = labelMatrix(1,useClassifier);
else
    [~,useLabel] = max(probMatrix(1,:));
    predicted(1) = useLabel;
end


end