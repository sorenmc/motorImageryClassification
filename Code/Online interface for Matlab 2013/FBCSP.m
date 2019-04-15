function featureMatrix = FBCSP(miData,filterBands,wMatrix)
% DESCRIPTION OF FUNCTION
%
% Uses the FBCSP algorithm on the input data to calculate the csp features
% for the various bands.
%
%
%
% INPUT
% miData:           Structure that contains MI snippets and corresponding
%                   information.
%
% filterbands:      Filter bank of band pass filters specified in main
% wMatrix:          trained CSP filters. Is a cell matrix of size 
%                   [nBands x nClassifiers]. Each cell contain a set of CSP
%                   filters
%
% OUTPUT:
% featureMatrix:    cell matrix containing all calculated features of 
%                   band / classifier combination. 
%                   size is [nBands x nClassifiers]
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

%constants
nClasses = miData.nClasses;
nBands = filterBands.nBands;

%Variables


%data
nClassifiers = size(wMatrix,2);

%a filter combination of OVO vs band
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
    
    %calculate CSP filters for each OVO in this band (is a cell vector)
    w = wMatrix(band,:);
    
    %calculate features for each OVO in this band (is a cell vector)
    features = MyFeatures(miData,w);
    
    featureMatrix(band,:) = features;
    
end

end

