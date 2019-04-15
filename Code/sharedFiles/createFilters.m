function filterReturn = createFilters(filter)
% DESCRIPTION OF FUNCTION
% This function creates the filters, that are needed for FBCSP
%
% INPUT
% filter:		Filter struct with the options
%
% OUTPUT:
% filterReturn: Filter struct to return	
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

order = filter.order;
fs = filter.fs;


F3dB1 = filter.F3dB1;
F3dB2 = filter.F3dB2;
rippleStop = filter.rippleStop;
nBands = filter.nBands;
type = filter.type;
nFilter = filter.nFilters;


if(isempty(type))
    
else
    if(strcmp(type,'butter'))
        filter.filterVector{nFilter} = designfilt('bandpassiir','FilterOrder',order ...
            ,'HalfPowerFrequency1',F3dB1,'HalfPowerFrequency2',F3dB2, ...
            'SampleRate',fs,'DesignMethod', type);
        
    elseif(strcmp(type,'lbutter'))
        %        filter.filterVector{nFilter} = designfilt('lowpassiir','FilterOrder',order ...
        %            ,'CutoffFrequency1',F3dB2,'SampleRate',fs,'DesignMethod', 'butter');
        filter.filterVector{nFilter} = designfilt('lowpassiir', 'FilterOrder', ...
            order, 'HalfPowerFrequency', ...
            F3dB2, 'SampleRate', 250, ...
            'DesignMethod', 'butter');
        
        
    elseif(strcmp(type,'cheby2'))
        filter.filterVector{nFilter} = designfilt('bandpassiir', 'FilterOrder', ...
            order, 'StopbandFrequency1', ...
            F3dB1, 'StopbandFrequency2', ...
            F3dB2, 'StopbandAttenuation', ...
            rippleStop, 'SampleRate', fs, ...
            'DesignMethod', type);
        
        
        
        
    end
    
    
    filter.nFilters = nFilter +1;
    filterReturn = filter;
end

