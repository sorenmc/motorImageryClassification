function [wOVO,OVO] = getCSP(miData,nFilter)
% DESCRIPTION OF FUNCTION
% This function calculates the CSP filters
%
% INPUT
% miData:		Structure that contains MI snippets and corresponding
%               information.
% nFilter:      Number of CSP filters to return
%
% OUTPUT
% wOVO:         CSP filters to return
% OVO:          OVO scheme
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


%find CSP filter from the given trials, and return 2*m filters
nClasses = miData.nClasses;
nClassifiers = nClasses*(nClasses-1)/2;
%parameter used for only getting 1 match up.
cOVO=2;
wOVO = cell(1,nClassifiers);
OVO = zeros(nClassifiers,2);
count = 1;


for a = 1:nClasses-1
    for b = cOVO:nClasses
        wOVO{count} = CSP(miData,nFilter,a,b);
        OVO(count,1) = a;
        OVO(count,2) = b;
        count = count+1;
    end
cOVO=cOVO+1;
end

end