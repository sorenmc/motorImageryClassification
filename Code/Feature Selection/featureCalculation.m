function val = featureCalculation(type, Fsection, section)
% DESCRIPTION OF FUNCTION
% This function calculates the feature specified as an input.
%
% INPUT
% type:     Type of feature to calculate
% Fsection: Spectrum of the data
% section:  Data in the time domain
%
% OUTPUT:
% val:      Value of the calculated feature
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



% Checking which type of feature to calculate
switch type
    case "power"
        val = mean((abs(Fsection').^2))';
    case "var"
        val = var((abs(Fsection')))';
    case "high"
        val = max(abs(Fsection'));
    case "low"
        val = min(abs(Fsection'));
    case "phase"
        val = mean(angle(Fsection'));
    case "tEnergy"
        val = mean(section').^2;
    case "tVar"
        val = var(section');
end

end