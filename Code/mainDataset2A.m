% DESCRIPTION OF FUNCTION
% Main of VDFS. We later found out that this algorithm is very similar to
% LDA used for feature reduction.
%
% "On the Improvement of Classifying EEG Recordings Using Neural Networks"
% by Yiran Zhao, Shuochao Yao, Shaohan Hu, 
% Shiyu Chang, Raghu Ganti, Mudhakar Srivatsa, Shen Li & Tarek Abdelzaher 
% -2017
% AUTHORS OF FUNCTION
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

clear all
close all
clc

% For debugging
dbstop if error

% Adding paths with shared functions
addpath('sharedFiles');

% Adding paths to functions
addpath('Feature Selection');

% Adding path to test set
addpath('TestSet');

% Constants
miLength = 3;
filtOrder = 4;
hpFreq = 5;
bpFreq1 = 3;
bpFreq2 = 65;
lpFreq = 65;
passRipple = 0.01;

hpIirFilt = designfilt('highpassiir','FilterOrder',filtOrder, ...
    'PassbandFrequency',hpFreq,'PassbandRipple',passRipple, ...
    'SampleRate',250);

lpIirFilt = designfilt('lowpassiir','FilterOrder',filtOrder, ...
    'PassbandFrequency',lpFreq,'PassbandRipple',passRipple, ...
    'SampleRate',250);

bpIirFilt = designfilt('bandpassiir','FilterOrder',filtOrder, ...
    'HalfPowerFrequency1',bpFreq1,'HalfPowerFrequency2',bpFreq2, ...
    'SampleRate',250);

% fvtool(lpIirFilt);
% fvtool(hpIirFilt);



% Variables in for loops
windowLength = 1;
overlap = 0.9;
minFreq = 6;
maxFreq = 40;
nBands = 10;
nFeatures = 400;


% Variables that can be set
norm = "data";  % Values: "data","features","both","none"
FType = "multitaper";
windowTrial = "true";
selectType = "variance";

for subject = 1:9
    t0 = tic;
    trainingFile = sprintf('TestSet%sA0%dT', filesep, subject);
    evaluationFile = sprintf('TestSet%sA0%dE', filesep, subject);
    
    % Loading in the data
    tData = loadData4Class(trainingFile, 22);
    eData = loadData4Class(evaluationFile, 22);
    
    tData.miData = filtfilt(lpIirFilt,tData.miData');
    eData.miData = filtfilt(lpIirFilt,eData.miData');
    
    tData.miData = filtfilt(hpIirFilt,tData.miData');
    eData.miData = filtfilt(hpIirFilt,eData.miData');
    
    % Assigning constants to the structures
    tData.miLength = miLength;
    tData.windowLength = windowLength;
    tData.overlap = overlap;
    eData.miLength = miLength;
    eData.windowLength = windowLength;
    eData.overlap = overlap;
    t1a = tic;
    
    if windowTrial == "true"
        % Windowing the training channels
        [tData.windowData, tData.windowClasses, tData.windowTrials] = windowFunction(tData);
    else
        tData.windowData = tData.miData;
        tData.windowClasses = tData.classes;
        tData.windowTrials = tData.trials;
    end
    
    % Normalizing data if option is set
    if norm == "data"
        [tData.windowData, tData.normValues] = normalizeData(tData.windowData);
    end
    tInit = toc(t1a);
    
    % Find features of the signals
    t1 = tic;
    [featureInfo1, tData.features] = featureTesting(tData.windowData, tData.fs, tData.windowTrials, FType, nBands, minFreq, maxFreq);
    tFeatureFind(subject) = toc(t1);
    
    % Selecting the features with highest variance
    t2 = tic;
    [featureInfo2{subject}, tData.features] = selectFeatures(featureInfo1, tData.features, tData, nFeatures, selectType);
    tFeatureSelect(subject) = toc(t2);
    
    % Training model
    t4 = tic;
    X = tData.features';
    Y = tData.windowClasses;
    
    % Training model
    model = fitcdiscr(X,Y);
    
    tModel(subject) = toc(t4);
    
    % Windowing the evaluation channels
    t5a = tic;
    [eData.windowData, eData.windowClasses, eData.windowTrials] = windowFunction(eData);
    tWindowEval(subject) = toc(t5a);
    
    t5b = tic;
    % Normalizing data
    [eData.windowData] = normalizeData(eData.windowData, tData.normValues);
    tNormalEval(subject) = toc(t5b);
    
    t5c = tic;
    % Find features of the signals
    eData.features = findSelectedFeatures(featureInfo2{subject}, eData, FType);
    tFeatureEval(subject) = toc(t5c);
    
    t5d = tic;
    % Predicting the classes on model
    [pred,score] = predict(model,eData.features);
    
    if iscell(pred)
        pred = str2double(pred);
    end
    tPredictEval(subject) = toc(t5d);
    
    % Combine predictions score
    [~,ScorePredictions] = combinePredictions(pred, eData.nTrials, score,"sum");
    
    [kappa(subject), accuracy(subject)] = findKappaValue(eData.classes,ScorePredictions,4);
    
    tTotal(subject) = toc(t0);
    sprintf('Subject:%d\nTime:%.2f\nScore:%.2f', subject, tTotal(subject),accuracy(subject))
end