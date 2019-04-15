function sessionCountdown(figOpt)
% DESCRIPTION OF FUNCTION
% This function counts down until a new session start.
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

text = sprintf('Session will begin in 3.');
updateText(figOpt.f,text,figOpt.width,figOpt.height);
pause(1)
text = sprintf('Session will begin in 2..');
updateText(figOpt.f,text,figOpt.width,figOpt.height);
pause(1)
text = sprintf('Session will begin in 1...');
updateText(figOpt.f,text,figOpt.width,figOpt.height);
pause(1)


end

