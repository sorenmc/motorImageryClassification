function closeFigures(nFigToClose)
% DESCRIPTION OF FUNCTION
% Function for closing training plot figures	
%
% INPUT:
% nFigToClose:  Number of figures to close
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



% Checking if nFigToClose has been specified
if ~exist('nFigToClose')
   closeAll = true; 
else
    closeAll = false;
end

if closeAll
    close(findall(groot,'Tag','NNET_CNN_TRAININGPLOT_FIGURE'));
else
    temp = findall(groot,'Tag','NNET_CNN_TRAININGPLOT_FIGURE');
    toClose = '';
    for i = 1:nFigToClose
       toClose = [toClose i]; 
    end
end


end