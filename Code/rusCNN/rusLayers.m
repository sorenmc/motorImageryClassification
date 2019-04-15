function layers = rusLayers()


%( Size - Filter + 2Paddig)/ Stride +1



perc = 0.5;

layers = [imageInputLayer([1,256,22]) %1
    

%1x256x22
convolution2dLayer([1,5],6,'Padding','same') %1


%1x256x6
convolution2dLayer([1,8],6,'Stride',[1,8],'Padding','same')



%1x32x6
convolution2dLayer([1,7],32,'Padding','same')
leakyReluLayer

%1x32x32
maxPooling2dLayer([1,3],'Stride',[1,2],'Padding','same')


%1x16x32
convolution2dLayer([1,3],64,'Stride',[1,1],'Padding','same')

reshapeLayer

fullyConnectedLayer(512)
dropoutLayer(perc)
fullyConnectedLayer(512)
dropoutLayer(perc)
fullyConnectedLayer(4)
dropoutLayer(perc)
softmaxLayer

classificationLayer('Name','coutput')];




end

