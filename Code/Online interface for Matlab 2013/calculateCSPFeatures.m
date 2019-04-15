function [feature] = calculateCSPFeatures(miData,w)
% DESCRIPTION OF FUNCTION
% This function calculates the CSP features, by using the previously 
% calculated CSP filters during training.
%
% INPUT
% miData:	Structure that contains MI snippets and corresponding
%           information
% w:        CSP filters calculated during training
%
% OUTPUT:
% feature:  Calculated CSP features to return
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

%Constants
nTrials = miData.nTrials;
trials = miData.trials;
data = miData.miData;


%Calculate feature vector, length(Z(:,1)) = number of filters
features = zeros(nTrials,size(w,2));



for trial = 1:nTrials
    startTrial = trials(trial);
    
    if(trial ~=nTrials)
        endTrial = trials(trial+1)-1;
    else
        endTrial = size(data,2);%trials(end);
    end
    
    %take one trial out at a time.
    Z = transpose(w)*data(:,startTrial:endTrial);
    ZT = transpose(data(:,startTrial:endTrial))*w;
    zDiag = diag(Z*ZT);
    zTrace = sum(zDiag);
    features(trial,:) = transpose(log10(zDiag/zTrace));
end
feature = features;

end
