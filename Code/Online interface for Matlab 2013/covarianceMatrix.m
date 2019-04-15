function [Ra,Rb] = covarianceMatrix(miData,a,b)
% DESCRIPTION OF FUNCTION
%
% Given a structure miData containing motor imagery data, returns the
% covariance matrixes of class a and b
%
% INPUT
%
% miData:           Structure that contains MI snippets and corresponding
%                   information.
% a:                class 1
% b:                class 2
%
% OUTPUT:
%
% Ra:               Covariance matrix of class a
% Rb:               Covariance matrix of class b
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

%Number of trials
nTrials = miData.nTrials;
%Number of channels

%The data to be used
miDataUse = miData.miData;
%Data time stamps
trials = miData.trials;
%trials = [1:375:nTrials*375];

classes = miData.classes;

%number of trials with label a and b
nA = sum(classes == a);

%2 sums necessary if using OVR
nB = 0;
for i = 1:length(b)
nB = nB + sum(classes == b(i));
end


Ra = zeros(size(miDataUse,1),size(miDataUse,1));
Rb = zeros(size(miDataUse,1),size(miDataUse,1));

for i=1:nTrials
    startN = trials(i);
    if (i ~= nTrials)
        
        endN = trials(i+1)-1;
    else
        %get the last samp
        endN = size(miDataUse,2);
    end
    
    Xi = miDataUse(:, startN:endN );
    if (classes(i) == a)
        Ra = (Xi*transpose(Xi))/trace(Xi*transpose(Xi)) + Ra;
     elseif(sum(classes(i) == b))
        Rb = (Xi*transpose(Xi))/trace(Xi*transpose(Xi)) + Rb;
    end
    
end

Ra = Ra/nA;
Rb = Rb/nB;

end

