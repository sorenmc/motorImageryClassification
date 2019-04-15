function filterReturn = createFilters(filter)
% DESCRIPTION OF FUNCTION
% This function creates the filters, that are needed for FBCSP
%
% INPUT
% filter:		Filter struct with the options
%
% OUTPUT:
% filterReturn: Filter struct to return	
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Extracting options from filterstruct
order = filter.order;
F3dB1 = filter.F3dB1;
F3dB2 = filter.F3dB2;
rippleStop = filter.rippleStop;
nBands = filter.nBands;
type = filter.type;
nFilter = filter.nFilters;
fs = filter.fs;

% Calculating normalized frequency
w = [F3dB1 F3dB2] / (fs/2);

% Designing butterworth filter satisfying the specifications
[bFilt, aFilt] = butter(order,w);

% Assigning filter coefficients to filter struct
filter.filterVector{nFilter}.b = bFilt;
filter.filterVector{nFilter}.a = aFilt;

filter.nFilters = nFilter +1;
filterReturn = filter;
end

