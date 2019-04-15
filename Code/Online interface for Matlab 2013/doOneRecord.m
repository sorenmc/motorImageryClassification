function [data, pred] = doOneRecord(device, timing, figOpt, classNames, nRound, doME, doEval,type, bandFilters, classifier)
% DESCRIPTION OF FUNCTION
% This function records one session of data, and then returns the recorded 
% data.	
%
% INPUT
% device:           Recording device to use
% timing:           Values for the timing of the program (How long pause,
%                   how long MI,...)
% figOpt:           Options for the figure.
% classNames:       Names of the different classes to train
% nRound:           Number of rounds in each session
% doME:             Logical variable specifying if ME should be done
% doEval:           Logical variable specifying if evaluation should be done
% type:             Type of classification: OVO, OVR, OVOe
% bandFilters:      Bandfilters used for filtering data before
%                   classification
% classifier:       Classifier used for classification
%
% OUTPUT:
% dara:             Recorded data to return
% pred:             Predicted classes and probabilities to return
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Calculate number of classes and constructing vector of classes and class
% counter
nClasses = length(classNames);
classVec = 1:nClasses;
classCounter = zeros(1,nClasses);

% Calculate number of trials
nTrials = nClasses * nRound;

% Creating training struct for evaluation
if doEval
    singleTrainOpt.nClasses = nClasses;
    singleTrainOpt.bandFilters = bandFilters;
end

% Extracting variables from device struct
deviceConnected = device.connected;
samplerate = device.samplerate;
channels = device.channels;
if deviceConnected
    ai = device.ai;
end

% Extracting variables from timing struct
plusTime = timing.plusTime;
meTime = timing.meTime;
miTime = timing.miTime;
pauseBiasTime = timing.pauseBiasTime;
pauseVaryTime = timing.pauseVaryTime;
evalPeriod = timing.evalPeriod;

%% Initializing variables for saving data
dataBefore{1,nTrials} = [];
dataAfter{1,nTrials} = [];
miData{1,nTrials} = [];                    	 	% EEG is stored in this vector
meData{1,nTrials} = [];

pred = [];

clearBuffer(device);

tVec = 0:1/1e3:0.5;
tVec = tVec(1:128);

for i = 1:nTrials
    beep;
    % Clearing green box if it exist
    updateText(figOpt.f,'',figOpt.width,figOpt.height,'bot');
    
    % Focus on the plus sign
    updateText(figOpt.f,'+',figOpt.width,figOpt.height);
    if deviceConnected
        nSamples = samplerate*plusTime;
        while ai.SamplesAcquired < nSamples;
        end
        dataBefore{i} = [dataBefore{i}; getdata(ai,nSamples)];
    else
        pause(plusTime)
        dataBefore{i} = [dataBefore{i}; rand(round(samplerate*plusTime),channels)];
    end
    
    % Picks the next class to be trained on
    [class(i), classCounter] = pickClass(classVec, classCounter, nRound);
    
    if doME
        % ME session
        text = sprintf('Execution : %s', classNames{class(i)});
        updateText(figOpt.f,text,figOpt.width,figOpt.height);
        if deviceConnected
            nSamples = samplerate*meTime;
            while ai.SamplesAcquired < nSamples
            end
            meData{i} = [meData{i}; getdata(ai,nSamples)];
            getdata(ai,samplerate);
        else
            pause(meTime)
            meData{i} = [meData{i}; rand(round(samplerate*meTime),channels)];
            % pause(1)
        end
        
        updateText(figOpt.f,'',figOpt.width,figOpt.height);
    end
    if deviceConnected
        getdata(ai,samplerate*0.5);
    else
        % pause(0.5)
    end
    
    clearBuffer(device);
    
    tic
    % MI session
    text = sprintf('Imagery : %s', classNames{class(i)});
    updateText(figOpt.f,text,figOpt.width,figOpt.height);
    nSamples = samplerate*miTime;
    nSamplesEval = nSamples;
    if doEval
        nSamplesEval = samplerate*evalPeriod;
    end
    % As long as there should be samples more data, keep recording
    c = 1; % Variable to keep track of number of predictions
    predScoreSum = zeros(1,nClasses);
    while size(miData{i},2) < nSamples
        if deviceConnected
            while ai.SamplesAcquired < nSamplesEval
            end
            miData{i} = [miData{i}, getdata(ai,nSamplesEval)'];
        else
            pause(nSamplesEval/samplerate)
            randData = (class(i)*rand(round(nSamplesEval),channels))';
            % sinData = sin(tVec*class(i)*100);
            miData{i} = [miData{i}, randData];
        end
        if doEval
            % Finding window
            windowLength = 1;
            if size(miData{i},2) >= samplerate*windowLength;
                window = findWindow(miData{i},samplerate,windowLength);
                
                % Predicting which class the newly recorded data belongs to
                if(strcmp(type,'OVO'))
                    [predClass(i,c), predScore{i,c}] = classifySingleTrial(miData{i},singleTrainOpt,classifier);
                elseif(strcmp(type,'OVR'))
                    [predClass(i,c), predScore{i,c}] = classifySingleTrialOVR(miData{i},singleTrainOpt,classifier);
                end
                
                % Summing the predictions scores together and finds the
                % class with highest probability
                predScoreSum = predScoreSum + predScore{i,c};
                
                % Checking if green box should be shown
                if size(miData{i},2) > samplerate*windowLength*2;
                    % Checks if recording has been done for long enough time to make
                    % estimated guess of class
                    [~, bestGuess] = max(predScoreSum);
                    
                    % If the class with the highest probability is the class to
                    % evaluate on, then a green box is shown
                    if class(i) == bestGuess
                        updateText(figOpt.f,'correct',figOpt.width,figOpt.height,'bot');
                    else
                        updateText(figOpt.f,'',figOpt.width,figOpt.height,'bot');
                    end
                end
                c = c + 1;
            end
            
        end
    end
    toc
    
    % Pause session
    updateText(figOpt.f,'',figOpt.width,figOpt.height);
    pauseTime = (pauseBiasTime + pauseVaryTime*rand());
    if deviceConnected
        nSamples = round(samplerate*pauseTime);
        while ai.SamplesAcquired < nSamples;
        end
        dataAfter{i} = [dataAfter{i}; getdata(ai,nSamples)];
    else
        pause(pauseTime)
        dataAfter{i} = [dataAfter{i}; rand(round(samplerate*pauseTime),channels)];
    end
    fprintf('Trial %d out of %d ended\n', i, nTrials)
    
    
    % Checking if score is empty
    if isempty(predScoreSum)
        2+2;
    end
end

% Clearing green box if it is there
updateText(figOpt.f,'',figOpt.width,figOpt.height,'bot');

% Assigning data recorded to output argument data
data.dataBefore = dataBefore;
data.meData = meData;
data.miData = miData;
data.dataAfter = dataAfter;
data.class = class;

% Assigning data to output argument pred
if exist('predClass')
    pred.class = predClass;
    pred.score = predScore;
end

end

