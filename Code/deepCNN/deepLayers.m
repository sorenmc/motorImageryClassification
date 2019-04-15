function layers = deepLayers(imageSize)
% DESCRIPTION OF FUNCTION
%
% Given an input image size the function returns a network specified by 
% this function. Layer architecture is inspired by
%
% "On the Improvement of Classifying EEG Recordings Using Neural Networks"
% -2017
% by Yiran Zhao, Shuochao Yao, Shaohan Hu, 
% Shiyu Chang, Raghu Ganti, Mudhakar Srivatsa, Shen Li & Tarek Abdelzaher 
% 
%
% INPUT
% imageSize:    2d image input size specified as a 2d vector containing
%               % dimensions [height,width] of the input
%
% OUTPUT:
% layers:       contains the layers with trainable weights. This is used as
%               input to the neural network training function
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



nChannels = imageSize(1);
nSamples = imageSize(2);




perc = 0.5;

layers = [imageInputLayer([nChannels,nSamples,1]) %1
    

%fully connected layer in paper
convolution2dLayer([nChannels,1],30,'Stride',[nChannels,1],'Padding','same') %3
%reluLayer
permuteLayer

%1st conv layer
convolution2dLayer([1,15],60,'Stride',[1,3])
reluLayer
%eluLayer(60)
batchNormalizationLayer
maxPooling2dLayer([1,2],'Stride',[1,2])
dropoutLayer(perc)


%2nd conv layer Checked 30x29x60
convolution2dLayer([1,4],60,'Stride',[1,2])
reluLayer
%eluLayer(60)
batchNormalizationLayer
maxPooling2dLayer([1,2],'Stride',[1,2],'Padding','same')
dropoutLayer(perc)


%reluLayer



%3rd conv layer
convolution2dLayer([30,1],60,'NumChannels',60,'Stride',[3,1])
reluLayer
%eluLayer(60)
batchNormalizationLayer
dropoutLayer(perc)




%4th conv layer
convolution2dLayer([1,3],90,'Stride',[1,1],'Padding','same')
%eluLayer(90)
reluLayer
batchNormalizationLayer
maxPooling2dLayer([1,2],'Stride',[1,2],'Padding','same')
dropoutLayer(perc)


%5th conv layer
convolution2dLayer([1,3],120,'Stride',[1,1],'Padding','same')%9
reluLayer
%eluLayer(120)
batchNormalizationLayer
maxPooling2dLayer([1,2],'Stride',[1,2])
dropoutLayer(perc)



%reluLayer

reshapeLayer





%,'Padding','same'


%fullyConnectedLayer(95)

fullyConnectedLayer(4)

softmaxLayer

classificationLayer('Name','coutput')];





end




% 
% layers = [imageInputLayer([nChannels,nSamples,1]) %1
%     
% 
% %fully connected layer in paper
% convolution2dLayer([nChannels,1],30,'Stride',[nChannels,1],'Padding','same') %3
% eluLayer(30)
% %reluLayer
% permuteLayer
% 
% %1st conv layer
% convolution2dLayer([1,15],60,'Stride',[1,3])
% batchNormalizationLayer
% eluLayer(60)
% maxPooling2dLayer([1,2],'Stride',[1,2],'Padding','same')
% dropoutLayer(perc)
% 
% 
% %2nd conv layer Checked 30x29x60
% convolution2dLayer([1,4],60,'Stride',[1,2])
% batchNormalizationLayer
% eluLayer(60)
% maxPooling2dLayer([1,2],'Stride',[1,2],'Padding','same')
% dropoutLayer(perc)
% 
% 
% %reluLayer
% 
% 
% 
% %3rd conv layer
% convolution2dLayer([30,1],60,'NumChannels',60,'Stride',[3,1])
% batchNormalizationLayer
% eluLayer(60)
% dropoutLayer(perc)
% 
% 
% 
% 
% %4th conv layer
% convolution2dLayer([1,3],90,'Stride',[1,1],'Padding','same')
% batchNormalizationLayer
% eluLayer(90)
% maxPooling2dLayer([1,2],'Stride',[1,2],'Padding','same')
% dropoutLayer(perc)
% 
% 
% %5th conv layer
% convolution2dLayer([1,3],120,'Stride',[1,1],'Padding','same')%9
% batchNormalizationLayer
% eluLayer(120)
% maxPooling2dLayer([1,2],'Stride',[1,2])
% dropoutLayer(perc)
% 
% 
% 
% %reluLayer
% 
% reshapeLayer
% 
% 
% 
% 
% 
% %,'Padding','same'
% fullyConnectedLayer(95)
% dropoutLayer(perc)
% 
% fullyConnectedLayer(4)
% 
% softmaxLayer
% 
% classificationLayer('Name','coutput')];
% 
