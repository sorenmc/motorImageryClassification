% DESCRIPTION OF FUNCTION:
% Used for testing our data offline . 
% This is not using sliding windows
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

clear;
clc;
close all;
%hvis der er error laver den et breakpoint
dbstop if error

addpath('FBCSP');
addpath('sharedFiles');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%INITIALIZE CONSTANTS%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nPersons = 1;
nChannels = 16;
nClasses = 5;
nClassifiers = 3;
nBands = 6;
F3dB1 = 4;
maxFreq = 38;
order = 4;
fs = 512;
type = 'butter';
cTypes = {'OVO','OVR','OVO1'};



%2*m = number of filters, 2*mm = max number of filters
nFilters = floor(nChannels/2);
nFilters = 1;
meanMatrix = cell(2,nFilters);

OVO = getOVO(nClasses);
personNumber = 1;

%%%%%%%%%%%%%INITIALIZE DATA%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%MAKE FILTERS%%%%%%%%%%%%%%%%%%%%%%%%%%%
bandFilters = initializeFilter(nBands,F3dB1,maxFreq,order,fs,type);


accuracyMatrix = zeros(nPersons,nClassifiers);
fAccuracyMatrix = accuracyMatrix;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%MAIN LOOP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%
%LOAD DATA%
%%%%%%%%%%%
file = 'C:\Users\Nicklas Holm\OneDrive\Dokumenter\DTU\Data til aflevering\Data_6.mat';
for ind = 1:3
    cType = cTypes{ind};
    
    tMIData = loadDataEEG(file,nChannels,1:7);
    eMIData = loadDataEEG(file,nChannels,8:12);
    
    tMIData.OVO = OVO;
    eMIData.OVO = OVO;
    
    %Get Features (with response in last column)
    % 2*m = number of filters to take from the CSP
    %m = 2;
    
    %Training data - spits out training features and CSP filter (w)
    switch cType
        case 'OVR'
            [tPred,w] = fbCspTrainOVR(tMIData,bandFilters,nFilters);
        otherwise
            [tPred,w] = fbCspTrainOVO(tMIData,bandFilters,nFilters);
    end
    
    %Evaluation data takes in previously calculated filter
    ePred = FBCSP(eMIData,bandFilters,w,cType);
    
    
    
    
    %%%%%
    %LDA%
    %%%%%
    if strcmp(cType,'OVR')
        eMIData.classifiers = trainOVR(tMIData,tPred,'LDA');
        figure(1)
        accuracyMatrix(ind,1) = classifyOVR(eMIData,ePred);
    else
        eMIData.classifiers = trainOVO(tMIData,tPred,'LDA');
        figure(1)
        accuracyMatrix(ind,1) = classifyOVO(eMIData,ePred);
    end
    
    %%%%%
    %SVM%
    %%%%%
    if strcmp(cType,'OVR')
        eMIData.classifiers = trainOVR(tMIData,tPred,'SVM');
        figure(2)
        accuracyMatrix(ind,2) = classifyOVR(eMIData,ePred);
    else
        eMIData.classifiers = trainOVO(tMIData,tPred,'SVM');
        figure(2)
        accuracyMatrix(ind,2) = classifyOVO(eMIData,ePred);
    end
    %%%%%
    %NB%%
    %%%%%
    if strcmp(cType,'OVR')
        eMIData.classifiers = trainOVR(tMIData,tPred,'NAB');
        figure(3)
        accuracyMatrix(ind,3) = classifyOVR(eMIData,ePred);
    else
        eMIData.classifiers = trainOVO(tMIData,tPred,'NAB');
        figure(3)
        accuracyMatrix(ind,3) = classifyOVO(eMIData,ePred);
    end
    
end
%%
cTypes
mean(accuracyMatrix')
