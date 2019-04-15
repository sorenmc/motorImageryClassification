% DESCRIPTION OF FUNCTION
% Main function for recording signals
% This function should only be run in Matlab R2013a
%
% AUTHORS OF FUNCTION
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

%% Clearing and deleting recording device, if it exists
if exist('device')
    if device.connected
        delete(device.ai);
        clear device.ai
    end
end

clear variables
close all
clc

% Add path to functions
addpath('Online interface for Matlab 2013');

dbstop if error

% Constant that needs to be set
type = 'OVR';
device.channels = 16;
device.samplerate = 512;
gender = 'male';
age = '23';
BCIexperience = 'no';

%try1 = ME
saveOpt.root = 'recordings/data_16062018_Nicklas/try';  % Root folder for file saving
saveOpt.subname = 'Nicklas Holm';                       % Name of subject
device.connected = false;

%%
if device.connected
    device.ai = initgUSBamp(device.channels, device.samplerate);    % Initialize amplifier
end
%device = initDevice(device);
%%


nRound = 4;                           % Sets the number of times each class should be trained on
classNames = {'Right hand';'Left hand';'Both feet';'Rest';'Tongue'};  % Defining the types of classes
%timing.initTime = 1;
timing.plusTime = 2;
timing.meTime = 0.25;
timing.miTime = 4;
timing.pauseBiasTime = 1;
timing.pauseVaryTime = 1;
timing.evalPeriod = 0.25;
retrain = false;
k = 1;


%% Setting up figure
set(0,'units','pixels');
pix = get(0,'screensize');

figOpt.width = pix(3);
figOpt.height = pix(4);

figOpt.f = figure('Name','Training session','Visible','on','Color','white','Position',[0,0,figOpt.width,figOpt.height],'WindowKeyPressFcn',@keyPress);

%% Asking if the user wants to retrain from files
text = sprintf('Retrain from files? [y/n]');
updateText(figOpt.f,text,figOpt.width,figOpt.height);

% Waits for user input
[yes, no] = yesOrNo();

if yes
    retrain = true;
elseif no
    retrain = false;
end

text = sprintf('Oki doki, session will begin shortly.');
updateText(figOpt.f,text,figOpt.width,figOpt.height);

%% Specifying files to retrain from
if retrain
    retrainFiles = {'recordings/data_16062018_Nicklas/try/TNicHol_1';...
        'recordings/data_16062018_Nicklas/try/TNicHol_2';...
        'recordings/data_16062018_Nicklas/try/FNicHol_3';...
        'recordings/data_16062018_Nicklas/try/FNicHol_4';...
        'recordings/data_16062018_Nicklas/try_1/FNicHol_5';...
        'recordings/data_16062018_Nicklas/try_1/FNicHol_6';...
        'recordings/data_16062018_Nicklas/try_1/FNicHol_7';...
        'recordings/data_16062018_Nicklas/try_2/FNicHol_8'};
        
    
    for k = 1:length(retrainFiles)
        temp = load(retrainFiles{k});
        data{k} = temp.data;
    end
    
    k = k + 1;
end


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
filename = strcat(folder,sub_short,num2str(k),'-',num2str(time(4)),'.',num2str(time(5)),'.mat');

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



%% Creating training options
trainOpt.OVO = getOVO(length(classNames));
trainOpt.nFilters = mCSP;

%% Retraining classifier
if retrain
    classifier = onlineTrainingOfClassifier(data,trainOpt,bandFilters,type);
end

%% Asking if the user wants to perform ME before MI
text = sprintf('Wants to do ME before MI? [y/n]');
updateText(figOpt.f,text,figOpt.width,figOpt.height);

% Waits for user input
[yes, no] = yesOrNo();

if yes
    doME = true;
elseif no
    doME = false;
end

%% If the user has specified retraining from files ask if he wants to start
% by training with feedback, or if he wants to evaluate performance
if retrain
    text = sprintf('Wants to train with feedback? [y/n]');
    updateText(figOpt.f,text,figOpt.width,figOpt.height);
    
    % Waits for user input
    [yes, no] = yesOrNo();
    
    if yes
        doFeedback = true;
        doEval = false;
    elseif no
        doFeedback = false;
        
        % Asks if evaluation should be performed
        text = sprintf('Wants to evaluate? [y/n]');
        updateText(figOpt.f,text,figOpt.width,figOpt.height);
        
        % Waits for user input
        [yes, no] = yesOrNo();
        
        if yes
            doEval = true;
        elseif no
            doEVal = false;
        end
    end
else
    doFeedback = false;
    doEval = false;
end

%% Do training witout feedback and with ME
doProgram = true;
while doProgram
    
    % Do countdown until session start
    sessionCountdown(figOpt);
    
    % Recording one session of nRound rounds
    if doFeedback || doEval
        [data{k}, score] = doOneRecord(device,timing,figOpt,classNames,nRound,doME,true,type,bandFilters, classifier);
    else
        data{k} = doOneRecord(device,timing,figOpt,classNames,nRound,doME,doFeedback,type);
    end
    
    % Letting the user know session has ended
    text = sprintf('Session %d ended', k);
    updateText(figOpt.f,text,figOpt.width,figOpt.height);
    
    % Save recorded data for this round
    t = tic;
    if exist('score')
        data{k}.score = score;
    end
    if doFeedback
        saveData(data{k},saveOpt,'F',k);
    elseif doEval
        saveData(data{k},saveOpt,'E',k);
    else
        saveData(data{k},saveOpt,'T',k);
    end
    
    % Find accuracy of feedback or evaluation
    if doFeedback || doEval
        [acc(k), pred{k}] = findOnlineAccuracy(score.score,data{k}.class,1);
    end
    
    if doEval
        text = sprintf('Accuracy of session was %.2f%% Continue evaluation? [y/n]', acc(k));
        updateText(figOpt.f,text,figOpt.width,figOpt.height);
        
        % Waits for user input
        [yes, no] = yesOrNo();
        
        if yes
            doEval = true;
        elseif no
            doEval = false;
            doProgram = false;
        end
    end
    
    
    
    if doFeedback
        if exist('acc')
            text = sprintf('Accuracy of session was %.2f%% Continue training with feedback? [y/n]', acc(k));
            updateText(figOpt.f,text,figOpt.width,figOpt.height);
        end
        
        % Waits for user input
        [yes, no] = yesOrNo();
        
        if yes
            doFeedback = true;
            doEval = false;
        elseif no
            doFeedback = false;
            doEval = true;
        end
        
        text = sprintf('Starting training of classifier');
        updateText(figOpt.f,text,figOpt.width,figOpt.height);
        
        % Training classifier based upon the training data recorded
        classifier = onlineTrainingOfClassifier(data,trainOpt,bandFilters,type);
    end
    
    % If it is not giving feedback or evaluating, then it is training
    if ~doFeedback && ~doEval && doProgram
        % Asking if training should be continued without feedback
        text = sprintf('Continue training without feedback? [y/n]');
        updateText(figOpt.f,text,figOpt.width,figOpt.height);
        
        % Waits for user input
        [yes, no] = yesOrNo();
        
        if yes
            doFeedback = false;
        elseif no
            doFeedback = true;
            doME = false;
            
            text = sprintf('Starting training of classifier');
            updateText(figOpt.f,text,figOpt.width,figOpt.height);
            
            % Training classifier based upon the training data recorded
            classifier = onlineTrainingOfClassifier(data,trainOpt,bandFilters,type);
        end
    end
    
    % Incrementing file number
    k = k + 1;
end

% Closing figure and clearing recording object
close(figOpt.f)
if device.connected
    delete(device.ai);
    device.ai = 1;
    clear device
end

