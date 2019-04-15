function out = flipDataSet(in)
% DESCRIPTION OF FUNCTION
% This function flips the dataset if it is oriented in the wrong way, it
% assumes that the number of samples are higher than the number of channels	
%
% INPUT
% in : The dataset that needs to be flipped
%
% OUTPUT
% out : The correctly oriented data set
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Finds number of channels and samples
nChannels = min(size(in));
nSamples = max(size(in));

% Checking if the data set are oriented correct
if size(in,1) == nSamples
    out = in';
else
    out = in;
end



