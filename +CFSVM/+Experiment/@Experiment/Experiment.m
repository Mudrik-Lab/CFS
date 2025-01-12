classdef (Abstract) Experiment < dynamicprops & matlab.mixin.Copyable
    % Base for :class:`~CFSVM.Experiment.CFS` and :class:`~CFSVM.Experiment.VM` classes.
    %
    % Describes very basic methods fomr initiation of PTB-3 window to
    % comments containing screens shown to the subject.
    %

    properties (Hidden = true)

        dynpropnames  % Variable for saving names of dynamic properties.
        save_to_dir

    end

    methods

        function obj = Experiment(kwargs)
            arguments
                kwargs.save_to_dir {mustBeTextScalar} = "./Raw"
            end
            obj.save_to_dir = CFSVM.Utils.rel2abs(kwargs.save_to_dir);
        end

        addprop(obj, prop_name)
        dynpropnames = get_dyn_props(obj)
        initiate_window(obj)

    end

    methods (Access = protected)

        % Override copyElement method:
        function copied_obj = copyElement(obj)
            % Make a shallow copy of all properties
            copied_obj = copyElement@matlab.mixin.Copyable(obj);
            % Make a deep copy of handle props
            props = properties(obj);
            for idx = 1:length(props)
                if isa(obj.(props{idx}), 'handle')
                    copied_obj.(props{idx}) = copy(obj.(props{idx}));
                end
            end
        end

    end

end
