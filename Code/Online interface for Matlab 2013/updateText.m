function updateText(fig, text, width, height,heightPosition)
% DESCRIPTION OF FUNCTION
% This function updates the figure text, used by the online training 
% interface	
%
% INPUT
% fig:              Figure to update
% text:             Text to update the figure with
% width:            Width of the figure
% height:           Height of the figure
% heightPosition:   Specifying if text should be at top, middle or bottom
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Checking if heightPosition is given
if ~exist('heightPosition')
   heightPosition = ''; 
end

switch heightPosition
    case 'top'
        hVal = height/4*1.33;
        hVal2 = height/3;
    case 'mid'
        hVal = height/4;
        hVal2 =  height/3;
    case 'bot'
        hVal = 0;
        hVal2 = 200;
    otherwise
        hVal =  height/4;
        hVal2 =  height/3;
end

switch text
    case 'correct'
        text = '';
        t = uicontrol(fig,'Style','text','String',text,'FontSize',20,'BackgroundColor','green','Position',[width/4 hVal width/2 hVal2]);
    otherwise
        t = uicontrol(fig,'Style','text','String',text,'FontSize',20,'BackgroundColor','white','Position',[width/4 hVal width/2 hVal2]);
end

% Calling figure followed be small break to update figure
figure(fig)
pause(1e-12)


end