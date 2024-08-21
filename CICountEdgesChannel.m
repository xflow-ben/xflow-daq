classdef CICountEdgesChannel < channel

    methods
        function obj = CICountEdgesChannel(taskHandle, physicalChannel, lib, inputs)
            % Constructor: Initialize channel properties and create the channel
            obj.physicalChannel = physicalChannel;
            obj.lib = lib;
            obj.taskHandle = taskHandle;
            channelName = '';

            % Extract and cast the arguments
            edgeDirection = int32(inputs{1});
            countDirection = inputs{3};  % double
            initialValue = int32(inputs{2});
            % Call the DAQmxCreateAIVoltageChan function
            % err = calllib('myni', 'DAQmxCreateCICountEdgesChan', 
            % counterTask.taskHandle, 
            % 'cDAQ9188-18F21FFMod2/ctr0', 
            % ''
            % , d.DAQmx_Val_Rising, int32(0), d.DAQmx_Val_CountUp);

            err = calllib(lib, 'DAQmxCreateCICountEdgesChan', ...
                taskHandle, ...          % voidPtr
                physicalChannel, ...     % cstring
                channelName, ...         % cstring
                edgeDirection, ...      % int32
                initialValue, ...              % double
                countDirection);        % cstring

            % Check for errors using the updated error handling function
            obj.handleDAQmxError(lib, err);
            % Add cases for other channel types as needed
            % e.g., AnalogOutputVoltage, DigitalInput, etc.

        end

        % Add other methods as needed (e.g., setChannelProperty)
    end
end
