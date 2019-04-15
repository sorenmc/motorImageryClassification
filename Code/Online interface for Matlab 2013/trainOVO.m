function classifiers = trainOVO(miData,featureMatrix,type)
% DESCRIPTION OF FUNCTION
% This function is used for training a classifier using OVO	
%
% INPUT
% miData:           Structure that contains MI snippets and corresponding
%                   information.
% featureMatrix:	Matrix of features
% type:             Type of classifier to train
%
% OUTPUT
% classifiers:      Classifiers used for OVO evaluation
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Finding number of classifers
nClassifiers = size(featureMatrix,2);

% Finding classes, features and classifiers
classes = miData.classes;
features = combineFeatures(featureMatrix);
classifiers = cell(1,nClassifiers);

% Finding OVO scheme for training
OVO = miData.OVO;

if(size(classes,1) < size(classes,2))
    classes = classes';
end

for classifier = 1:nClassifiers
    % Selecting which classes should be trained against each other (OVO)
    useOVO = OVO(classifier,:);
    
    % Returning logical array (nTrials x 2), specifying which trials
    % belongs to class '1' and class '2'
    choose =  logical(sum([classes==useOVO(1), classes==useOVO(2)]'));
    
    % Finding the classes, that should be trained on
    useClasses = classes(choose);
    
    % Finding the features that should be trained on
    useFeatures = features{classifier};
    useFeatures = useFeatures(choose,:);
    
    if( type == 'SVM')
        %train svm classifier
        opt = statset('Display','iter');
        classifiers{classifier} = svmtrain(useFeatures,useClasses,'method','SMO');
    elseif (type == 'LDA')
        %train LDA classifier
        classifiers{classifier} = fitcdiscr(useFeatures,useClasses);
    elseif(type == 'NAB')
        % Train NAB classifier
        classifiers{classifier} = fitcnb(useFeatures,useClasses);
    end
    
end




end

