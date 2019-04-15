function features = findSelectedFeatures(featureInfo, dataStruct, FType)
% DESCRIPTION OF FUNCTION
% This function finds the features of the MI sessions, for the evaluation 
% data	
%
% INPUT
% featureInfo:      Cell matrix specifying which features have been
%                   calculated, in training data
% dataStruct:		Struct containing the data to calculate features from
% FType:            String specifiyng type of spectrum to calculate
%
% OUTPUT:
% features:         Values of the calculated features
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

t1a = tic;
% Finding trial vector
trials = dataStruct.windowTrials;

%Finding number of MI snippets
nMi = length(trials);

% Finding channel data
channels = dataStruct.windowData;

% Finding number of channels
nChannels = size(channels,1);

% Finding number of features
nFeatures = size(featureInfo,2);

% Finding samples pr section
nSamplesSection = dataStruct.fs*dataStruct.windowLength;

tInit = toc(t1a);

t1b = tic;

% Finding spectrum
[Fdata, freq] = makeSpectrumOnce(FType,channels,trials,dataStruct.fs,nMi);

tSpectrum = toc(t1b);

t1c = tic;

features = zeros(nMi,nFeatures);

% Going through each of the MI snippets and finding the features
for i = 1:nMi
    for k = 1:nFeatures
        t1ca = tic;
        % Finding the lower and upper frequency band
        low = featureInfo{2,k};
        high = featureInfo{3,k};
        type = featureInfo{1,k}{1,1};
        
        % Finding the channel
        channel = featureInfo{4,k};
        tFeaturesInit(i,k) = toc(t1ca);
        
        t1cb = tic;
        % Finding the current section of data
        Fsection = Fdata(channel,and(freq>=low,freq<=high),i);
        section = channels(channel,trials(i):trials(i)+nSamplesSection - 1);
        tFeaturesSection(i,k) = toc(t1cb);
        
        t1cc = tic;
        % Calling function for calculating features
        val = featureCalculation(type, Fsection, section);
        tFeaturesVal(i,k) = toc(t1cc);
        
        % Putting the calculated features into the matrix
        features(i,k) = val;
    end
    
end

tFeatures = toc(t1c);

end