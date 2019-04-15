function dataStruct = rearrangeData(data)
% DESCRIPTION OF FUNCTION
% This function rearranges the recorded data, so it fits for training and 
% classification	
%
% INPUT
% data:         Data that needs to be in the right format
%
% OUTPUT
% dataStruct:   Data that is in the right format
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



% Finds number of datasets
nDataSet = size(data, 2);

doTranspose = false;
if size(data{1}.miData{1},2) < size(data{1}.miData{1},1)
    doTranspose = true;
end

% Finding number of channels
nChannels = min(size(data{1}.miData{1}));

% Creating trial vector, with first value at 1
trial(1) = 1;

% Assigning value to miData
miData = zeros(nChannels,0);
class = [];
k = 0;
for j = 1:nDataSet
    for i = 1:length(data{j}.miData)
        k = k + 1;
        
        % Finding number of samples in trial
        if doTranspose
            samples = size(data{j}.miData{i},1);
            miData = [miData; data{j}.miData{i}];
        else
            samples = size(data{j}.miData{i},2);
            miData = [miData, data{j}.miData{i}];
        end
        
        trial(k+1) = trial(k) + samples;
    end
    class = [class data{j}.class];
end
trial(end) = [];

% FInding number of channels
nClasses = length(unique(class));

% Transpose if needed
if doTranspose
   miData = miData'; 
end

noNan = isnan(miData(1,:));

miData(:,noNan) = [];

% Fitting trial vector to the new EEG matrix by removing samples from the
% trials where NaN was removed
for i = 1:length(noNan)
    % If NaN at sample
    if noNan(i)
        % Find which trial to remove a sample from
        ind = max(find(trial <= i));
        
        % Removing a sample from all the trials from ind+1 to end
        trial(ind+1:end) = trial(ind+1:end) - 1;
    end
end

% Asigning values to datastruct
dataStruct.classes = class;
dataStruct.miData = miData;
dataStruct.trials = trial;
dataStruct.nChannels = nChannels;
dataStruct.nClasses = nClasses;
dataStruct.nTrials = length(trial);

end