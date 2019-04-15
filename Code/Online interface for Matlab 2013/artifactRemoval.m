function [EEG,trials,classes] = artifactRemoval(EEG, trials, classes, artifacts)
% DESCRIPTION OF FUNCTION
% Removes trials, which contains an artifact.	
%
% INPUT
% EEG:		Matrix containing the data
% trials:	Vector containg timestamps for when a trial starts
% classes:  Vector containing the classes of the trials
% artifacts:Vector containing true/false depending on whether there is an
%           artifact in the specified trial
%
% OUTPUT:
% EEG:		Matrix containg the data
% trials:	Vector containg timestamps for when a trial starts
% classes:  Vector containing the classes of the trials
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

nTrials = length(trials);
oTrials = trials;

for i = 1:nTrials
    
    if(artifacts(i) == 1)
        if(i == nTrials)
            EEG(:,trials(i):end) = inf;
        else
            EEG(:,trials(i):trials(i+1)-1) = inf;
        end
        %remove 1 trial - time stamps are the same for all trials
        oTrials = oTrials(1:length(oTrials)-1);
        %Inf will be taken out afterwards
        classes(i) = inf;  
    end
end

sEEG = size(EEG);
EEG(EEG == inf) = [];
EEG = transpose(vec2mat(EEG,sEEG(1)));
classes(classes == inf) = [];
trials = oTrials;

end
    
