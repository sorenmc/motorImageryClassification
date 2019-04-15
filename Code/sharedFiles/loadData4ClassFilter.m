function miDataStructReturn = loadData4ClassFilter(datafile,lowPass, run)
% DESCRIPTION OF FUNCTION
% This function loads in the data from the training file for dataset 2A,
% and then applies a filter
%
% INPUT
% datafile:     File location of the datafile that needs to be loaded
% lowPass:      Filter to apply to the data
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
data = load(datafile);

% Finding number of sessions (Is not the same for all subjects)
nSessions = size(data.data,2);

% Checking if 'run' parameter exists
if ~exist('run','var')
    % run parameter does not exist, so all data runs with trials are selected
    run = nSessions-5:nSessions;
end

nChannels = 22;
% Creating empty arrays for channels, classes and trials
EEG = zeros(0,nChannels);
EOG = zeros(0,3);
classes = zeros(0,1);
trials = zeros(0,1);
artifacts = zeros(0,1);
% Initializing nSamples to 0, since first trial array does not need to be
% shifted by the number of samples
nSamples = 0;

% For loop either load in the selected classes
for i = run
    trials = [trials; data.data{1,i}.trial + nSamples];
    
    
    % Calculating number of samples, so the trial values are being shifted
    % for the different number of runs
    
    nTrials = length(trials);
    
    if (isempty(data.data{1,i}.artifacts))
        artifacts = [artifacts;zeros(nTrials,1)];
    else
        artifacts = [artifacts;data.data{1,i}.artifacts];
    end
    EEG = [EEG; data.data{1,i}.X(:,1:nChannels)];
    EOG = [EOG; data.data{1,i}.X(:,23:25)];
    
    classes = [classes; data.data{1,i}.y];
    
    nSamples = size(EEG, 1);
    
end

%EEG = EEG*10^6;
%low pass filter
EEG = filtfilt(lowPass.filterVector{1},EEG);

EEG = expoStandardization(EEG);



% Orienting dataset in the correct way
EEG = flipDataSet(EEG);
EOG = flipDataSet(EOG);





% Finding the MI snippets
if(datafile(end) == 'T')
    miStart =3;
    miEnd = 6;
else
    miStart = 3;
    miEnd = 6;
end
    
    


% Loading the sampling frequency
fs = data.data{1,1}.fs;
[EEG,trials] = findMISnippets(EEG,trials,fs,miStart,miEnd);
%[EOG,~] = findMISnippets(EOG,trials,fs,miStart,miEnd);
%EEG = eogRemoval (EEG,EOG,trials);
EEG(:,end) = [];
if(datafile(end) == 'T')
    %[EEG,trials,classes] = artifactRemoval(EEG, trials, classes, artifacts);
end



%Data to return is saved in a struct
miDataStructReturn = miDataStruct;
miDataStructReturn.miData = EEG;
miDataStructReturn.classes = classes;
miDataStructReturn.trials = trials;
miDataStructReturn.fs = fs;
miDataStructReturn.nClasses = length(data.data{1,1}.classes);
miDataStructReturn.nTrials = length(classes);
miDataStructReturn.nChannels = min(size(EEG));



end