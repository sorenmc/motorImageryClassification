function [kappa, accuracy, count] = findKappaValue(yCorrect,yPredict,nClasses)
% DESCRIPTION OF FUNCTION
% This function finds, and returns, the kappa value, the accuracy in percent
% and the number of true predictions, after comparing yCorrect with
% yPredict
%
% INPUT
% yCorrect:     The true classes of the data
% yPredict:     The predicted classes using the classifier
% nClasses:     Number of classes in the system
%
% OUTPUT:
% kappa:        The kappa value
% accuracy:     The accuracy in percent
% count:        Variable for number of true predictions
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Initializing count variable for true predictions
count = 0;

% Finding number of data point
nY = length(yCorrect);

for i = 1:nY
   if yCorrect(i) == yPredict(i)
      count = count + 1; 
   end
end

accuracy = (count / nY)*100;

kappa = (accuracy/100 - 1 / nClasses) / (1 - 1 / nClasses);





end