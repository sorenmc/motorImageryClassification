function miDataStructReturn = loadDataEEG2(data, nChannels, nTrials)

% Function call
%
% function miDataStructReturn = loadData4Class(datafile, run)
%
% INPUT:
% datafile : The dataset file to be loaded in
% run : Optional parameter, to select a specific run, if not given, then
% all six runs are loaded
%
% OUTPUT:
% miDataStructReturn : The data struct to return from function
%
% This function loads in the data from the training file

% Loading data
data = load(data);
data = data.resultingData;
nSessions = length(data);
miSampleLength = 2048;
defaultTrial = [1:miSampleLength:25*miSampleLength];
% Finding number of sessions (Is not the same for all subjects)

% Checking if 'run' parameter exists


% Creating empty arrays for channels, classes and trials
EEG = zeros(0,nChannels);
useMiData = zeros(0,nChannels);
classes = zeros(0,1);
trials = zeros(0,1);
artifacts = zeros(0,1);
% Initializing nSamples to 0, since first trial array does not need to be
% shifted by the number of samples
nSamples = 0;

% For loop either load in the selected classes
n = 0;
i = 1;
while n < nTrials
    useData = data{1,i}.Data;
  
    trialsToUse = nTrials - n;
    
    if trialsToUse > length(useData.miData)
        trialsToUse = length(useData.miData);
    end
  
    
    for semiTrial = 1:trialsToUse
        useMiData = [useMiData;useData.miData{semiTrial}];
    end
    
    EEG = [EEG; useMiData];
    
    
    trials = [trials, defaultTrial(1:trialsToUse) + nSamples];
    classes = [classes, useData.class(1:trialsToUse)];
    
    nSamples = size(EEG, 1);
    useMiData = [];
    
    i = i + 1;
    n = n + trialsToUse;
end

length(classes)

% Orienting dataset in the correct way
EEG = flipDataSet(EEG);

noNan = isnan(EEG(1,:));

EEG(:,noNan) = [];

% Fitting trial vector to the new EEG matrix by removing samples from the
% trials where NaN was removed
for i = 1:length(noNan)
    % If NaN at sample
    if noNan(i)
        % Find which trial to remove a sample from
        ind = max(find(trials <= i));
        
        % Removing a sample from all the trials from ind+1 to end
        trials(ind+1:end) = trials(ind+1:end) - 1;
    end
end




% Loading the sampling frequency
fs = useData.samplingFrequency;




%Data to return is saved in a struct
miDataStructReturn = miDataStruct;
miDataStructReturn.miData = EEG;
miDataStructReturn.classes = classes;
miDataStructReturn.trials = trials;
miDataStructReturn.fs = fs;
miDataStructReturn.nClasses = length(unique(classes));
miDataStructReturn.nTrials = length(classes);
miDataStructReturn.nChannels = min(size(EEG));



end