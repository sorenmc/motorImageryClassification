function [featureMatrix,cspMatrix,OVO] = fbCspTrain(miData,filterBands, nFilter, type)
% DESCRIPTION OF FUNCTION
%
% Uses the FBCSP algorithm on the training data to calculate 
% a set of csp filters and their corresponding features on the training data
%
% INPUT
% miData:           Structure that contains MI snippets and corresponding
%                   information.
% filterbands:      Filter bank of band pass filters specified in main
% nFilter:          describes how many sets csp filters to take from the
%                   matrix from each side
% type:             Type of classifier to train: OVO, OVR, OVOe
%
% OUTPUT:
% featureMatrix:    cell matrix containing all calculated features of 
%                   band / classifier combination. 
%                   size is [nBands x nClassifiers]
% cspMatrix:        cell matrix containing all calculated csp filters of 
%                   band / classifier combination. 
%                   size is [nBands x nClassifiers]
% OVO:              Returns OVO
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

%constants
nClasses = miData.nClasses;
nBands = filterBands.nBands;

%Variables
if(strcmp(type,'OVO')) || (strcmp(type,'OVO1'))
    nClassifiers = nClasses*(nClasses-1)/2;
elseif(strcmp(type,'OVR'))
    nClassifiers = nClasses;
end

%a filter combination of OVO vs band
cspMatrix = cell(nBands,nClassifiers);
featureMatrix = cell(nBands,nClassifiers);
miDataUse = miData.miData;

for band = 1:nBands
    
    %band pass filter data  -  using current band
    filterUse = filterBands.filterVector{band};
    filteredSignal = filtfilt(filterUse.b,filterUse.a,miDataUse');
    if size(filteredSignal,1) > size(filteredSignal,2)
        filteredSignal = filteredSignal';
    end
    miData.miData = filteredSignal;
    
    %calculate CSP filters for each classifier in the current freq band
    %(is a cell vector)
    if(strcmp(type,'OVO')) || (strcmp(type,'OVO1'))
        [cspFilters,OVO] = getCSP(miData,nFilter);
    elseif(strcmp(type,'OVR'))
        cspFilters = getCSPOVR(miData,nFilter);
    end
    
     %calculate features for each classifier in current freq band
    %(is a cell vector)
    features = MyFeatures(miData,cspFilters);
    
    
    cspMatrix(band,:) = cspFilters;
    featureMatrix(band,:) = features;
    
end

end

