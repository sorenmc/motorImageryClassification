% DESCRIPTION OF FUNCTION
% Main of dataset 2a with FBCSP extended as OVO inspired by
%
% "Filterbank commonspatial pattern algorithm on 
%  BCIcompetition IV Datasets 2a and 2b"
% by Kai Keng Ang, Zheng Yang Chin, Chuanchu Wang
% Cuntai Guan & Haihong Zhang
% -2012
% AUTHORS OF FUNCTION
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk




clear;
clc;
close all;

%if there is a run time error - add breakpoint
dbstop if error

%look in FBCSP, TestSet and sharedFiles folder
addpath('FBCSP')
addpath('TestSet')
addpath('sharedFiles')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%INITIALIZE CONSTANTS%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%68.48 on
%nFilters = 1
%nBands = 7
%minFreq = 4 
%maxFreq = 34
%order = 4
% 3 to 6 seconds
% with artifact removal
% without channel extension!

nPersons = 9;
nChannels = 22;
nClasses = 4;
nClassifiers = 3;
%2*m = number of filters, 2*mm = max number of filters
nFilters = 1;
nBands = 7;
minFreq = 4;
maxFreq = 34;
order = 4;
fs = 250;
type = 'butter';
%extend amount of channels if true
extendChannels = false;
%artifact removal if set true
artifacts = true;
%start and end time of MI
staEnd = [3,6];


meanMatrix = cell(2,nFilters);
predAll = zeros(1,0);
classesAll = predAll;
OVO = getOVO(nClasses);


%%%%%%%%%%%%%INITIALIZE DATA%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LDAData = zeros(nPersons);
SVMData = zeros(nPersons);
NABData = zeros(nPersons);
dataAll = zeros(nPersons,nClassifiers);

%%%%%%%%%%%%%%%%MAKE FILTERS%%%%%%%%%%%%%%%%%%%%%%%%%%%



bandFilters = initializeFilter(nBands,minFreq,maxFreq,order,fs,type);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%MAIN LOOP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for personNumber = 1:nPersons
    %%%%%%%%%%%
    %LOAD DATA%
    %%%%%%%%%%%
    
    ProcessT = sprintf('TestSet/A0%dT',personNumber);
    ProcessE = sprintf('TestSet/A0%dE',personNumber);
    [tMIData] = loadData4Class(ProcessT,nChannels,staEnd,artifacts);
    [eMIData] = loadData4Class(ProcessE,nChannels,staEnd,artifacts,4:9);
    
    
    tMIData.OVO = OVO;
    eMIData.OVO = OVO;
    
    %Training data - spits out training features and CSP filter (w)
    [tPred,w] = fbCspTrainOVO(tMIData,bandFilters,nFilters,extendChannels);
    
    %Evaluation data takes in previously calculated filter
    ePred = FBCSP(eMIData,bandFilters,w,'OVO',extendChannels);
    
    
    eClasses = eMIData.classes;
    %%%%%
    %LDA%
    %%%%%
    
    eMIData.classifiers = trainOVO(tMIData,tPred,'LDA');
    dataAll(personNumber,1) = classifyOVO(eMIData,ePred);
    
    %%%%%
    %SVM%
    %%%%%
    eMIData.classifiers = trainOVO(tMIData,tPred,'SVM');
    dataAll(personNumber,2) = classifyOVO(eMIData,ePred);
    
    %%%%%
    %NB%%
    %%%%%
    eMIData.classifiers = trainOVO(tMIData,tPred,'NAB');
    dataAll(personNumber,3) = classifyOVO(eMIData,ePred)
end

mean(dataAll)
%save LDAData.mat LDAData
%save SVMData.mat SVMData
%save NABData.mat NABData

%%

subVec = 1:9;
bar(subVec,dataAll)
grid on
ylim([0,100])
xlabel('Subject Number')
ylabel('Accuracy [%]')
legend('Linear Discriminant Analysis', 'Support Vector Machine','Naive Bayes')
%print('Plots/FBCSPOVO/barPlot','-depsc')

%plotconfusion(categorical(classesAll'),categorical(predAll'))
























