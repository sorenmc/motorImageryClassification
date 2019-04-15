% DESCRIPTION OF Script
% Used to 3d plot the multivariate variated data, and save them as a new
% file.
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



figure()
LDAData = load('LDAData.mat');
LDAData = LDAData.LDAData;
LDAData = squeeze(mean(LDAData));
surf(LDAData)
xlabel('m')
ylabel('nBands')
zlabel('Mean accuracy [%]')
print('FBCSP/plots/OVOLDAplot','-depsc')


figure()
SVMData = load('SVMData.mat');
SVMData = SVMData.SVMData;
SVMData = squeeze(mean(SVMData));
surf(SVMData)
xlabel('m')
ylabel('nBands')
zlabel('Mean accuracy [%]')
print('FBCSP/plots/OVOSVMplot','-depsc')



figure()
NABData = load('NABData.mat');
NABData = NABData.NABData;
NABData = squeeze(mean(NABData));
surf(NABData)
xlabel('m')
ylabel('nBands')
zlabel('Mean accuracy [%]')
print('FBCSP/plots/OVOSVMplot')
