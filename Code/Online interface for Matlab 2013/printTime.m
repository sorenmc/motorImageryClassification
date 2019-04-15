function printTime()
% DESCRIPTION OF FUNCTION
% This function prints the current time	
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



t = clock;

hour = t(4);
minute = t(5);
second = t(6);

if t(4) < 10
   hour = sprintf('0%d', t(4)); 
else
   hour = sprintf('%d', t(4)); 
end

if t(5) < 10
    minute = sprintf('0%d', t(5)); 
else
    minute = sprintf('%d', t(5));
end

if t(6) < 10
    second = sprintf('0%.0f', t(6));
else
   second = sprintf('%.0f', t(6)); 
end

fprintf('[%s:%s:%s]', hour, minute, second);

end
