function featureMatrix = cspFeatures(miData,w)
% DESCRIPTION OF FUNCTION
%
% used to return CSP features for each classifier of one band.
%
% INPUT
% miData:           Structure that contains MI snippets and corresponding
%                   information.
% w:                contains CSP filters for each classifier from one band
%                   cell vector with dimension size [1 x nClassifiers]
%
% OUTPUT:
% featureMatrix     contains features for each classifier from one band
%                   cell vector with dimension size [1 x nClassifiers]
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



nClassifiers = size(w,2);
featureMatrix = cell(1,nClassifiers);
for classifier = 1:nClassifiers
    %Get filtered data
    wUse = w{classifier};
    %Get variance features
    featureMatrix{classifier} = calculateCSPFeatures(miData, wUse);
end


end