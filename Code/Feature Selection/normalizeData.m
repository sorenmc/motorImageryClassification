function [dataOut, normValuesOut] = normalizeData(dataIn, normValuesIn)
% DESCRIPTION OF FUNCTION
% This function normalizes the input data, and return the normalized data
% and a varible that holds the min and max values of the normalized input
% data	
%
% INPUT
% dataIn : The input data that will be normalized
% normValuesIn : This variable holds the min and max values from a previous
% normalization, so this new data can be normalized in the same interval
%
% OUTPUT:
% dataOut : The normalized output data
% normValuesOut : Variable that holds the min and max value of the input data,
% so new data can be normalized in the same interval for better comparision
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Checking if input normalization values are given, if not the input data
% is normalized from its own min and max values
if ~exist('normValuesIn','var')
    % Finds min and max of input data
    minData = min(dataIn')';
    maxData = max(dataIn')';
else
    minData = normValuesIn(:,1);
    maxData = normValuesIn(:,2);
end

% Normalize data between -1 and 1
a = bsxfun(@minus, dataIn, minData);    % Function for subtracting vector from matrix

b = maxData - minData;

dataOut = 2 * a ./ b - 1;

% Assigning values to normValues
normValuesOut = [minData maxData];


end