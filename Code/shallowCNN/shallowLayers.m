function layers =  shallowLayers(nChannels,nSamples)

layers = [imageInputLayer([nChannels,nSamples,1])
         %convolution2dLayer([1,56],24,'Stride',[1,3],'NumChannels',1)
         convolution2dLayer([1,25],24,'Stride',[1,3])
         convolution2dLayer([nChannels,1],73,'NumChannels',24)
         squareLayer
         batchNormalizationLayer
         dropoutLayer
         %batchNormalizationLayer('ScaleL2Factor',0.1)
         averagePooling2dLayer([1,75])
         
         logLayer
         %convolution2dLayer([1,22],4,'NumChannels',83)
         fullyConnectedLayer(4)
        
        softmaxLayer
        classificationLayer];
    
end