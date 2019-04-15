function [trainedClassifiers] = trainOVR(miData,features,classifierType)
% DESCRIPTION OF FUNCTION
%
% trains classifiers for each OVR matchup, and returns them as a cell
% vector
%
% INPUT
%
% miData:           Structure that contains MI snippets and corresponding
%                   information.
%
% features:         contains features for each classifier stored as a cell
%                   vector with size [nBands x nClassifiers]
% classifierType:   String that determines which classifier type to train.
%
% OUTPUT:
%
% trainClassifiers: contains the trained classifiers as a cell vector with
%                   dimension [1 x nClassifiers]
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk




%constants
nClasses = miData.nClasses;
class = miData.classes;
%cell vector containing
%nBands x nClasses reduced to 1 x nClasses
features = combineFeatures(features);


%output
classifierVector = cell(nClasses,1);

for discriminateAgainst = 1:nClasses
    %Trials that are equal to the one being discriminated against are
    %replaced by 1, others by 0
    binaryClass = makeClassBinary(class,discriminateAgainst);
    
    %take out features where the class is being discriminated against
    discrimFeature = features{discriminateAgainst};
    
    if (strcmp('LDA',classifierType))
        %train LDA classifier
        classifierVector{discriminateAgainst} = fitcdiscr(discrimFeature,binaryClass);
    elseif( strcmp('SVM',classifierType))
        %train svm classifier
        classifierVector{discriminateAgainst} = fitcsvm(discrimFeature,binaryClass);
        
    elseif(strcmp('NAB',classifierType))
        classifierVector{discriminateAgainst} = fitcnb(discrimFeature,binaryClass);
    end
    
    
end

%return trained classifiers
trainedClassifiers = classifierVector;

end