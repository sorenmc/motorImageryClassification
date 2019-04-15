function nSamples = clearBuffer(device)
% DESCRIPTION OF FUNCTION
% This function clears the buffer of the recording device.	
%
% INPUT
% device:	Recording device
%
% OUTPUT:
% nSamples: Return number of samples that have been cleared from buffer
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



nSamples = [];

if device.connected
    nSamples = device.ai.SamplesAvailable;
    while device.ai.SamplesAcquired < nSamples
    end
    if nSamples > 0
        getdata(device.ai,nSamples);
    end
end

end

