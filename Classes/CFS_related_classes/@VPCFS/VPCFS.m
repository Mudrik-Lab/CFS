classdef VPCFS < CFS
    %VPCFS Visual priming continuous flash suppression.
    % Child (inherited) class of the CFS parent class.
    %
    % VPCFS Methods:
    %   run_the_experiment - main function for the experiment loop.
    %   show_targets - shows targets after the suppressing pattern phase.
    % See also CFS
    %     prime_images_path - path to a directory with prime images. VPCFS only.
    %     target_presentation_duration - duration of target after the suppression. VPCFS only.
    
    properties
        subject_info;
        trials;
        stimulus;
        target;
        frame;
        screen;
        fixation;
        masks;
        pas;
        mafc;
        results;
    end
    
    methods

        function run_the_experiment(obj)
            %run_the_experiment Runs the Visual Priming experiment.
            % Shows fixation cross, flashes the masks, fades in the prime
            % image, shows the target images, runs PAS and mAFC.
            obj.initiate();
            
            for block = 1:obj.trials.n_blocks
                obj.trials.block_index = block;
                for trial = 1:height(obj.trials.blocks{block})
                    obj.trials.start_time = GetSecs();
                    obj.trials.trial_index = trial;
                    obj.load_parameters();
                    if trial ~= 1 || block ~= 1
                        obj.rest_screen();
                    end

                    obj.vbl = obj.fixation.show(obj);
                    
                    obj.flash();
                    obj.target.show(obj);
                    obj.pas.show(obj.screen);
                    obj.mafc.show(obj.screen);
                    obj.trials.end_time = GetSecs();
                    obj.results.import_from(obj);
                    obj.results.add_trial_to_table();
                    obj.results.save(obj.subject_info.code)
                end
            end 
        end 
    end

    methods (Access=protected)
        function load_parameters(obj)

            obj.trials.load_trial_parameters(obj);
            
            obj.masks.load_flashing_parameters(obj.screen);
            obj.masks.load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)
            obj.masks.shuffle(10*obj.trials.block_index+obj.trials.trial_index);

            obj.stimulus.load_flashing_parameters(obj.masks);
            obj.stimulus.load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)

            obj.fixation.load_args(obj.screen);
            
            obj.stimulus.textures.index = obj.stimulus.textures.PTB_indices{obj.stimulus.index};
            
            obj.pas.load_parameters(obj.screen);
            if class(obj.mafc) == "ImgMAFC"
                obj.mafc.load_parameters(obj.screen, obj.stimulus.textures.PTB_indices, obj.stimulus.index);
            end
            
        end
    end
end
