classdef (Abstract) TemporalElement < handle
% A base class describing elements with temporal properties.
%

    properties

        onset  % Float - onset time
        offset  % Float - offset time
        duration  % Float - duration time
        
    end

end
