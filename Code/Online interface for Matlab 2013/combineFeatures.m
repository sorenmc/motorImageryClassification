function [classifierFeatures] = combineFeatures(featureMatrix)
% DESCRIPTION OF FUNCTION
% This function combines the features in the input
%
% INPUT
% featureMatrix:        Matrix of features
%
% OUTPUT:
% classifierFeatures:   Features that have been combined.
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


% Finding number of bands and classifiers
nBands = size(featureMatrix,1);
nClassifiers = size(featureMatrix,2);

% Finding the features for classifier
classifierFeatures = cell(1,nClassifiers);
features = zeros(0,0);

% Looping through classifiers
for classifier = 1:nClassifiers
    % Looping through bands
    for band = 1:nBands
        % Contaginating the features for each band
        features = [features,featureMatrix{band,classifier}];
    end
    % Assigning the features for the n number of bands to a cell for a
    % classifier
    classifierFeatures{classifier} = features;
    % Resetting the features matrix
    features = zeros(0,0);
end

end

