clear all
close all
clc
% DESCRIPTION OF FUNCTION
% used to load recorded data, and results of these
% AUTHORS OF FUNCTION
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



% Init folder with functions
addpath('Online interface for Matlab 2013');

% Load data
fileName = 'C:\Users\Nicklas Holm\OneDrive\Dokumenter\DTU\Data til aflevering\Data_6.mat';
evalTrials = 8:12;


data = load(fileName);
data = data.resultingData;

% Go thorugh each session and extract score and true class, if score exist
c = 0;
for i = 1:length(data)
    if isfield(data{i}.data,'score')
        c = c + 1;
        class{c} = data{i}.data.class;
        score{c} = data{i}.data.score;
    end
end

% Go through each session containing score, and calculate the accuracy
for i = 1:length(class)
    acc(i) = findOnlineAccuracy(score{i}.score, class{i}, bias);
end

evalAcc = mean(acc(evalTrials-length(data)+c));

evalKappa = (evalAcc/100-0.2)/(1-0.2);