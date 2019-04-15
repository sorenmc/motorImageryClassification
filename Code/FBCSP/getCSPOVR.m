function [wOVR] = getCSPOVR(miData,nFilter)
% DESCRIPTION OF FUNCTION
%
%
% returns 2*nFilters CSP filters given input data.
% This is to get the OVR filters.
%
%
% INPUT
% miData:           Structure that contains MI snippets and corresponding
%                   information.
%
% nFilter           numer of CSP filter pairs
%
% OUTPUT:
% wOVR:             nFilter pairs of CSP Filters. 
%                   dimension size [nChannels x 2*nFilter]
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


%find CSP filter from the given trials, and return 2*m filters
nClasses = miData.nClasses;
%parameter used for only getting 1 match up.
wOVR = cell(1,nClasses);


for a = 1:nClasses
    b = 1:nClasses;
    b(b == a) = [];
    wOVR{a} = CSP(miData,nFilter,a,b);
end

end