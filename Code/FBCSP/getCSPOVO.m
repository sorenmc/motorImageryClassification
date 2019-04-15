function [wOVO] = getCSPOVO(miData,nFilter)
% DESCRIPTION OF FUNCTION
%
%
% returns 2*nFilters CSP filters given input data.
% This is to get the OVO filters.
%
% INPUT
% miData:           Structure that contains MI snippets and corresponding
%                   information.
%
% nFilter           numer of CSP filter pairs
%
% OUTPUT:
% wOVO:             nFilter pairs of CSP Filters. 
%                   dimension size [nChannels x 2*nFilter]
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
count = 1;


for a = 1:nClasses-1
    for b = cOVO:nClasses
        wOVO{count} = CSP(miData,nFilter,a,b);
        count = count+1;
    end
cOVO=cOVO+1;
end

end