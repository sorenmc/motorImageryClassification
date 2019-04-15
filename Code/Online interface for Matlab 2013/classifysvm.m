function [label, score] = classifysvm(classifier, features)
% DESCRIPTION OF FUNCTION
% This function classifies a single set of features using the specified 
% trained SVM classifier.
%
% INPUT
% classifier:	Trained SVM classifier
% features:     Features that needs to be classified
%
% OUTPUT:
% label:        Label indicating which class the features belong to
% score:        Probability indicating which class the features belong to
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


% Scaling data
features = features + classifier.ScaleData.shift;
features = features.*classifier.ScaleData.scaleFactor;

% Finding number of support vectors
nGroups = length(classifier.Alpha);

for i = 1:nGroups
    % Apply kernel function
    kernel = classifier.KernelFunction(classifier.SupportVectors(i,:),features);
    c(i) = classifier.Alpha(i)*kernel;
end

cComb = sum(c) + classifier.Bias;

if isnan(cComb)
    2+2;
end

if cComb >= 0
    label = 1;
    score = [cComb -cComb];
else
    label = 2;
    score = [cComb -cComb];
end


end

