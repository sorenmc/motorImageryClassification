

% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


clear;
clc;
close all;

dbstop if error
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
    
    
   
    
    eMIData.classes = eClasses;


%%
tClasses = categorical(tClasses);
eClasses = categorical(eClasses);
validation{1} = eTensor;
validation{2} = eClasses;
options = rusOps(validation);

%%
layers = rusLayers();
net = trainNetwork(tTensor,tClasses,layers,options);
score = predict(net,validation{1});

nTrials = length(eClasses);
predicted = zeros(nTrials,1);
for trial = 1:nTrials
    
    %the coloumn index of the max value corresponds to the class.
    [~,predClass]= max(score(trial,:));
    predicted(trial) = predClass;
end


accuracyMatrix(personNumber) = accuracy(predicted,eMIData.classes)
end
% end

z = mean(accuracyMatrix)
%z1 = mean(fAccuracyMatrix)


