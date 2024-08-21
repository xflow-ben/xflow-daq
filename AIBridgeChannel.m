classdef AIBridgeChannel < channel
    
    methods
        function obj = AIBridgeChannel(taskHandle, physicalChannel, lib, inputs)
            % Constructor: Initialize channel properties and create the channel
            obj.physicalChannel = physicalChannel;
            obj.lib = lib;
            obj.taskHandle = taskHandle;

            % Extract and cast the arguments
            minVal = inputs{1};  % double
            maxVal = inputs{2};  % double
            units = inputs{3};
            bridgeConfig = inputs{4};
            voltageExcitSource = inputs{5};
            voltageExcitVal = inputs{6};
            nominalBridgeResistance = inputs{7};
            channelName = '';
            customScaleName = ''; 

            % Call the DAQmxCreateAIVoltageChan function
            err = calllib(lib, 'DAQmxCreateAIBridgeChan', ...
                taskHandle, ...          % voidPtr
                physicalChannel, ...     % cstring
                channelName, ...         % cstring
                minVal, ...              % double
                maxVal, ...              % double
                units, ...               % int32
                bridgeConfig,...
                voltageExcitSource,...
                voltageExcitVal,...
                nominalBridgeResistance,...
                customScaleName);        % cstring

            % Check for errors using the updated error handling function
            obj.handleDAQmxError(lib, err);
            % Add cases for other channel types as needed
            % e.g., AnalogOutputVoltage, DigitalInput, etc.

        end

        % Add other methods as needed (e.g., setChannelProperty)
    end
end
