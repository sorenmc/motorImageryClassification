function predicted = classifyOVO(miData,featureMatrix)
% DESCRIPTION OF FUNCTION
%
% Returns the accuracy of the trained classifier contained in miData
% given the features contained in featureMatrix.
%
% INPUT
% miData:           Structure that contains MI snippets and corresponding
%                   information.
%
% featureMatrix:    cell matrix containing all calculated features of 
%                   band / classifier combination. 
%                   size is [nBands x nClassifiers]
%                   
%
% OUTPUT:
% predicted:        Accuracy of the classifier on all input trials.
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

classifiers = miData.classifiers;
nClassifiers = length(classifiers);
classes = miData.classes;
nClasses = miData.nClasses;
OVO = miData.OVO;
nTrials = miData.nTrials;

features = combineFeatures(featureMatrix);
probabilityMatrix = cell(nClasses);


for classifier = 1:nClassifiers
    classify = classifiers{classifier};
    useFeatures = features{classifier};
    
    %predict returns a label and a probability that it is correct
    [label,score] = predict(classify,useFeatures);
    
    %Used for know which classes are 1v1
    a = OVO(classifier,1);
    b = OVO(classifier,2);
    
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
probMatrix = zeros(nTrials,nClasses);
for class = 1:nClasses
   useProb = probabilityMatrix{class}; 
   probMatrix(:,class) = sum(useProb')';
end

%The class with higher propability is stored in this vector
predicted = zeros(length(class),1);

for trial = 1:nTrials
    
    %the coloumn index of the max value corresponds to the class.
    [~,predClass]= max(probMatrix(trial,:));
    predicted(trial) = predClass;
end


predicted = accuracy(predicted,classes);



end