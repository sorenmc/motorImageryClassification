function [dashEEG] = expoStandardization(EEG)

blockSize = 1000;
nSamples = size(EEG,1)/1000;
vectUse = 1:blockSize;
uEst = mean(EEG(vectUse,:));
varEst = var(EEG(vectUse,:));
dashEEG = zeros(size(EEG));
alpha = 0.001;

tempEEG = EEG(vectUse,:);

for i = 1:round(nSamples)
    dashEEG(vectUse,:) = (tempEEG-uEst)./max(sqrt(varEst),10^-4);
    if( i == round(nSamples) )
        vectUse = 1+(i*blockSize):nSamples*blockSize;
    else
        vectUse = 1+(i*blockSize):blockSize*(i+1);
        tempEEG = EEG(vectUse,:);
        uEst = alpha*tempEEG + (1-alpha)*uEst;
        varEst = alpha*(tempEEG-uEst).^2 + (1-alpha)*varEst;
        
    end 
end


end

