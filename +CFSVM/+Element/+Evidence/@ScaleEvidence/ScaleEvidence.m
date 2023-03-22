classdef (Abstract) ScaleEvidence < CFSVM.Element.Evidence.Response & CFSVM.Element.TemporalElement
% A base class for description of scale-based evidence classes like 
% :class:`~+CFSVM.+Element.+Evidence.@PAS` and
% :class:`~+CFSVM.+Element.+Evidence.@ImgMAFC`.
%
% Derived from :class:`~+CFSVM.+Element.+Evidence.@Response` 
% and :class:`~+CFSVM.+Element.@TemporalElement` classes.
%

    properties

        title  % Char array representing title or question shown on screen.
        title_size  % Int
        options  % Cell array of chars 
        n_options  % Int - length(obj.keys)

    end
    
    methods (Access = protected)

        record_response(obj)

    end
end
