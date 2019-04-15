function guessed = classifyOVO1(miData,featureMatrix)
% DESCRIPTION OF FUNCTION
%
% Returns the accuracy of the trained classifier contained in miData
% given the features contained in featureMatrix. If there is one class with
% more votes than the rest from the OVO classifiers, that class is the
% predicted class. If 2 classes have the same amount of votes, the label
% from the classifier which is the OVO of the classes wins. If more than 3
% classes are selected, the class with the highest sum of probabilities
% wins
%
% 
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
labelMatrix = zeros(nTrials,nClassifiers);

for classifier = 1:nClassifiers
    classify = classifiers{classifier};
    useFeatures = features{classifier};
    
    [label,score] = predict(classify,useFeatures);
    
    %will hold all labels in the end
    labelMatrix(:,classifier) = label;
    
    %used to know which two classes are 1v1 this time
    a = OVO(classifier,1);
    b = OVO(classifier,2);
    
    %get previous probability
    aMatrix = probabilityMatrix{a};
    bMatrix = probabilityMatrix{b};
    
    %concatenate new scores with old scores
    aMatrix = [aMatrix,score(:,1)];
    bMatrix = [bMatrix,score(:,2)];
    
    %save new scores in history matrix
    probabilityMatrix{a} = aMatrix;
    probabilityMatrix{b} = bMatrix;
end

probMatrix = zeros(nTrials,nClasses);

%sum of probabilities for each class
for class = 1:nClasses
    useProb = probabilityMatrix{class};
    probMatrix(:,class) = sum(useProb')';
end

%The class with higher propability is stored in this vector
predicted = zeros(length(class),1);

for trial = 1:nTrials
    
    %find the class(es) that are guessed most often
    [~,~,res] = mode(labelMatrix(trial,:));
    
    %contain class(es) that are selected most often
    res = res{1}';
    
    %number of classes that have an equal amount of votes.
    lRes = length(res);
    if(lRes == 1)
        predicted(trial) = res;
    elseif(lRes == 2)
        %find the classifiers that is the OVO of the 2 selected classes
        %the coloumn index of the max value corresponds to the classifier.
        [~,useClassifier] = max(sum((OVO==res)'));
        
        %the label of the OVO classifier between the two
        % confliciting classes is chosen
        predicted(trial) = labelMatrix(trial,useClassifier);
    else
         [~,useLabel] = max(probMatrix(trial,:));
         predicted(trial) = useLabel;
    end
end
guessed = accuracy(predicted,classes);

plotconfusion(categorical(classes),categorical(predicted'))

end