function load_parameters(obj)
    % Precalculates and updates parameters for every oncoming trial.
    %
    % Loads parameters from trial matrix and then precalculates other
    % parameters that depend on initialised window, i.e. masks, stimuli,
    % fixation, pas and mafc parameters.
    %

    for block = 1:obj.trials.n_blocks
        obj.trials.block_index = block;
        for trial = 1:size(obj.trials.matrix{block}, 2)
            obj.trials.trial_index = trial;

            % Get an array of stimuli properties
            prop_list = obj.trials.matrix{block}{trial}.get_dyn_props;
            stim_props = {};
            for prop_idx = 1:length(prop_list)
                c = class(obj.trials.matrix{block}{trial}.(prop_list{prop_idx}));
                if c == "CFSVM.Element.Stimulus.SuppressedStimulus"
                    stim_props{end + 1} = prop_list{prop_idx};
                end
            end

            obj.trials.load_trial_parameters(obj);

            obj.masks.load_flashing_parameters(obj.screen);
            obj.masks.load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression);
            if isempty(obj.masks.crafter_masks)
                obj.masks.shuffle();
            end

            for prop_idx = 1:length(stim_props)
                obj.(stim_props{prop_idx}).load_flashing_parameters(obj.screen, obj.masks);
                obj.(stim_props{prop_idx}).load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression);
            end

            obj.frame.reset();
            obj.frame.initiate(obj.screen.fields{1});
            obj.frame.initiate(obj.screen.fields{2});

            obj.target.load_rect_parameters(obj.screen);

            obj.fixation.preload_args(obj.screen);

            obj.pas.load_parameters(obj.screen);
            if class(obj.mafc) == "CFSVM.Element.Evidence.ImgMAFC"
                obj.mafc.load_parameters(obj.screen, obj.(prop_list{1}).textures.PTB_indices, obj.(prop_list{1}).index);
            end

            % Preload masks and stimuli args
            obj.preload_stim_and_masks_args(stim_props);
        end
    end
end
