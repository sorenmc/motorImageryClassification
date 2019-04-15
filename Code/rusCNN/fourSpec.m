function [Tensor,classes] = fourSpec(miData,windowSize)

nTrials = miData.nTrials;
trials = miData.trials;
class = miData.classes;
useData = miData.miData;
classes = zeros(1,0);

Tensor = zeros(22,0,0,0);
for trial = 1:nTrials
    startWindow = 1;
    endWindow = windowSize;
    
    startN = trials(trial);
    
    if (trial~=nTrials)
        endN = trials(trial+1)-1;
    else
        endN = size(useData,2);
    end
    trialData = useData(:,startN:endN);
    trialData = trialData';
    for i = 1:744
        freqWindow = abs(fft(trialData(startWindow:endWindow,:)))';
        if ((trial == 1) && (i ==1))
            Tensor = freqWindow;
        else
            Tensor = cat(4,Tensor,freqWindow);
        end
        classes = [classes;class(trial)];
        startWindow = startWindow+1;
        endWindow = endWindow+1;
        
    end
    
    
end

Tensor = permute(Tensor,[3,2,1,4]);




end