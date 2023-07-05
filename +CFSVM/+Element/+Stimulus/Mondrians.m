classdef Mondrians < CFSVM.Element.Stimulus.Stimulus
    % Manipulating Mondrian masks.
    %
    % Derived from :class:`~CFSVM.Element.Stimulus.Stimulus`.
    %

    properties (Constant)

        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset'}

    end

    properties

        % Float in Hz, number of masks flashed per one second.
        temporal_frequency {mustBeNonnegative}
        % Int - overall max number of masks from blocks and trials.
        n_max {mustBeNonnegative, mustBeInteger}
        % 1D array representing masks index for every frame.
        indices {mustBeInteger}
        % Cell array storing arguments for PTB's Screen('DrawTextures') for
        % masks, stimuli, fixation and checkframe.
        args cell
        % 1D array recording onset times of every frame.
        vbls {mustBeNonnegative}
        % Path to .mat file generated by CFS_crafter.
        crafter_masks

    end

    methods

        function obj = Mondrians(kwargs)
            %
            % Args:
            %   dirpath: :attr:`CFSVM.Element.Stimulus.Stimulus.dirpath`.
            %       Defaults to ''.
            %   temporal_frequency:
            %       :attr:`~CFSVM.Element.Stimulus.Mondrians.temporal_frequency`.
            %       Defaults to 10.
            %   duration: :attr:`CFSVM.Element.TemporalElement.duration`.
            %       Defaults to 5.
            %   position: :attr:`CFSVM.Element.Stimulus.Stimulus.position`.
            %       Defaults to "Center".
            %   xy_ratio: :attr:`CFSVM.Element.Stimulus.Stimulus.xy_ratio`.
            %       Defaults to 1.
            %   size: :attr:`CFSVM.Element.Stimulus.Stimulus.size`.
            %       Defaults to 1.
            %   padding: :attr:`CFSVM.Element.Stimulus.Stimulus.padding`.
            %       Defaults to 0.
            %   rotation: :attr:`CFSVM.Element.Stimulus.Stimulus.rotation`.
            %       Defaults to 0.
            %   contrast: :attr:`CFSVM.Element.SpatialElement.contrast`.
            %       Defaults to 1.
            %   blank: :attr:`CFSVM.Element.Stimulus.Stimulus.blank`.
            %       Defaults to 0.
            %   crafter_masks:
            %       :attr:`~CFSVM.Element.Stimulus.Mondrians.crafter_masks`.
            %       Defaults to ''.
            %   manual_rect:
            %       :attr:`CFSVM.Element.Stimulus.Stimulus.manual_rect`.
            %
            arguments
                kwargs.dirpath = ''
                kwargs.temporal_frequency = 10
                kwargs.duration = 5
                kwargs.position = "Center"
                kwargs.xy_ratio = 1
                kwargs.size = 1
                kwargs.padding = 0
                kwargs.rotation = 0
                kwargs.contrast = 1
                kwargs.blank = 0
                kwargs.crafter_masks = ''
                kwargs.manual_rect
            end

            parameters_names = fieldnames(kwargs);

            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = kwargs.(parameters_names{name});
            end

        end

        function get_max(obj, trial_matrix)
            % Gets overall maximum number of masks from all blocks and trials.
            %
            % Args:
            %   trial_matrix: Cell array with blocks and trials from the trials object.
            %

            temp_freqs = cellfun(@(block) (cellfun(@(trial) (trial.masks.temporal_frequency), block)), trial_matrix, UniformOutput = false);
            mask_durations = cellfun(@(block) (cellfun(@(trial) (trial.masks.duration), block)), trial_matrix, UniformOutput = false);
            max_temporal_frequency = max([temp_freqs{:}]);
            max_mask_duration = max([mask_durations{:}]);

            obj.n_max = max_temporal_frequency * max_mask_duration;

        end

        function shuffle(obj)
            % Shuffles masks textures.

            random_order = randperm(length(obj.textures.PTB_indices));
            obj.textures.PTB_indices = obj.textures.PTB_indices(random_order);
            obj.textures.images_names = obj.textures.images_names(random_order);

        end

        function load_rect_parameters(obj, screen, is_left_suppression)
            % Calculates rects depending on suppression side for the trial.
            %
            % Args:
            %   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
            %   is_left_suppression: bool
            %

            if is_left_suppression
                if ~isempty(obj.manual_rect)
                    obj.rect = obj.get_manual_rect(screen.fields{1}.rect);
                else
                    obj.rect = obj.get_rect(screen.fields{1}.rect);
                end
            else
                if ~isempty(obj.manual_rect)
                    obj.rect = obj.get_manual_rect(screen.fields{2}.rect);
                else
                    obj.rect = obj.get_rect(screen.fields{2}.rect);
                end
            end

        end

        function load_flashing_parameters(obj, screen)
            % Calculates parameters for flashing for the trial.
            %
            % Args:
            %   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
            %
            if ~isempty(obj.crafter_masks)
                obj.indices = 1:screen.frame_rate * obj.duration + 1;
            else
                obj.indices = arrayfun(@(n) (ceil(n / (screen.frame_rate / obj.temporal_frequency))), ...
                                       1:(screen.frame_rate * obj.duration + 1));
            end

        end

        function import_from_crafter(obj, window)
            % Import masks in CFS-crafter format.
            %
            % Args:
            %   window: PTB window pointer.
            %
            stimuli = load(obj.crafter_masks).stimuli;
            [~, name, ext] = fileparts(obj.crafter_masks);
            for img_index = 1:size(stimuli.stimuli_array, 4)
                image = stimuli.stimuli_array(:, :, :, img_index);
                obj.textures.PTB_indices{img_index} = Screen('MakeTexture', window, image);
                obj.textures.images_names{img_index} = strcat(name, ext);
            end
            obj.textures.len = length(obj.textures.PTB_indices);
        end

    end

end
