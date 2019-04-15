function classifiers = trainOVO(miData,featureMatrix,type)
% DESCRIPTION OF FUNCTION
%
% trains classifiers for each OVO matchup, and returns them as a cell
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


nClassifiers = size(featureMatrix,2);
classes = miData.classes;
features = combineFeatures(featureMatrix);
classifiers = cell(1,nClassifiers);
OVO = miData.OVO;

if(size(classes,1) < size(classes,2))
    classes = classes';
end

for classifier = 1:nClassifiers
    useOVO = OVO(classifier,:);
    
    %Used to select trials that contains the OVO scenario
    %sum functions as an OR operator
    choose = logical(sum((classes==useOVO)')');
    useClasses = classes(choose);
    useFeatures = features{classifier};
    useFeatures = useFeatures(choose,:);
    
    if( type == 'SVM')
        %train svm classifier
        classifiers{classifier} = fitcsvm(useFeatures,useClasses);
    elseif (type == 'LDA')
        %train LDA classifier
        classifiers{classifier} = fitcdiscr(useFeatures,useClasses);
    elseif(type == 'NAB')
        classifiers{classifier} = fitcnb(useFeatures,useClasses);
    end
    
end




end

