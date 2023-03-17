classdef CustomScreen < handle
% Storing and manipulating left and right screen areas.
    
    properties

        % Cell array of :class:`~+CFS.+Element.+Screen.@ScreenField` objects.
        fields
        % Int for number of pixels shifted on keypress while adjusting screens.
        shift
        % Char array of 7 chars containing HEX color.
        background_color
        % PTB window object.
        window
        % Float for time between two frames ≈ 1/frame_rate.
        inter_frame_interval
        % Float for display refresh rate.
        frame_rate

    end


    methods
        
        function obj = CustomScreen(parameters)
        %
        % Args:
        %   background_color: :attr:`~.+CFS.+Element.+Screen.@CustomScreen.CustomScreen.background_color`
        %   is_stereo: bool for setting two screenfields.
        %   initial_rect: [x0, y0, x1, y1] array with pixel positions, if is_stereo, position of the left field.
        %   shift: :attr:`~.+CFS.+Element.+Screen.@CustomScreen.CustomScreen.shift`
        %
        
            arguments
                parameters.background_color
                parameters.is_stereo = false;
                parameters.initial_rect = [0,0,945,1080]
                parameters.shift = 15
            end
            
            obj.background_color = parameters.background_color;
            obj.fields{1} = CFS.Element.Screen.ScreenField(parameters.initial_rect);
            if parameters.is_stereo
                set(0,'units','pixels')  
                screen_size = get(0,'ScreenSize');
                second_rect = [ ...
                    screen_size(3)-parameters.initial_rect(3), ...
                    parameters.initial_rect(2), ...
                    screen_size(3)-parameters.initial_rect(1), ...
                    parameters.initial_rect(4)];
                obj.fields{2} = CFS.Element.Screen.ScreenField(second_rect);
            end
            obj.shift = parameters.shift;
            
        end
        
        adjust(obj, frame)

    end

end

