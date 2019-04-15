function featureMatrix = FBCSP(miData,filterBands,wMatrix,type, extendChannels)
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
% type:             string that describes which multi class extension to
%                   use
%
% extendChannels:   Boolean value that determines whether we want
%                   downsampling to extra channels
%
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


%the number of classifiers depends on the multiclass extension
if(strcmp(type,'OVR'))
    nClassifiers = nClasses;
else
    nClassifiers = nClasses*(nClasses-1)/2;
end
%a filter combination of OVO vs band
featureMatrix = cell(nBands,nClassifiers);
miDataUse = miData.miData;

for band = 1:nBands
    
    %band pass filter data  -  using current band
    filterUse = filterBands.filterVector{band};
    filteredSignal = filtfilt(filterUse,transpose(miDataUse));
    
     if (extendChannels)
        %downsample and add the thrown away data as channels
        miData = newChannels(miData,filteredSignal);
    else
        %put filtered signal in struct
        miData.miData = transpose(filteredSignal);
    end
    
    %take all filters from one band - one from each classifier
    w = wMatrix(band,:);
    
    %calculate features for each CSP in this band (is a cell vector)
    features = cspFeatures(miData,w);
    
    featureMatrix(band,:) = features;
    
end

end

