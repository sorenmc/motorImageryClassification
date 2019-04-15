% DESCRIPTION OF FUNCTION
% This function simulates recording of data, to try different changes in
% the parameters after recording has ended.
% Should only be run in Matlab R2013a
%
% AUTHORS OF FUNCTION
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

clear variables
close all
clc

% Add path to functions
addpath('Online interface for Matlab 2013');

dbstop if error

types = {'OVO','OVR','OVO1'};

for typeCount = 1:3
    
    type = types{typeCount};
    % Load files
    addpath('C:\Users\Nicklas Holm\OneDrive\Dokumenter\DTU\Bachelorcode\Code\Online interface for Matlab 2013 (experimentel)\recordings\data_16062018\final');
    files = {   '1TSørChr_1.mat',...
                '2TSørChr_2.mat',...
                'FSørChr_3.mat',...
                'FSørChr_4.mat',...
                'FSørChr_5.mat',...
                'FSørChr_6.mat',...
                'FSørChr_7.mat',...
                'X1ESørChr_8.mat',...
                'X2ESørChr_9.mat',...
                'X3ESørChr_10.mat',...
                'X4ESørChr_11.mat',...
                'X5ESørChr_12.mat'};
            
            
    for i = 1:7
        temp = load(files{i});
        tData{i} = temp.data;
    end
    for i = 8:12
        temp = load(files{i});
        eData{i-7} = temp.data;
    end
    
    %% Initializing filters
    printTime();
    fprintf('Initializing filters...\n')
    nBands = 6;
    F3dB1 = 4;
    maxFreq = 38;
    order = 4;
    mCSP = 1;
    bandFilters = initializeFilter(nBands,F3dB1,maxFreq,order,512,'butter');
    printTime();
    fprintf('Filters initilized!\n')
    
    singleTrainOpt.nClasses = 5;
    singleTrainOpt.bandFilters = bandFilters;
    
    % Training classifier
    trainOpt.OVO = getOVO(5);
    trainOpt.nFilters = mCSP;
    classifier = onlineTrainingOfClassifier(tData,trainOpt,bandFilters,type);
    
    
    %% Simulating evaluation
    windowLength = 1;
    samplerate = 512;
    for i = 1:length(eData)
        predScore = [];
        for h = 1:length(eData{i}.miData)
            doTrial = true;
            k = [1 128];
            c = 1;
            predScoreSum = 0;
            miData{1,length(eData{i}.miData)} = [];
            j = 1;
            
            % Remove NaN
            n = isnan(eData{i}.miData{h});
            ind = n(1,:);
            eData{i}.miData{h}(:,ind) = [];
            
            while doTrial
                if size(tData{i}.miData{h},2) < k(2)
                    miData{h} = [miData{h}, eData{i}.miData{h}(:,k(1):end)];
                    doTrial = false;
                else
                    miData{h} = [miData{h}, eData{i}.miData{h}(:,k(1):k(2))];
                end
                
                % Windowing
                if size(miData{h},2) >= samplerate*windowLength;
                    window = findWindow(miData{h},samplerate,windowLength);
                    
                    % Predicting which class the newly recorded data belongs to
                    if(strcmp(type,'OVO'))
                        [predClass(h,c), predScore{h,c}] = classifySingleTrial(window,singleTrainOpt,classifier);
                    elseif(strcmp(type,'OVR'))
                        [predClass(h,c), predScore{h,c}] = classifySingleTrialOVR(window,singleTrainOpt,classifier);
                    elseif strcmp(type,'OVO1')
                        [predClass(h,c)] = classifySingleTrialOVO1(window,singleTrainOpt,classifier);
                    end
                    
                    if ~strcmp(type,'OVO1')
                        predScoreSum = predScoreSum + predScore{h,c};
                    end
                    
                    
                    c = c + 1;
                end
                
                
                k = k + 128;
            end
            
            if ~strcmp(type,'OVO1')
                [~, bestClass(h)] = max(predScoreSum);
            else
                [~,~,res] = mode(predClass(h,:));
                
                if length(res) == 1
                    bestClass(h) = mode(predClass(h,:));
                else
                    disp('Uncertain - trying again')
                    bestClass(h) = classifySingleTrialOVO1(miData{h}, singleTrainOpt, classifier);
                end
            end
            
            fprintf('Trial %d of %d in session %d completed!\n', h, length(eData{i}.miData), i)
        end
        
        dataToReturn{i}.miData = miData;
        dataToReturn{i}.class = eData{i}.class;
        
        predict{typeCount,i}.class = predClass;
        predict{typeCount,i}.score = predScore;
        predict{typeCount,i}.bestClass = bestClass;
    end
    
    
    %% Finding accuracy
    for i = 1:length(eData)
        if ~strcmp(type,'OVO1')
            [acc(typeCount,i), pred{typeCount,i}] = findOnlineAccuracy(predict{typeCount,i}.score,eData{i}.class,1);
            
            accClass(typeCount,i) = accuracy(predict{typeCount,i}.bestClass,eData{i}.class);
        else
            acc(typeCount,i) = accuracy(predict{typeCount,i}.bestClass,eData{i}.class);
        end
    end
    
end

mean(acc')