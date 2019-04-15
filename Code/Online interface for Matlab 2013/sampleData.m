function [ data ] = sampleData(device, time)
% DESCRIPTION OF FUNCTION
% This function samples data.	
%
% INPUT
% device:		Recording device
% time:			Time to record
%
% OUTPUT
% data:         Recorded data
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

if device.connected
    nSamples = device.samplerate*time;
    while device.ai.SamplesAcquired < nSamples
    end
    data =  getdata(device.ai,nSamples)';
else
    pause(time)
    data = rand(round(device.samplerate*time),16)';
end

end

