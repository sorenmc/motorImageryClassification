function hitRate = accuracy(predicted,class)
% DESCRIPTION OF FUNCTION
% Calculates the accuracy of a classification, by comparing the two input
% vectors.
%
% INPUT
% predicted:    Predicted classes
% class:		True classes
%
% OUTPUT:
% hitRate:	Accuracy for correct classification
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


counter = 0;
for i = 1:length(predicted)
    if (predicted(i) == class(i))
        counter=counter+1;
    end
end

hitRate = counter/length(predicted)*100;
end