function [Tensor,classes] = cnnDeepPreprocess(miData,bandFilters)
% DESCRIPTION OF FUNCTION
%
% Input data gets filtered then downsampled and this is used as new trials.
% Afterwards the input is turned into a tensor of size 
% [nChannels x 375 x 1 x nTrials].
% 
%
% INPUT
% miData:           Structure that contains MI snippets and corresponding
%                   information.
%
% bandFilters:		Structure that contains nBands of band pass filters
%
% OUTPUT:
% Tensor:		Filtered data that has been downsampled to increase number
%               of trials. Also turned in a tensor of size
%               [nChannels x 375 x 1 x nTrials].
%
% classes:  	Vector containing labels for the new data.
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk




nChannels = miData.nChannels;
dataUse = miData.miData;
filterUse = bandFilters.filterVector{1};


dataUse = filter(filterUse,dataUse');
miData.miData = dataUse';

%Returns downsampled data - doubles the amount of trials, but halfs trial
%lengths
useMIData = downSample(miData,2);


%load new information
trials = useMIData.trials;
classes = useMIData.classes;
dataUse = useMIData.miData;

%The new trial Length - in this case 375
nDownSamples = trials(2)-1;
nTrials = length(trials);

Tensor = reshape(dataUse,nChannels,nDownSamples,1,nTrials);
end

