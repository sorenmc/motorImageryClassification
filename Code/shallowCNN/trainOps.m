function options = trainOps(validation,L2Reg)
maxEpochs = 1600;
batchSize = 60;
validationFreq = 3;
improveIterations = 160;
if(nargin < 2)
    L2Reg = 0.002;
end
initialLearnRate = 0.001;
dropPeriod = 40

  options = trainingOptions('adam','MaxEpochs'...
        ,maxEpochs,'MiniBatchSize',batchSize,'Verbose',0,'ValidationData',validation ...
        ,'ValidationPatience',inf,'InitialLearnRate',initialLearnRate ...
        ,'ValidationFrequency',validationFreq ...  
        ,'OutputFcn',@(info)checkIfOverfittingCopy(info,improveIterations,0.1)...
        ,'LearnRateSchedule','piecewise','LearnRateDropFactor',0.9...
         ,'L2Regularization',L2Reg, 'CheckpointPath', 'C:\Users\SORENMC\OneDrive - Danmarks Tekniske Universitet\SeriousBuissness\DTU\6. semester\BachelorProjektGit\Code'...
        ,'LearnRateDropPeriod',dropPeriod,'Shuffle','every-epoch' ...
        ,'Plots','training-progress','ExecutionEnvironment','gpu');
    
    
    %,'OutputFcn',@(info)checkIfOverfittingCopy(info,5)...
end
    
    