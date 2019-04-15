function [predictions,scorePredictions] = combinePredictionsOurData(windowPredictions, nTrials,score,scoreType)
% DESCRIPTION OF FUNCTION
% This function combines the predictions from the windowed sections to
% predictions for the classes
%
% INPUT
% windowPredictions:    Predictions made from the windowed sections
% nTrials:              Number of trials
% score:                Likelihood of the different classes
% scoreType:            Specify how the scores should be summed
%
% OUTPUT:
% predictions:          Label predictions for the classes
% scorePredictions:     Score predictions for the classes
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Finds the number of sections
nSections = length(windowPredictions);

% Finds the number of sections pr trial
nSectionsPrTrial = round(nSections / nTrials);

% Finds the number of classes
nClasses = 4;%length(unique(windowPredictions));

% Initializing count variable
count = zeros(nClasses,1);
sumScore = zeros(1,nClasses);

% Variable for proposedPrediction indicies
k = 1;
switch scoreType
    case "sum"
        for i = 1:nSectionsPrTrial:nSections
            for j = 0:nSectionsPrTrial-1
                if (i+j) <= nSections
                    thisPrediction = windowPredictions(i+j);
                    
                    % Count the number of predictions of the different classes
                    count(thisPrediction) = count(thisPrediction) + 1;
                    
                    thisScore = score(i+j,:);
                    
                    sumScore = sumScore + thisScore;
                end
            end
            
            % Finds the max value (Only one, has to check if multiple exists)
            [~, proposedPrediction(k)] = max(count);
            
            % Check if multiple classes has the same number of predictions
            indiciesOfEqualClasses = find(count == count(proposedPrediction(k)));
            
            if length(indiciesOfEqualClasses) ~= 1
                % Randomly selects prediction of the classes scoring highest
                proposedPrediction(k) = datasample(indiciesOfEqualClasses,1);
                
            end
            
            [~,scorePredictions(k)] = max(sumScore);
            
            % Incrementing variable for proposedPrediction indicies
            k = k + 1;
            
            % Clearing count variable
            count = zeros(nClasses,1);
            sumScore = zeros(1,nClasses);
            
        end
        
        predictions = proposedPrediction;
    case "running"
        for i = 1:nSectionsPrTrial:nSections
            for j = 0:nSectionsPrTrial-1
                thisScore = score(i+j,:);
                
                [val,indicie] = max(score(i+j,:));
                
                sumScore(indicie) = sumScore(indicie) + val;
                
                sumScore(~indicie) = sumScore(~indicie) - 0.25;
            end
            
            [~,scorePredictions(k)] = max(sumScore);
            
            predictions = -1;
            
        end
end




end