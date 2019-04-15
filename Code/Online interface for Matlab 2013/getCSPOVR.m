function [wOVR] = getCSPOVR(miData,nFilter)
% DESCRIPTION OF FUNCTION
% This function calculates the CSP filters
%
% INPUT
% miData:		Structure that contains MI snippets and corresponding
%               information.
% nFilter:      Number of CSP filters to return
%
% OUTPUT
% wOVR:         CSP filters to return
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


%if class is a row vector, change it into a column vector
%if (size(class,1) < 2)
 %   class=class';
%end

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