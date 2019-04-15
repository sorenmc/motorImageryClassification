clear;
clc;
close all;
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
F3dB1 = 8;
maxFreq = 30;
order = 4;
fs = 250;
type = 'butter';
%2*m = number of filters, 2*mm = max number of filters


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
    
    
    [tTensor,tClasses] = cnnRusPreprocess(tMIData,bandFilters,256);
    [eTensor,eClasses] = cnnRusPreprocess(eMIData,bandFilters,256);
    
    
    allEClasses = [allEClasses;eClasses];
    allTClasses = [allTClasses;tClasses];
    
    if(personNumber < 2 )
        allTTensor = tTensor;
        allETensor = eTensor;
    else
        allTTensor = cat(4,allTTensor,tTensor);
        allETensor = cat(4,allETensor,eTensor);
    end
    
    eMIData.classes = allEClasses;
end

%%
validation{1} = allETensor;
validation{2} = categorical(allEClasses);
allTClasses = categorical(allTClasses);

options = rusOps(validation);

layers = rusLayers();
net = trainNetwork(allTTensor,allTClasses,layers,options);

score = predict(net,allETensor);

nTrials = length(allEClasses);
predicted = zeros(nTrials,1);
for trial = 1:nTrials
    
    %the coloumn index of the max value corresponds to the class.
    [~,predClass]= max(score(trial,:));
    predicted(trial) = predClass;
end

accuracyMatrix(personNumber) = accuracy(predicted,eMIData.classes)
% end

z = mean(accuracyMatrix)
%z1 = mean(fAccuracyMatrix)


