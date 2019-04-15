% DESCRIPTION OF FUNCTION
% This function can be used to check if the channels are connected properly
% Should only be run in Matlab R2013a
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk


clear all
close all
clc

% Constants that needs to be set
channels = 16;                          % Nr of electrodes
samplerate = 512;                       % Sampling frequency
seconds = 2;                           % Seconds to look at
updatePeriod = 0.05;                    % Value in seconds
root = 'recordings/electrodeTest';      % Root folder for file saving
subname = 'Nicklas Holm';               % Name of subject
gender = 'male';
age = '23';
BCIexperience = 'no';
filenum = 1;                            % Recording file number for this subject
deviceConnected = true;

%% File saving info
% Create folder if needed and prepare file name
time = clock;
space_location = find(subname==' ');
sub_short = strcat(subname(1:3), subname(space_location+1:space_location+3));
folder = strcat(root,'/');
if ~exist(folder, 'dir')
    mkdir(folder);
end
filename = strcat(folder,sub_short,num2str(filenum),'-',num2str(time(4)),'.',num2str(time(5)),'.mat');

%% Setting up figure
set(0,'units','pixels');
pix = get(0,'screensize');

width = pix(3);
height = pix(4);

f = figure('Name','Electrode test','Visible','on','Position',[0,0,width,height])
%figure('Name','Electrode 1 to 4')

%% Initialize recording device
if deviceConnected
    ai = initgUSBamp(channels, samplerate);    % Initialize amplifier
end

%% Program loop
data = [];      % Creating variable for saving data

programRunning = true;

samplesPrPeriod = round(samplerate*updatePeriod);

if deviceConnected
    while ai.samplesAcquired < 1000
        
    end
    data = [data; getdata(ai,1000)];
else
    pause(updatePeriod);
    data = [data; rand(1000,channels)];
end

while(programRunning)
    if deviceConnected
        while ai.samplesAcquired < samplesPrPeriod
            
        end
        data = [data; getdata(ai,samplesPrPeriod)];
    else
        pause(updatePeriod);
        data = [data; rand(samplesPrPeriod,channels)];
    end
    
    if length(data) < seconds*samplerate+1
        p = [data; zeros(seconds*samplerate-length(data),channels)];
        if length(data) < 1024
            doPlot = false;
        else
            doPlot = true;
        end
    else
        p = data(end-seconds*samplerate:end,:);
        doPlot = true;
    end
    
    % Checking if figure exist
    if isempty(findobj('type','figure','name','Electrode test'))
        programRunning = false;
    end
    
    % Checking if electrodes are equal
    equalArray = isEqual(p);
    
    if ~isempty(equalArray)
        for i = 1:size(equalArray,1)
            sprintf('Electrode %d and %d may be connected', equalArray(i,1), equalArray(i,2));
        end
    end
    
    
    if programRunning
        if doPlot
            title('Electrode test')
            for i = 1:4
                subplot(4,1,i)
                plot(p(:,i))
                xlim([0 seconds*samplerate])
                text = sprintf('Electrode %d', i);
                ylabel(text)
            end
            pause(1e-6)
        end
    end
    
    
end

%% Saving data
Data = struct('Filename',   filename, ...
    'Subjectname',          subname, ...
    'SamplingFrequency',    samplerate, ...
    'gender',               gender, ...
    'age',                  age, ...
    'BCIexperience',        BCIexperience, ...
    'data',                 data);

save(filename, 'Data');
fprintf('File saved. All done! \n')

%% Clearing recording object
delete(ai);
clear ai
