function [channelsMI,trialMI] = findMISnippets(channels, trials, fs, MIStart, MIEnd)
% DESCRIPTION OF FUNCTION
% This function finds the MI sessions from the training data, and returns
% the MI sessions in a matrix	
%
% INPUT
% channels: The channels that contain all the training data
% trials:   The vector holding the sample numbers of when a new trial is
%           started
% fs:       The sampling frequency
% MIStart:  Variable for how many seconds after a trial starts, the subject starts MI
% MIEnd:    Variable for how many seconds a MI session lasts
%
% OUTPUT:
% channelsMI:   The MI sessions
% trialMI:      The trial vector for when a new trial starts
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

nChannels = size(channels,1);

nTrials = length(trials);

lenMISamples = (MIEnd - MIStart)*fs;

% Initialize matrix to hold all MI sessions
channelsMI = zeros(nChannels,lenMISamples*nTrials);

% Cutting out the MI snippets for each of the 25 channels
for i = 1:nTrials
    % Finding the row numbers of the channelsMI matrix 
    rowChannelsMI1 = (i-1)*lenMISamples + 1;
    rowChannelsMI2 = i*lenMISamples+1;
    
    % Finding the row numbers of the channels matrix
    rowChannels1 = trials(i) + MIStart*fs;
    rowChannels2 = trials(i) + MIEnd*fs;
    
    % Cutting out the MI snippet of this specific trial
    channelsMI(:,rowChannelsMI1:rowChannelsMI2) = channels(:,rowChannels1:rowChannels2);
end

trialMI = 1:lenMISamples:size(channelsMI,2)-1;

end