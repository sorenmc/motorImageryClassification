clear;
clc;
close all;

close(findall(groot,'Tag','NNET_CNN_TRAININGPLOT_FIGURE'));

files = dir('*.mat');
for k = 1:length(files)
    currentFile = files(k).name;
    delete(currentFile);
end

%hvis der er error laver den et breakpoint
%dbstop if error

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%INITIALIZE CONSTANTS%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nPersons = 9;
nChannels = 22;
nClasses = 4;
nClassifiers = 1;
nBands = 1;
F3dB1 = 1;
maxFreq = 38;
order = 3;
fs = 250;
type = 'lbutter';

%2*m = number of filters, 2*mm = max number of filters


%%%%%%%%%%%%%INITIALIZE DATA%%%%%%%%%%%%%%%%%%%%%%%%%%%%
accuracyMatrix = zeros(nPersons,nClassifiers);
fAccuracyMatrix = accuracyMatrix;

%%%%%%%%%%%%%%%%MAKE FILTERS%%%%%%%%%%%%%%%%%%%%%%%%%%%
bandFilters = initializeFilter(nBands,F3dB1,maxFreq,order,fs,type);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%MAIN LOOP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainData =  zeros(nChannels,0);
valData =  zeros(nChannels,0);

trainClasses = zeros(288,0);
valClasses = zeros(288,0);
tic
for personNumber = 1:nPersons
    %%%%%%%%%%%    %LOAD DATA%    %%%%%%%%%%%
    ProcessT = sprintf('TestSet/A0%dT',personNumber);
    ProcessE = sprintf('TestSet/A0%dE',personNumber);
    [tMIData] = loadData4ClassFilter(ProcessT,bandFilters);
    [eMIData] = loadData4ClassFilter(ProcessE,bandFilters,4:6);
    
    
    trainData = cnnPreprocess(tMIData,bandFilters);
    trainClasses = categorical(tMIData.classes);
    evalData = cnnPreprocess(eMIData,bandFilters);
    evalClasses = categorical(eMIData.classes);
    
    validation{1} = evalData;
    validation{2} = evalClasses;
    
        
    %%%%%%%%%%%%%%%%%%LAYERS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
    layers = shallowLayers(nChannels,750);
    
    options = trainOps(validation);
    %%%%%%%%%%%%%%%
    %TRAIN NETWORK%
    %%%%%%%%%%%%%%%
    neuralNetwork = trainNetwork(trainData,trainClasses,layers,options);
    
    info = load('temp.mat');
    info = info.info;
    
    net = getBestEpoch(info);
    neuralNetwork = trainNetwork(trainData,trainClasses,net,options);
    
    info = load('temp.mat');
    info = info.info;
    
    net = getBestEpoch(info);
    
    
    
    ProcessE = sprintf('TestSet/A0%dE',personNumber);
    [fMIData] = loadData4ClassFilter(ProcessE,bandFilters,7:9);
    finalData = cnnPreprocess(fMIData,bandFilters);
    
    %
    %         valData = cnnPreprocess(eMIData,bandFilters);
    %     valClasses = categorical(eMIData.classes);
    
    score = predict(neuralNetwork,finalData);
    
    predicted = zeros(fMIData.nTrials,1);
    for trial = 1:fMIData.nTrials
        
        %the coloumn index of the max value corresponds to the class.
        [~,predClass]= max(score(trial,:));
        predicted(trial) = predClass;
    end
    
    fAccuracyMatrix(personNumber) = accuracy(predicted,fMIData.classes);
    
    close(findall(groot,'Tag','NNET_CNN_TRAININGPLOT_FIGURE'));
    
end

%z = mean(accuracyMatrix)
z1 = mean(fAccuracyMatrix)


%layers = [imageInputLayer([nChannels,size(trainData,2),1])
%         convolution2dLayer([1,25],40,'NumChannels',1)
%         convolution2dLayer([nChannels,1],40,'NumChannels',40)
%         batchNormalizationLayer
%         batchNormalizationLayer('ScaleL2Factor',0.1)
%         
%         squareLayer
%         averagePooling2dLayer([1,75],'Stride',[1,15])
%         logLayer
%         dropoutLayer
%         convolution2dLayer([1,44],4,'NumChannels',40)
%         
%         
%         softmaxLayer
%         %logLayer
%         classificationLayer];


