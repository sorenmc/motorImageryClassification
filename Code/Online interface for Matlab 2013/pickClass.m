function [pickedClass, classCounter] = pickClass(classes, classCounter, maxCount)
% DESCRIPTION OF FUNCTION
% This function picks a class from the list of classes, to ensure that each
% class in the end is chosen the same number of times
%
% INPUT
% classes:          The classes that can be chosen
% classCounter:     Counter for the different classes
% maxCount:         Maximum number of times a class can be chosen
%
% OUTPUT
% pickedClass:      The picked class
% classCounter:     Counter for the different classes
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Finds number of classes
nClasses = length(classes);

% Finds number of remaining classes
nClassesRemaining = maxCount - classCounter;

maxClassesRemaining = max(nClassesRemaining);

classToPick = find(nClassesRemaining == maxClassesRemaining);

% if length(classToPick) > 1
%     index = randi(length(classToPick));
%     
%     % classToPick = datasample(classToPick,1);
% end

index = randi(length(classToPick));

pickedClass = classToPick(index);

classCounter(pickedClass) = classCounter(pickedClass) + 1;

end