function [guessed] = classifyOVR(miData,features)
% DESCRIPTION OF FUNCTION
%
% Returns the accuracy of the trained classifier contained in miData
% given the features contained in featureMatrix. The class with the highest
% probability is chosen.
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
% guessed:        Accuracy of the classifier on all input trials.
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

nClasses = miData.nClasses;


%contains classifiers in a cell vector
classifiers = miData.classifiers;

%labels
class = miData.classes;


%matrix used to determine which class has higher propability for trial t
probabilityMatrix = zeros(length(class),nClasses);

features = combineFeatures(features);

for i = 1:nClasses
    
    
    useClassifier = classifiers{i};
    useFeature = features{i};
    
    [label,score] = predict(useClassifier,useFeature);
    %store propabilities of each class
    probabilityMatrix(:,i) = score(:,1);
    
end

%The class with higher propability is stored in this vector
predicted = zeros(length(class),1);

for trial = 1:length(class)
    
    %the coloumn index of the max value corresponds to the class.
    [~,predClass]= max(probabilityMatrix(trial,:));
    predicted(trial) = predClass;
end

%calculate how many of the guesses were correct in %
guessed = accuracy(predicted,class);

end

