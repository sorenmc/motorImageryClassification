function [Fdata, freq] = makeSpectrumOnce(Ftype,channels,trials,fs,nMi)
% DESCRIPTION OF FUNCTION
% This function finds the spectrum from the data given to it.	
%
% INPUT
% Ftype:        String indicating which spectrum to find
% channels:     MI data matrix
% trials:       Vector containing the indicies for when a new trial starts
% fs:           Sampling frequency
% nMi:          Number of MI trials
%
% OUTPUT:
% Fdata:		Spectrum of the data
% freq:			Frequency vector
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



% Extracting information
[nChannels, nSamples] = size(channels);

sectionLength = round(nSamples / nMi);

% Rearranging channels array
ReChannels = zeros(nChannels*nMi,sectionLength);

row(1) = 1;
row(2) = nChannels;

for i = 2:nMi
    a = channels(:,trials(i-1):trials(i)-1);
    
    ReChannels(row(1):row(2),:) = a;
    
    row = row + nChannels;
end
ReChannels(row(1):row(2),1:nSamples-trials(end)+1) = channels(:,trials(end):end);


switch Ftype
    case "fft"
        t1b = tic;
        % Fourier transforming
        ReFdata = fft(ReChannels);
        
        % Creating frequency vector
        [~,freq] = createTimeFreqVector(fs,size(ReFdata,2));
        
        % Making spectrum onesided
        ReFdata = ReFdata(:,freq>=0)*2;
        
        % Defining frequency vector to be positive
        freq = freq(freq>=0);
        
        tTotalFFT = toc(t1b);
        
    case "pwelch"
        t1a = tic;
        % pwelch transforming
        [ReFdata, freq] = pwelch(ReChannels');
        
        ReFdata = ReFdata';
        
        freq = (freq * fs) / (2 * pi);
        tTotalPWELCH = toc(t1a);
    case "multitaper"
        t1c = tic;
        
        % Multitaper transforming
        [ReFdata, freq] = pmtm(ReChannels','unity');
        
        ReFdata = ReFdata';
        
        freq = (freq * fs) / (2 * pi);
        tTotalMultiTaper = toc(t1c);
end

row = [1 nChannels];

Fdata = zeros(nChannels,length(freq),nMi);



for i = 1:nMi
    a = ReFdata(row(1):row(2),:);
    
    Fdata(:,:,i) = a;
    
    row = row + nChannels;
end
%ReChannels(row(1):row(2),:) = channels(:,trials(end):end);

%Fdata = ReFdata;



end