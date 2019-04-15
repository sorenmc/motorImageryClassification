function [yes, no] = yesOrNo()
% DESCRIPTION OF FUNCTION
% This function waits for the user to press either "y" or "n", and then 
% returns which button was pressed.	
%
% OUTPUT:
% yes:			Logical variable containing true if "y" was pressed, else
%               false
% no:			Logical variable containing true if "n" was pressed, else
%               false
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

yes = false;
no = false;

% Acessing global variables
global keyWasPressed;
global yWasPressed;
global nWasPressed;
keyWasPressed = false;
nWasPressed = false;
yWasPressed = false;
while ~keyWasPressed
    % Adds pause to allow top level function to check global variables
    pause(1e-9)
    if yWasPressed
        yes = true;
    elseif nWasPressed
        no = true;
    else
        % If a different key was pressed, search for y/n again
        keyWasPressed = false;
    end
end

end