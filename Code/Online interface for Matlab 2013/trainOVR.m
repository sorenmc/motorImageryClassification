function [classifiers] = trainOVR(miData,features,type)
% DESCRIPTION OF FUNCTION
% This function is used for training a classifier using OVO	
%
% INPUT
% miData:           Structure that contains MI snippets and corresponding
%                   information.
% features:         Matrix of features
% type:             Type of classifier to train
%
% OUTPUT
% classifiers:      Classifiers used for OVO evaluation
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

%constants
class = miData.classes;
%cell vector containing
%nBands x nClasses reduced to 1 x nClasses
features = combineFeatures(features);

% Finding number of classifers
nClassifiers = size(features,2);


%output
classifiers = cell(nClassifiers,1);

for classifier = 1:nClassifiers
    %Trials that are equal to the one being discriminated against are
    %replaced by 1, others by 0
    binaryClass = makeClassBinary(class,classifier);
    
    %take out features where the class is being discriminated against
    useFeatures = features{classifier};
    
   if strcmp(type,'SVM')
        %train svm classifier
        opt = statset('Display','iter');
        classifiers{classifier} = svmtrain(useFeatures,binaryClass,'method','SMO');
   end
    
end


end