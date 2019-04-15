function miDataStructReturn = loadDataEEG(data, nChannels, run)
% DESCRIPTION OF FUNCTION
% This function loads in the data from the training file for dataset 2A
%
% INPUT
% data:         File location of the datafile that needs to be loaded
% nChannels:    Number of channels in file
% run:          Optional parameter, to select a specific run, if not given, 
%               then all six runs are loaded
%
% OUTPUT:
% miDataStructReturn:   Structure that contains MI data and corresponding
%                       information.
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Loading data
data = load(data);
data = data.resultingData;
nSessions = length(data);
miSampleLength = 2048;
trialsPrSession = length(data{1}.data.class);
defaultTrial = [1:miSampleLength:trialsPrSession*miSampleLength];
% Finding number of sessions (Is not the same for all subjects)

% Checking if 'run' parameter exists


% Creating empty arrays for channels, classes and trials
EEG = zeros(nChannels,0);
useMiData = zeros(nChannels,0);
classes = zeros(0,1);
trials = zeros(0,1);
artifacts = zeros(0,1);
% Initializing nSamples to 0, since first trial array does not need to be
% shifted by the number of samples
nSamples = 0;

% For loop either load in the selected classes
for i = run
    useData = data{1,i}.data;
  
    trials = [trials, defaultTrial + nSamples];
  
    
    for semiTrial = 1:length(useData.miData)
        temp = useData.miData{semiTrial};
        %temp = temp(:,1:2048);
        
        %temp = temp';
        useMiData = [useMiData,temp];
    end
    
    EEG = [EEG, useMiData];
    
    classes = [classes, useData.class];
    
    nSamples = size(EEG, 2);
    useMiData = [];
end

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
fs = 512;




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