function [acc, pred] = findOnlineAccuracy(score, class, bias)
% DESCRIPTION OF FUNCTION
% This function finds the accuracy of the predicted labels, by comparing 
% them to the true labels	
%
% INPUT
% score:		Predicted scores from classifier
% class:		True classes of the recorded data
% bias:         Bias value to make window segments at the beginning have
%               smaller impact on the coting system
%
% OUTPUT:
% acc:          Calculated accuracy
% pred:         Predicted labels
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

nPred = size(score,2);
skip = false;


for i = 1:size(score,1)
    comb{i} = zeros(size(score{1,1}));
    for j = 1:size(score,2)
        if ~skip
            if ~isempty(score{i,j})
                comb{i} = comb{i} + score{i,j}*(bias + (1-bias)/nPred*j);
            else
                comb{i} = [];
                class(i) = [];
                skip = true;
            end
        end
    end
    if ~skip
        [~,pred(i)] = max(comb{i});
    end
end

acc = accuracy(pred,class);


end