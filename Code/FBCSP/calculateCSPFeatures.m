function [feature] = calculateCSPFeatures(miData,w)
% DESCRIPTION OF FUNCTION
%
% given input data contained in the structure miData and a set of CSP
% filters contain in w, this function will return CSP features
%
% INPUT
%
% miData:           Structure that contains MI snippets and corresponding
%                   information.
%
% w:                2*m CSP filters contained in a matrix of size 
%                   nChannels x 2m. m is specified in main
%
% OUTPUT:
%
% feature:          features corresponding to the input CSP filters.
%                   a matrix of size [nTrials x 2m]
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

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
        endTrial = size(data,2);
    end
    
    %take one trial out at a time.
    dataUse = data(:,startTrial:endTrial);
    Z = transpose(w)*dataUse;
    ZT = transpose(dataUse)*w;
    zDiag = diag(Z*ZT);
    zTrace = sum(zDiag);
    features(trial,:) = transpose(log10(zDiag/zTrace));
end
feature = features;

end
