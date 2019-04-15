function [binaryClass] = makeClassBinary(class, discriminateAgainst)
% DESCRIPTION OF FUNCTION
%
% Returns a vector of binary classes - the one that is discriminate against
% is 1 and all the other classes are assigned to 2. This is used for OVR
% training
%
% INPUT
% class:                vector containing correct labels of classes.
% discriminateAgainst:  the class to discriminate against
%
% OUTPUT:
% binaryClass:          same as class except discriminateAgainst is turned
%                       into 1 and all the other classes are turned into 2;
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


%class = which class was performed at the given trial
%discrimianteAgainst = which class is being discriminated against
class(class==discriminateAgainst)= 0;
class(class~=0)= 1;
class = class+1;
binaryClass = class;
end

