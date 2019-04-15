function OVO = getOVO(nClasses)
% DESCRIPTION OF FUNCTION
% This function returns the OVO training and evaluation scheme for nClasses	
%
% INPUT
% nClasses:     Number of classes
%
% OUTPUT
% OVO:          OVO scheme
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


nClassifiers = nClasses*(nClasses-1)/2;

OVO = zeros(nClassifiers,2);
cOVO = 2;
count =1;


%OVO is used to determine which classes to OVO in calculate CSP features
for a = 1:nClasses-1
    for b = cOVO:nClasses
        
        OVO(count,1) = a;
        OVO(count,2) = b;
        count = count +1;
    end
    cOVO = cOVO+1;
end
end