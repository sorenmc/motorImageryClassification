function [windowChannel, windowClass, windowTrial] = windowFunction(data, windowType)
% DESCRIPTION OF FUNCTION
% This function windows the input signal to a given length and with a given
% overlap	
%
% INPUT
% data:             Structure that contains MI snippets and corresponding
%                   information.
% windowType:       Optional parameter specifying which window type to use
%
% OUTPUT:
% windowChannel:    The windowed signals
% windowClass:      The windowed classes
% windowTrial:      The windowed trials
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% If window type is not given, then a standard rect window is used
if ~exist('windowType','var')
    windowType = 'rect';
end

% Computes length of filter in samples
filterLength = data.windowLength * data.fs;

% Finding number of samples pr trial and section
nSamplesTrial = data.miLength * data.fs;
nSamplesSection = data.windowLength * data.fs;
nSamplesOverlap = round(nSamplesSection*data.overlap);

% Finding number of channels and number of trials
nSamples = size(data.miData,2);
nChannels = size(data.miData,1);
nTrials = round(nSamples /  nSamplesTrial);


% % Selecting window type
% if strcmp(windowType,'hanning')
%     window = hann(windowLength);
% elseif strcmp(windowType,'kaiser')
%     window = kaiser(windowLength);
% else
%     window = ones(windowLength);
% end

windowChannel = zeros(data.nChannels,0);

% Initializing where the windows should first be cut
kIn = [1 nSamplesSection];
kOut = [1 nSamplesSection];

% Initializing count variable for true cuts
k = 1;

% Running for loop to cut the input signal with the correct window length
% and overlap
% for i = 1:nWindows
while(1)
    
    % Finding trialnumber of the proposed cut signals two ends
    trialNr = ceil(kIn / nSamplesTrial);
    
    % If they are equal then the cut is performed
    if trialNr(1) == trialNr(2)
        % Performing cut
        windowChannel(:,kOut(1):kOut(2)) = data.miData(:,kIn(1):kIn(2));
        
        % Updating trial vector for windowed signal
        windowTrial(k) = kOut(1);
        
        % Updating class vector for windowed signal
        windowClass(k) = data.classes(trialNr(1));
        
        % Updating where the cuts should be stores
        kOut = kOut + nSamplesSection;
        
        % Incrementing count variable for true cuts
        k = k + 1;
    end
    
    % Updating where the cuts should be performed
    kIn = kIn + nSamplesSection - nSamplesOverlap;
    
    
    
    % If index is too large, then break out of for loop
    if kIn(2) > nSamples
        break;
    end
    
end


end