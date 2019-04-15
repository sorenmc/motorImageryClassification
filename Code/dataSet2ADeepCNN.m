% DESCRIPTION OF FUNCTION
% Main of dataset 2a a subject specific deep neural network inspired by 
%
% "On the Improvement of Classifying EEG Recordings Using Neural Networks"
% by Yiran Zhao, Shuochao Yao, Shaohan Hu, 
% Shiyu Chang, Raghu Ganti, Mudhakar Srivatsa, Shen Li & Tarek Abdelzaher 
% -2017
% AUTHORS OF FUNCTION
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk




clear;
clc;
close all;
%hvis der er error laver den et breakpoint
%dbstop if error

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
order = 2;
fs = 250;
type = 'butter';


%%%%%%%%%%%%%INITIALIZE DATA%%%%%%%%%%%%%%%%%%%%%%%%%%%%
accuracyMatrix = zeros(nPersons,nClassifiers);
fAccuracyMatrix = accuracyMatrix;

%%%%%%%%%%%%%%%%MAKE FILTERS%%%%%%%%%%%%%%%%%%%%%%%%%%%
bandFilters = initializeFilter(nBands,F3dB1,maxFreq,order,fs,type);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%MAIN LOOP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainData =  zeros(25,0);
valData =  zeros(25,0);

tClasses = zeros(288,0);
valClasses = zeros(288,0);
tic
for personNumber = 1:nPersons
    
    %%%%%%%%%%%    %LOAD DATA%    %%%%%%%%%%%
    ProcessT = sprintf('TestSet/A0%dT',personNumber);
    ProcessE = sprintf('TestSet/A0%dE',personNumber);
    [tMIData] = loadData4Class(ProcessT,25);
    [eMIData] = loadData4Class(ProcessE,25,4:9);
    
    
    [tTensor,tClasses] = cnnDeepPreprocess(tMIData,bandFilters);
    [eTensor,eClasses] = cnnDeepPreprocess(eMIData,bandFilters);
    
    tMIData.classes = tClasses;
    eMIData.classes = eClasses;
    
    %[trainInd,valInd] = dividerand(length(tClasses),0.9,0.1);
    
    %validation{1} = tTensor(:,:,:,valInd);
    %validation{2} = categorical(tClasses(valInd));
    
    %tTensor = tTensor(:,:,:,trainInd);
    %tClasses = categorical(tClasses(trainInd));
    
    
    validation{1} = eTensor;
    validation{2} = categorical(eClasses);
    tClasses = categorical(tClasses);
    
    
    options = trainOpsDeep(validation);
    
    %%%%%%%%%%%%
    %%%LAYERS%%%
    %%%%%%%%%%%%
    layers = deepLayers([nChannels,375]);
    
    
    
    %%%%%%%%%%%%%%%
    %TRAIN NETWORK%
    %%%%%%%%%%%%%%%
    
    
    net = trainNetwork(tTensor,tClasses,layers,options);
    
    score = predict(net,eTensor);
    
    predicted = zeros(288*2,1);
    for trial = 1:288*2
        
        %the coloumn index of the max value corresponds to the class.
        [~,predClass]= max(score(trial,:));
        predicted(trial) = predClass;
    end
    
    accuracyMatrix(personNumber) = accuracy(predicted,eMIData.classes)
    % end
end

z = mean(accuracyMatrix)
%z1 = mean(fAccuracyMatrix)


