function [classifierFeatures] = combineFeatures(featureMatrix)
% DESCRIPTION OF FUNCTION
%
% Given a cell feature matrix of size nBands x nClassifiers
% Returns a cell feature matrix of size [1 x nClassifiers] by concatenating
% the rows.
%
% INPUT
% featureMatrix:    cell matrix containing all calculated features of 
%                   band / classifier combination. 
%                   size is [nBands x nClassifiers]
%                   
%
% OUTPUT:
% classifierFeatures:   combined featuress of size  [1 x nClassifiers]
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

nBands = size(featureMatrix,1);
nClassifiers = size(featureMatrix,2);
classifierFeatures = cell(1,nClassifiers);
features = zeros(0,0);

for classifier = 1:nClassifiers
    for band = 1:nBands
       features = [features,featureMatrix{band,classifier}];
    end
    classifierFeatures{classifier} = features;
    features = zeros(0,0);
end

end

