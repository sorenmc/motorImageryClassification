% DESCRIPTION OF FUNCTION
% Main of dataset 2a a general deep neural network inspired by
%
% "On the Improvement of Classifying EEG Recordings Using Neural Networks"
% -2017
% by Yiran Zhao, Shuochao Yao, Shaohan Hu,
% Shiyu Chang, Raghu Ganti, Mudhakar Srivatsa, Shen Li & Tarek Abdelzaher
%
% AUTHORS OF FUNCTION
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


clear;
clc;
close all;

%if there is a run time error - add breakpoint
dbstop if error

%look in deepCNN and sharedFiles folder
addpath('deepCNN')
addpath('sharedFiles')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%INITIALIZE CONSTANTS%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nPersons = 9;
nChannels = 25;
nClasses = 4;
nClassifiers = 1;
nBands = 1;
F3dB1 = 1;
maxFreq = 40;
order = 4;
fs = 250;
type = 'butter';
%2*m = number of filters, 2*mm = max number of filters


%%%%%%%%%%%%%INITIALIZE DATA%%%%%%%%%%%%%%%%%%%%%%%%%%%%
accuracyMatrix = zeros(nPersons,nClassifiers);

%%%%%%%%%%%%%%%%MAKE FILTERS%%%%%%%%%%%%%%%%%%%%%%%%%%%
bandFilters = initializeFilter(nBands,F3dB1,maxFreq,order,fs,type);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%MAIN LOOP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainData =  zeros(nChannels,0);
valData =  zeros(nChannels,0);

tClasses = zeros(288,0);
evalClasses = zeros(288,0);

allTClasses = zeros(1,0);
allEClasses = zeros(1,0);
allTTensor = zeros(1,0,0,0);
allETensor = zeros(1,0,0,0);

for personNumber = 1:nPersons
    %3,4,6,7,8,9,10
    %for l2reg = 0.000001
    %%%%%%%%%%%    %LOAD DATA%    %%%%%%%%%%%
    
    processT = sprintf('TestSet/A0%dT',personNumber);
    processE = sprintf('TestSet/A0%dE',personNumber);
    
    [tMIData] = loadData4Class(processT,nChannels);
    [eMIData] = loadData4Class(processE,nChannels,4:9);
    
    
    
    [tTensor,tClasses] = cnnDeepPreprocess(tMIData,bandFilters);
    [eTensor,eClasses] = cnnDeepPreprocess(eMIData,bandFilters);
    
    evalClasses = [evalClasses;eMIData.classes];
    allEClasses = [allEClasses;eClasses];
    allTClasses = [allTClasses;tClasses];
    
    if(personNumber < 2 )
        allTTensor = tTensor;
        allETensor = eTensor;
    else
        allTTensor = cat(4,allTTensor,tTensor);
        allETensor = cat(4,allETensor,eTensor);
    end
    
    
end
%%
eMIData.classes = allEClasses;


validation{1} = allETensor;
validation{2} = categorical(allEClasses);

%needs to be categorical to train
allTClasses = categorical(allTClasses);

%get train options
options = trainOpsDeep(validation);

%get layer structure
layers = deepLayers([nChannels,375]);

%train net
net = trainNetwork(allTTensor,allTClasses,layers,options);


%% Inefficient way to find accuracy for each test subject
for personNumber = 1:nPersons
    %3,4,6,7,8,9,10
    %for l2reg = 0.000001
    %%%%%%%%%%%    %LOAD DATA%    %%%%%%%%%%%
    
    processT = sprintf('TestSet/A0%dT',personNumber);
    processE = sprintf('TestSet/A0%dE',personNumber);
    
    [tMIData] = loadData4Class(processT,nChannels);
    [eMIData] = loadData4Class(processE,nChannels,4:9);
    
    
    
    [tTensor,tClasses] = cnnDeepPreprocess(tMIData,bandFilters);
    [eTensor,eClasses] = cnnDeepPreprocess(eMIData,bandFilters);
    
   
    score = predict(net,eTensor);
    %temp1 = downsample(score,2);
    %temp2 = downsample(score,2,1);
    %score = temp1 + temp2;
    
    nTrials = length(eClasses)/2;
    predicted = zeros(nTrials,1);
    for trial = 1:nTrials
        
        %the coloumn index of the max value corresponds to the class.
        
        [~,predClass]= max(score(trial,:));
        predicted(trial) = predClass;
    end
    
    accuracyMatrix(personNumber) = accuracy(predicted,eClasses)
    % end
    
    
end


meanAcc = mean(accuracyMatrix)
%z1 = mean(fAccuracyMatrix)


