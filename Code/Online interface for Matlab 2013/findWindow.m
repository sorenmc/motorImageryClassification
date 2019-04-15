function [window] = findWindow(miData, fs, windowLength)
% DESCRIPTION OF FUNCTION
% This function cuts out a single window from the data in real time	
%
% INPUT
% miData:		MI data in matrix
% fs:			Sampling frequency
% windowLength: Length of the window to cut [s]
%
% OUTPUT
% window:       Window that have been cutted from data       
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Converting to samples
nSamples = windowLength*fs;

% Cutting out window
window = miData(:,end-nSamples+1:end);

end

