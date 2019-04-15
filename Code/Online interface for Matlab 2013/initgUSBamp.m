function ai = initgUSBamp(nChannels, samplerate)
% DESCRIPTION OF FUNCTION
% This function initializes the gUSBamp	
%
% INPUT
% nChannels:		Number of channels to record from
% samplerate:       Sampling rate
%
% OUTPUT
% ai:               Recording object
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


ai = analoginput('guadaq',1);	% guadaq is the data aquisition adaptor from gtec and comes with installation of the amplifier
for i = 1:nChannels 
addchannel(ai,i); 				% Read only from channel 1
end



set(ai,'SamplesPerTrigger',samplerate/4);
set(ai,'TriggerRepeat',inf);
set(ai,'SampleRate',samplerate);
set(ai,'TriggerType','Immediate');
set(ai,'Mode','Normal');
set(ai,'SlaveMode','Off');
set(ai,'BufferingMode','auto');

% Apply filters corresponding to sample rate (512 Hz)
% To see filter numbers use gUSBampShowFilter command. Eg. for 128 Hz gUSBampShowFilter(128)
for i = 1:nChannels
set(ai.Channel(i),'BPIndex',75);    % Bandpass 5-30 Hz 8th Butterworth
set(ai.Channel(i),'NotchIndex',4);  % Notch 48-52 Hz
end

% Start g.USBamp
start(ai);

end
