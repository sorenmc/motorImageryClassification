function miData = downSample(miData,splits)
% DESCRIPTION OF FUNCTION
% This function downSamples the data and increases the amount of trials by 
% split*nTrials. 
% split has to be an even number
% number of samples has to be an even number
%
% INPUT
% miData:	Datastruct for the data, that will need to be downsampled
% splits:	Number of times the data should be downsampled
%
% OUTPUT:
% miData:   Datastruct for the downsampled data
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

dataUse = miData.miData;
trials = miData.trials;
classes = miData.classes;
nTrials = miData.nTrials;
nSamples = size(dataUse,2);
dataUse = dataUse';
samplesPerTrial = (trials(2)-1)/splits;
useTrials = [1:samplesPerTrial:nSamples];
downSampledData = cell(1,splits);
resClasses = zeros(1,0);
resData = zeros(1,0);


for i = 1:splits
    temp = downsample(dataUse,splits,i-1);
    downSampledData{i} = temp';
end

startN =1;
endN = samplesPerTrial;
for trial = 1:nTrials
    for i = 1:splits
        tempData = downSampledData{i};
        resData = [resData,tempData(:,startN:endN)];
        resClasses = [resClasses;classes(trial)];
    end
    startN = startN+samplesPerTrial;
    endN = endN+samplesPerTrial;
end





miData.miData = resData;
miData.trials = useTrials;
miData.classes = resClasses;

end