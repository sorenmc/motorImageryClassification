function miData = newChannels(miData,filteredSignal)
% DESCRIPTION OF FUNCTION
%
% Takes a filtered signal, downsamples it to half the sample rate.
% Uses the "thrown away" sampels from downsample to make new channels. 
%
% INPUT
% miData:           Structure that contains MI snippets and corresponding
%                   information.
%
% filteredSignal:   a signal that has just been filtered.
%
% OUTPUT:
% miData:           Structure that contains MI snippets and corresponding
%                   information. Now with extra channels obtained from
%                   downsampling.
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


    channel1 = downsample(filteredSignal,2)';
    channel2 = downsample(filteredSignal,2,1)';
    miData.miData = [channel1;channel2];
    miData.trials = [1:375:miData.nTrials*375];
    
    
end