% DESCRIPTION OF FUNCTION
% Used to take online data files and make them into a single offline file
%
% AUTHORS OF FUNCTION
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk



folderName = 'C:\Users\Nicklas Holm\OneDrive\Dokumenter\DTU\Bachelorcode\Code\Online interface for Matlab 2013 (experimentel)\recordings\data_16062018\final\';
outputFile = 'Data_6.mat';

files = dir([folderName,'*.mat']);

    if(exist([folderName,outputFile],'file'))
        delete([folderName,outputFile])
        files = dir([folderName,'*.mat']);
    end

nFiles = length(files)
nTrials = nFiles*25;
resultingData = cell(1,nFiles)

for file = 1:nFiles
    useFile = files(file).name;
    process = sprintf('%s%s',folderName, useFile);
    useData = load(process);
    resultingData{file} = useData;
end

save([folderName,outputFile],'resultingData');

