classdef AIResistanceChannel < channel
    
    methods
        function obj = AIResistanceChannel(taskHandle, physicalChannel, name, lib, inputs)
            % Constructor: Initialize channel properties and create the channel
            obj.physicalChannel = physicalChannel;
            obj.lib = lib;
            obj.taskHandle = taskHandle;
            obj.name = name;

            % Extract and cast the arguments
            minVal = inputs{1};  % double
            maxVal = inputs{2};  % double
            resistanceConfig = inputs{3};
            currentExcitSource = inputs{4};
            currentExcitVal = inputs{5};
            units = obj.DAQmx.Val_Ohms;
            customScaleName = '';  
            channelName = name;
     
            % Call the DAQmxCreateAIVoltageChan function
            err = calllib(lib, 'DAQmxCreateAIResistanceChan', ...
                taskHandle, ...          % voidPtr
                physicalChannel, ...     % cstring
                channelName, ...         % cstring
                minVal, ...              % double
                maxVal, ...              % double
                units, ...               % int32
                resistanceConfig,...
                currentExcitSource,...
                currentExcitVal,...
                customScaleName);        % cstring

            % Check for errors using the updated error handling function
            obj.handleDAQmxError(lib, err);
            % Add cases for other channel types as needed
            % e.g., AnalogOutputVoltage, DigitalInput, etc.

        end

        % Add other methods as needed (e.g., setChannelProperty)
    end
end

