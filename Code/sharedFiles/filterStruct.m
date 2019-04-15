classdef filterStruct
% DESCRIPTION OF STRUCT
% This struct contains the filters used in functions.
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

    
    properties
        alphaBP;
        betaBP;
        gammaBP;
        deltaBP;
        thetaBP;
        customBP;
        filterHigh;
        filterLow;
        fs;
        filterVector;
        rippleStop = 60;
        nFilters = 1;
        F3dB1;
        F3dB2;
        nBands;
        type;
        order;
        
    end
    
    methods
        
        
        
    end
    
end

