function [MI,trialMI] = findMISnippets(EEG, trials, fs, MIStart, MIEnd)
% DESCRIPTION OF FUNCTION
% This function finds the MI sessions from the training data, and returns
% the MI sessions in a matrix	
%
% INPUT
% EEG:      The channels that contain all the training data
% trials:   The vector holding the sample numbers of when a new trial is
%           started
% fs:       The sampling frequency
% MIStart:  Variable for how many seconds after a trial starts, the subject starts MI
% MIEnd:    Variable for how many seconds a MI session lasts
%
% OUTPUT:
% MI:       The MI sessions
% trialMI:      The trial vector for when a new trial starts
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

nChannels = size(EEG,1);

nTrials = length(trials);

nMISamples = (MIEnd - MIStart)*fs;

% Initialize matrix to hold all MI sessions
MI = zeros(nChannels,0);

% Cutting out the MI snippets for each of the 25 channels
for i = 1:nTrials
    
    % Finding the row numbers of the channels matrix
    rowChannels1 = trials(i) + MIStart*fs;
    rowChannels2 = trials(i) + MIEnd*fs-1;
    
    % Cutting out the MI snippet of this specific trial
    MI = [MI, EEG(:,rowChannels1:rowChannels2)];
end

%corresponding trial vector
trialMI = [1:nMISamples:nMISamples*nTrials];

end