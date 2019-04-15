function [newFeatureInfo, newFeatures] = selectFeatures(featureInfo,features, dataStruct, nSelect, selectType)
% DESCRIPTION OF FUNCTION
% This function select which features are most significant.	
%
% INPUT
% featureInfo:		Cell matrix specifying the calculated features
% features:         Values for the calculated features
% dataStruct:       Structure that contains MI snippets and corresponding
%                   information.
% nSelect:			Number of features to select as most significant.
% selectType:       Type of algorithm used for selecting the features
%
% OUTPUT:
% newFeatureInfo:	New feature info struct containing which features
%                   should be calculated on the evaluation data
% newFeatures:		Values of the most significant features
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Extracting important numbers
nClasses = dataStruct.nClasses;
classes = dataStruct.windowClasses;
nChannels = dataStruct.nChannels;
nFeatures = size(features,1);
nMi = size(features,2);
nTypes = size(featureInfo,2);

% features = normalizeData(features);

for i = 1:nClasses
    classMatrix(i,classes==i) = 1;
    classMatrix(i,classes~=i) = 0;
end


% Finding means of different features
for i = 1:nClasses
    meanTrue(i,:) = mean(features(:,classMatrix(i,:)==1)');
    
    meanFalse(i,:) = mean(features(:,classMatrix(i,:)==0)');
    
    varTrue(i,:) = var(features(:,classMatrix(i,:)==1)');
    
    varFalse(i,:) = var(features(:,classMatrix(i,:)==0)');
end

% Finding the difference between true and false
Rmean = meanTrue./meanFalse;
Rvar = varTrue./varFalse;

% Since R is centered around 1, subtracting 1, and taking the absolute
% value will give a matrix where a higher value equals better feature
Rmean = abs(Rmean - 1);
Rvar = abs(Rvar - 1);

% The values of how well it discriminates between different classes is
% summed
Smean = sum(Rmean);
Svar = sum(Rvar).^2;

% Preallocating
newFeaturesInfo = zeros(4,nSelect);
newFeatures = zeros(nSelect,nMi);

S = Smean;


switch selectType
    case "variance"
        % Constant for how much data groups are seperated
        c = zeros(nFeatures,1);
        
        for i = 1:nFeatures
            % Finding class that is best discriminated by this feature
            [~,I] = max(Rmean(:,i));
            
            % Finding means and variance for the best discriminated class if one vs
            % rest was applied
            mT = meanTrue(I,i);
            mF = meanFalse(I,i);
            vT = sqrt(varTrue(I,i));
            vF = sqrt(varFalse(I,i));
            
            % Finding a constant describing how much the two cases are seperated
            if mT <= mF
                c(i) = -(mF-mT)/(vF-vT);
            else
                c(i) = -(mF-mT)/(vF+vT);
            end
        end
        
        for i = 1:nSelect
            % Finding index of best discriminator
            [~,I] = max(c);
            
            % Finding which feature type, band and channel was used
            index = ceil(I / nChannels);
            
            type = featureInfo(1,index);
            band = featureInfo(2:3,index);
            
            channel = I;
            
            while channel > nChannels
                channel = channel - nChannels;
            end
            
            % Updating newFeatureInfo matrix
            newFeatureInfo{1,i} = type;
            newFeatureInfo{2,i} = band{1,1};
            newFeatureInfo{3,i} = band{2,1};
            newFeatureInfo{4,i} = channel;
            
            % Updating newFeatures
            % newFeatures(i,:) = features(I,:);
            newFeatures(i,:) = features(I,:);
            
            % Removing the best discriminator from matrix
            c(I) = -inf;
            
        end
    case "mean"
        for i = 1:nSelect
            % Finding index of best discriminator
            [~,I] = max(S);
            
            % Finding which feature type, band and channel was used
            index = ceil(I / nChannels);
            
            type = featureInfo(1,index);
            band = featureInfo(2:3,index);
            
            channel = I;
            
            while channel > nChannels
                channel = channel - nChannels;
            end
            
            % Updating newFeatureInfo matrix
            newFeatureInfo{1,i} = type;
            newFeatureInfo{2,i} = band{1,1};
            newFeatureInfo{3,i} = band{2,1};
            newFeatureInfo{4,i} = channel;
            
            % Updating newFeatures
            newFeatures(i,:) = features(I,:);
            
            % Removing the best discriminator from matrix
            S(I) = [];
        end
end
end