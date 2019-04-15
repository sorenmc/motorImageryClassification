function [bandFilters] = initializeFilter(nBands,F3dB1,maxFreq,order,fs,type)
% DESCRIPTION OF FUNCTION
% This function initializes the filters used in FBCSP	
%
% INPUT
% nBands:           Number of bands
% F3dB1:			Lower frequency of filter bank
% maxFreq:          Higher frequency of filter bank
% order:            Order of the filters
% fs:               Sampling frequency
% type:             Type of filter
%
% OUTPUT
% bandFilters:      Struct containing all the filters
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

bandFilters = filterStruct;
bandFilters.fs = fs;
bandFilters.nBands = nBands;
bandFilters.type = type;
bandFilters.order = order;
bandFilters.filterVector = cell(nBands,1);
bandFilters.F3dB1 = F3dB1;
jump = ceil((maxFreq-bandFilters.F3dB1)/nBands); %this one is constant
bandFilters.F3dB2 = bandFilters.F3dB1 + jump;


for band = 1:nBands
    bandFilters = createFilters(bandFilters);
    bandFilters.F3dB1 = bandFilters.F3dB1 + jump;
    bandFilters.F3dB2 = bandFilters.F3dB2 + jump;
    
end

end

