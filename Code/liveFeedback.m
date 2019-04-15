% DESCRIPTION OF FUNCTION
% This function provides a live feedback to the user, as he/she performs MI
% of classes that he/she decides.
%
% AUTHORS OF FUNCTION
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

%% If device still exist, clear device
if exist('device')
    if device.connected
        delete(device.ai);
        clear device.ai
    end
end

clear variables
close all
clc
dbstop if error

% Add path to functions
addpath('Online interface for Matlab 2013');

% Constants for classification
timing.evalPeriod = 0.25;
timing.windowLength = 1;
timing.dataSave = 10;
classNames = {'Right hand';'Left hand';'Both feet';'Both hands';'Tongue'};
nClasses = length(classNames);

% Constants for saving of data
saveOpt.root = 'recordings/test/liveTest';
saveOpt.subname = 'test test';

%% File saving info
% Create folder if needed and prepare file name
time = clock;
space_location = find(saveOpt.subname==' ');
sub_short = strcat(saveOpt.subname(1:3), saveOpt.subname(space_location+1:space_location+3));
folder = strcat(saveOpt.root,'/');
i = 1;
tempFold = folder;
while exist(tempFold, 'dir')
    tempFold = sprintf('%s_%d/', folder(1:end-1), i);
    i = i + 1;
end
folder = tempFold;
mkdir(folder);
saveOpt.root = folder(1:end-1);

%% Initialize recording device
device.channels = 16;
device.samplerate = 512;
device.connected = false;
if device.connected
    device.ai = initgUSBamp(device.channels, device.samplerate);    % Initialize amplifier
end



% Files to train classifier from
trainFiles = {'recordings/data_14062018/final/TSaerChr_1.mat';...
    'recordings/data_14062018/final/TSaerChr_2.mat';...
    'recordings/data_14062018/final/TSaerChr_3.mat';...
    'recordings/data_14062018/final/FSaerChr_4.mat';...
    'recordings/data_14062018/final/FSaerChr_5.mat';...
    'recordings/data_14062018/final/FSaerChr_6.mat'};

for k = 1:length(trainFiles)
    temp = load(trainFiles{k});
    data{k} = temp.data;
end

%% Initializing filters
printTime();
fprintf('Initializing filters...\n')
nBands = 6;
F3dB1 = 4;
maxFreq = 38;
order = 4;
mCSP = 1;
bandFilters = initializeFilter(nBands,F3dB1,maxFreq,order,device.samplerate,'butter');
printTime();
fprintf('Filters initilized!\n')

%% Train classifier
printTime();
fprintf('Training classifier...\n')
trainOpt.OVO = getOVO(length(classNames));
trainOpt.nFilters = mCSP;
classifier = onlineTrainingOfClassifier(data,trainOpt,bandFilters);
printTime();
fprintf('Classifier trained!\n')

% Sample first bit of data, where only one window exist
time = timing.windowLength - timing.evalPeriod;
data = sampleData(device, time);

% Indicies to keep track of window to cut
ind = [1 device.samplerate*timing.windowLength];
i = 1;
filenum = 1;
sumScore = zeros(1,nClasses);
singleTrainOpt.nClasses = nClasses;
singleTrainOpt.bandFilters = bandFilters;

doProgram = true;
while doProgram
    % Record one bit of data
    data = [data, sampleData(device, timing.evalPeriod)];
    
    % Classify a window of data
    window = data(:,ind(1):ind(2));
    [predClass(i), predScore(i,:)] = classifySingleTrial(window,singleTrainOpt,classifier);
    
    % Comparing last few classifications
    sumScore = sumScore + predScore(i,:);
    % Removing old classififcation
    if i > 4
        sumScore = sumScore - predScore(i-4,:);
        
        
        if sum(round((predScore(i-3,:)+predScore(i-2,:)+predScore(i-1,:)+predScore(i,:))) ~= round(sumScore)) ~= 0
            2 + 2;
        end
    end
    
    % Find max score
    [~,class(i)] = max(sumScore);
    
    % Display class of max score
    fprintf('%s\n', classNames{class(i)})
    
    
    % Clearing sumscore and incrementing i and ind
    i = i + 1;
    ind = ind + timing.evalPeriod*device.samplerate;
    
    % Saving data every 10 seconds
    if size(data,2) > timing.dataSave*device.samplerate;
        t = tic;
        sumScore
        dataToSave.predScore = predScore;
        dataToSave.data = data;
        saveData(data,saveOpt,'L',filenum);
        filenum = filenum + 1;
        ind = [1 device.samplerate*timing.windowLength];
        temp1 = predScore(i-3:i-1,:);
        temp2 = data(:,end-(timing.windowLength-timing.evalPeriod)*device.samplerate+1:end);
        clear predScore predClass data
        predScore = temp1;
        data = temp2;
        i = 4;
        fprintf('Saved file in %.2f seconds!\n', toc(t))
    end
end