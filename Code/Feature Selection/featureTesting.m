function [featureInfo, features] = featureTesting(channels, fs, trials, FType, nBands, minFreq, maxFreq)
% DESCRIPTION OF FUNCTION
% This function finds the features of the MI sessions.
%
% INPUT
% channels:         The channels that contain all the training data
% fs:               The sampling frequency
% trials:           Vector containing the indicies for when a new trial
%                   starts
% FType:            String specifiyng type of spectrum to calculate
% nBands:           Number of bands in spectrum
% minFreq:          Minimum frequency to start the spectrum band from
% maxFreq:          Maximum frequency to end the spectrum band at
%
% OUTPUT:
% featureInfo:		Cell matrix specifying which features have been
%                   calculated, so that the same features can be calculated
%                   for evaluation data
% features:         Values of the calculated features
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

t1a = tic;

freqRange = maxFreq - minFreq;
deltaFreq = freqRange / nBands;

%Finding number of MI snippets
nMi = length(trials);

% Finding number of channels
nChannels = size(channels,1);

% Finding number of sampels pr time section
nSamplesSection = round(size(channels,2) / nMi);

tInit = toc(t1a);

t1b = tic;

[Fdata, freq] = makeSpectrumOnce(FType,channels,trials,fs,nMi);

if sum(sum(sum(imag(Fdata)))) == 0 % Checking if real
    k = 0;
    while nBands > 0
        
    for i = 0:nBands-1
        featureInfo{1,i+k+1} = "power";
        featureInfo{1,i+k+1+nBands} = "var";
        %featureInfo{1,i+k+1+2*nBands} = "high";
        %featureInfo{1,i+k+1+3*nBands} = "low";
        featureInfo{2,i+k+1} = [minFreq+i*deltaFreq];
        featureInfo{2,i+k+1+nBands} = [minFreq+i*deltaFreq];
        %featureInfo{2,i+k+1+2*nBands} = [minFreq+i*deltaFreq];
        %featureInfo{2,i+k+1+3*nBands} = [minFreq+i*deltaFreq];
        featureInfo{3,i+k+1} = [minFreq+(i+1)*deltaFreq];
        featureInfo{3,i+k+1+nBands} = [minFreq+(i+1)*deltaFreq];
        %featureInfo{3,i+k+1+2*nBands} = [minFreq+(i+1)*deltaFreq];
        %featureInfo{3,i+k+1+3*nBands} = [minFreq+(i+1)*deltaFreq];
    end
        nBands = nBands-1;
        deltaFreq = freqRange / nBands;
        k = size(featureInfo,2);
    end
else
    k = 0;
    while nBands > 0
        
        for i = 0:nBands-1
            featureInfo{1,i+k+1} = "power";
            featureInfo{1,i+k+1+nBands} = "var";
            featureInfo{1,i+k+1+2*nBands} = "high";
            featureInfo{1,i+k+1+3*nBands} = "low";
            featureInfo{1,i+k+1+4*nBands} = "phase";
            featureInfo{2,i+k+1} = [minFreq+i*deltaFreq];
            featureInfo{2,i+k+1+nBands} = [minFreq+i*deltaFreq];
            featureInfo{2,i+k+1+2*nBands} = [minFreq+i*deltaFreq];
            featureInfo{2,i+k+1+3*nBands} = [minFreq+i*deltaFreq];
            featureInfo{2,i+k+1+4*nBands} = [minFreq+i*deltaFreq];
            featureInfo{3,i+k+1} = [minFreq+(i+1)*deltaFreq];
            featureInfo{3,i+k+1+nBands} = [minFreq+(i+1)*deltaFreq];
            featureInfo{3,i+k+1+2*nBands} = [minFreq+(i+1)*deltaFreq];
            featureInfo{3,i+k+1+3*nBands} = [minFreq+(i+1)*deltaFreq];
            featureInfo{3,i+k+1+4*nBands} = [minFreq+(i+1)*deltaFreq];
        end
        
        nBands = nBands-1;
        deltaFreq = freqRange / nBands;
        k = size(featureInfo,2);
    end
end

nFeatures = size(featureInfo,2);

featureInfo{1,nFeatures+1} = "tEnergy";
featureInfo{1,nFeatures+2} = "tVar";
featureInfo{2,nFeatures+1} = -1;
featureInfo{2,nFeatures+2} = -1;
featureInfo{3,nFeatures+1} = -1;
featureInfo{3,nFeatures+2} = -1;

nFeatures = size(featureInfo,2);


tSpectrum = toc(t1b);

features = zeros(nChannels*nFeatures,nMi);

t1c = tic;
% Going through each of the MI snippets and finding the features
for i = 1:nMi
    section = channels(:,trials(i):trials(i)+nSamplesSection - 1);
    for k = 1:nFeatures
        t1ca = tic;
        % Finding the lower and upper frequency band
        low = featureInfo{2,k};
        high = featureInfo{3,k};
        type = featureInfo{1,k};
        tFeatureFind(i,k) = toc(t1ca);
        
        t1cb = tic;
        % Finding the current section of data
        Fsection = Fdata(:,and(freq>=low,freq<=high),i);
        tFeatureSection(i,k) = toc(t1cb);
        
        t1cc = tic;
        % Calling function for calculating features
        val = featureCalculation(type, Fsection, section);
        tFeatureVal(i,k) = toc(t1cb);
        
        % Calculating which rows to put the calculated features into
        row1 = (k-1)*nChannels+1;
        row2 = k*nChannels;
        
        % Putting the calculated features into the matrix
        features(row1:row2,i) = val;
    end
    
end
tFeature = toc(t1c);



end