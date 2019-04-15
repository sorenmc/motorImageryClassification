function options = trainOpsDeep(validation,L2Reg)
% DESCRIPTION OF FUNCTION
%
% Given validation data this function returns the options used for training
% on the deep neural network that is inspired by
%
% "On the Improvement of Classifying EEG Recordings Using Neural Networks"
% -2017
% by Yiran Zhao, Shuochao Yao, Shaohan Hu, 
% Shiyu Chang, Raghu Ganti, Mudhakar Srivatsa, Shen Li & Tarek Abdelzaher 
% 
%
% INPUT
% imageSize:    2d image input size specified as a 2d vector containing
%               % dimensions [height,width] of the input
%
% OUTPUT:
% layers:       contains the layers with trainable weights. This is used as
%               input to the neural network training function
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

maxEpochs = 100;
batchSize = 50;
initialLearnRate = 0.01;
validationFreq = 100;
lRateDrop = 0.99;
%0.985
improveIterations = 160;
dropPeriod = 1;
%path = 'C:\Users\SORENMC\OneDrive - Danmarks Tekniske Universitet\SeriousBuissness\DTU\6. semester\BachelorProjektGit\Code';
if(nargin < 2)
    L2Reg =  0.0001;
    %L2Reg =  0.0007;
end


  options = trainingOptions(...
        'rmsprop',...
        'MaxEpochs',maxEpochs,...
        'MiniBatchSize',batchSize,...
        'Plots','training-progress',...
        'Verbose',false,...
        'ValidationData',validation, ...
        'ValidationPatience',inf,...
        'InitialLearnRate',initialLearnRate, ...
        'ValidationFrequency',validationFreq, ... 
        'L2Regularization',L2Reg,...
        'LearnRateSchedule','piecewise',...
        'LearnRateDropFactor',lRateDrop,... 
        'LearnRateDropPeriod',dropPeriod,...
        'Shuffle','every-epoch', ...
        'ExecutionEnvironment','gpu');
    
    
    
end
    
    