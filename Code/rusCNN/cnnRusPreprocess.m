function [Tensor,Classes] = cnnRusPreprocess(miData,bandFilters,windowSize)
% DESCRIPTION OF FUNCTION:
% Used to get sliding window fourier spectrum turned into a Tensor.
% 
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


dataUse = miData.miData;
filterUse = bandFilters.filterVector{1};
dataUse = filtfilt(filterUse,dataUse');
miData.miData = dataUse';

[Tensor,Classes] =  fourSpec(miData,windowSize);
end

