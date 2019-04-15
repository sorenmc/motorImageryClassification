function recOpt = saveData(data,recOpt,type, filenum)
% DESCRIPTION OF FUNCTION
% This functions saves the recorded data to a file.	
%
% INPUT
% data:         Data to save
% recOpt:       Options for saving (File directory)
% type:         Type of data (Training, Training with feedback, Evaluation)
% filenum:      Filenumber
%
% OUTPUT
% recOp:        Options for saving is returned
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

% Checks if root folder exist
if ~exist(recOpt.root)
    mkdir(recOpt.root);
end

% Create filename
frontName = recOpt.subname(1:3);
for i = 1:length(recOpt.subname)
   if recOpt.subname(i) == ' '
      ind = i; 
   end
end
lastName = recOpt.subname(ind+1:ind+3);

fileName = sprintf('%s/%s%s%s_%d.mat', recOpt.root, type, frontName, lastName, filenum);

save(fileName, 'data');




end

