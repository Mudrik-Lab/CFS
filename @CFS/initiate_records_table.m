function initiate_records_table(obj)
    %initiate_records_table Initiates structure for subject responses.
    switch class(obj)
        case 'VPCFS'
            output_variables = {'block', 'trial', ... 
                'trial_start_time', 'trial_end_time', 'trial_duration', ...
                'fixation_onset', 'mondrians_onset', 'stimulus_onset', ... 
                'stimulus_full_contrast_onset', 'stimulus_fade_out_onset', 'stimulus_offset', 'mondrians_offset', ...
                'stimulus_index', 'target_image_index', ... 
                'pas_method', 'pas_response', 'pas_onset', 'pas_response_time', 'pas_kbname', ...
                'afc_method', 'afc_response', 'afc_onset', 'afc_response_time', 'afc_kbname'};
        case 'BCFS'
            output_variables = {'breaking_key', 'breaking_time', 'block', 'trial', ...
                'trial_start_time', 'trial_end_time', 'trial_duration', ... 
                'fixation_onset', 'mondrians_onset', 'stimulus_onset', ...
                'stimulus_full_contrast_onset', 'stimulus_fade_out_onset', 'stimulus_offset', 'mondrians_offset', ...
                'stimulus_index', 'stimulus_position', ...
                'pas_method', 'pas_response', 'pas_onset', 'pas_response_time', 'pas_kbname'};
        case 'VACFS'
            output_variables = {'breaking_key', 'breaking_time', 'block', 'trial', ...
                'trial_start_time', 'trial_end_time', 'trial_duration', ... 
                'fixation_onset', 'mondrians_onset', 'stimulus_onset', ... 
                'stimulus_full_contrast_onset', 'stimulus_fade_out_onset', 'stimulus_offset', 'mondrians_offset', 'stimulus_index', ...
                'pas_method', 'pas_response', 'pas_onset', 'pas_response_time', 'pas_kbname', ...
                'afc_method', 'afc_response', 'afc_onset', 'afc_response_time', 'afc_kbname'};
    end
    obj.records  = cell2table(cell(0,length(output_variables)), ...
        'VariableNames', output_variables);

end
