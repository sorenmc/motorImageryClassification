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
nPersons = 9;
nChannels = 22;
nClasses = 4;
nClassifiers = 3;
nBands = 6;
F3dB1 = 6;
maxFreq = 30;
order = 2;
fs = 250;
type = 'butter';
%extend amount of channels if true
extendChannels = false;
%artifact removal if set true
artifacts = true;
%start and end time of MI
staEnd = [3,6];


%2*m = number of filters, 2*mm = max number of filters
nFilters = 1;


%%%%%%%%%%%%%INITIALIZE DATA%%%%%%%%%%%%%%%%%%%%%%%%%%%%
accuracyMatrix = zeros(nPersons,nClassifiers);

%%%%%%%%%%%%%%%%MAKE FILTERS%%%%%%%%%%%%%%%%%%%%%%%%%%%
bandFilters = initializeFilter(nBands,F3dB1,maxFreq,order,fs,type);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%MAIN LOOP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
for personNumber = 1:nPersons
    %%%%%%%%%%%
    %LOAD DATA%
    %%%%%%%%%%%
    %Husk at slette artifacts og kun koere 3-6 sekunder
     ProcessT = sprintf('TestSet/A0%dT',personNumber);
    ProcessE = sprintf('TestSet/A0%dE',personNumber);
    [tMIData] = loadData4Class(ProcessT,nChannels,staEnd,artifacts);
    [eMIData] = loadData4Class(ProcessE,nChannels,staEnd,artifacts,4:9);
    
    
    
    
    %Training data - spits out training features and CSP filters (w)
    [pred,w] = fbCspTrainOVR(tMIData,bandFilters,nFilters, extendChannels);
    
    %Evaluation data takes in previously calculated filters
    
    ePred = FBCSP(eMIData,bandFilters,w,'OVR',extendChannels);
    
    
    
    
    %%%%%%%%%
    
    %%%%%%%%%%%%%%%%
    %CLASSIFICATION%
    %%%%%%%%%%%%%%%%
    
    %%%%%
    %LDA%
    %%%%%
    
    %eval
    eMIData.classifiers = trainOVR(tMIData,pred,'LDA');
    accuracyMatrix(personNumber,1) = classifyOVR(eMIData,ePred);
    
    %%%%%
    %SVM%
    %%%%%
    
    %eval
    eMIData.classifiers = trainOVR(tMIData,pred,'SVM');
    accuracyMatrix(personNumber,2) = classifyOVR(eMIData,ePred);
    
    %%%%%
    %NAB%
    %%%%%
    
    %eval
    eMIData.classifiers = trainOVR(tMIData,pred,'NAB');
    accuracyMatrix(personNumber,3) = classifyOVR(eMIData,ePred)
    
end
accuracyMatrix
meanval = mean(accuracyMatrix)
toc

PersonVector = 1:nPersons;

























