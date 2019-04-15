function dataUse = cnnPreprocess(miData,bandFilters)
    nTrials = miData.nTrials;
    nChannels = miData.nChannels;
    dataUse = miData.miData;
    
    
    %filterUse = bandFilters.filterVector{1};
   % dataUse = filtfilt(filterUse,dataUse');
   nSamples = size(dataUse,2);
   nSamplesPerTrial = nSamples/nTrials;
   
    
    
    %dataUse = movmean(dataUse,1000);
    
    
    
    %dataUse(end,:) = [];
   
    %nDownSamples = nSamplesPerTrial/2;
    %dataUse = downsample(dataUse,2);
    dataUse = reshape(dataUse,nChannels,nSamplesPerTrial,1,nTrials);



end

