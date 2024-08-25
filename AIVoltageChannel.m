classdef AIVoltageChannel < channel
    
    methods
        function obj = AIVoltageChannel(taskHandle, physicalChannel, name, lib, inputs)
            % Constructor: Initialize channel properties and create the channel
            obj.physicalChannel = physicalChannel;
            obj.lib = lib;
            obj.taskHandle = taskHandle;
            obj.name = name;

            % Extract and cast the arguments
            terminalConfig = int32(inputs{1});
            minVal = inputs{2};  % double
            maxVal = inputs{3};  % double
            customScaleName = '';  
            channelName = name;
            units = obj.DAQmx.Val_Volts;

            % Call the DAQmxCreateAIVoltageChan function
            err = calllib(lib, 'DAQmxCreateAIVoltageChan', ...
                taskHandle, ...          % voidPtr
                physicalChannel, ...     % cstring
                channelName, ...         % cstring
                terminalConfig, ...      % int32
                minVal, ...              % double
                maxVal, ...              % double
                units, ...               % int32
                customScaleName);        % cstring

            % Check for errors using the updated error handling function
            obj.handleDAQmxError(lib, err);
            % Add cases for other channel types as needed
            % e.g., AnalogOutputVoltage, DigitalInput, etc.

        end

        % Add other methods as needed (e.g., setChannelProperty)
    end
end


% classdef channel
%     properties
%         channelType;      % Type of the channel (e.g., AI, AO, DI, DO)
%         physicalChannel;  % Physical channel string (e.g., 'Dev1/ai0')
%         channelName;      % Name of the channel
%         lib;              % Library alias
%         taskHandle;       % Handle to the parent task
%     end
%
%     methods
%         function obj = channel(channelType, taskHandle, physicalChannel, channelName, lib, varargin)
%             % Constructor: Initialize channel properties and create the channel
%             obj.channelType = channelType;
%             obj.physicalChannel = physicalChannel;
%             obj.channelName = channelName;
%             obj.lib = lib;
%             obj.taskHandle = taskHandle;
%
%             % Configure the channel based on its type
%             switch channelType
%                 case 'AnalogInputVoltage'
%                     % Check that the correct number of arguments are provided
%                     if numel(varargin) < 4
%                         error('Not enough input arguments for AnalogInputVoltage channel creation.');
%                     end
%
%                     % Extract and cast the arguments
%                     terminalConfig = int32(varargin{1});
%                     minVal = varargin{2};  % double
%                     maxVal = varargin{3};  % double
%                     units = int32(varargin{4});
%
%                     % The customScaleName is optional
%                     if numel(varargin) >= 5
%                         customScaleName = varargin{5};  % cstring
%                     else
%                         customScaleName = '';  % Default to an empty string
%                     end
%
%                     % Call the DAQmxCreateAIVoltageChan function
%                     err = calllib(lib, 'DAQmxCreateAIVoltageChan', ...
%                                   taskHandle, ...          % voidPtr
%                                   physicalChannel, ...     % cstring
%                                   channelName, ...         % cstring
%                                   terminalConfig, ...      % int32
%                                   minVal, ...              % double
%                                   maxVal, ...              % double
%                                   units, ...               % int32
%                                   customScaleName);        % cstring
%
%                     % Check for errors using the updated error handling function
%                     handleDAQmxError(lib, err);
%                 % Add cases for other channel types as needed
%                 % e.g., AnalogOutputVoltage, DigitalInput, etc.
%                 otherwise
%                     error('Unsupported channel type.');
%             end
%         end
%
%         % Add other methods as needed (e.g., setChannelProperty)
%     end
% end
%
% % classdef channel
% %     properties
% %         channelType;      % Type of the channel (e.g., AI, AO, DI, DO)
% %         physicalChannel;  % Physical channel string (e.g., 'Dev1/ai0')
% %         channelName;      % Name of the channel
% %         lib;              % Library alias
% %         taskHandle;       % Handle to the parent task
% %     end
% %
% %     methods
% %         function obj = channel(channelType, taskHandle, physicalChannel, channelName, lib, varargin)
% %             % Constructor: Initialize channel properties and create the channel
% %             obj.channelType = channelType;
% %             obj.physicalChannel = physicalChannel;
% %             obj.channelName = channelName;
% %             obj.lib = lib;
% %             obj.taskHandle = taskHandle;
% %
% %             % Configure the channel based on its type
% %             switch channelType
% %                 case 'AnalogInputVoltage'
% %                     % Check that the correct number of arguments are provided
% %                     if numel(varargin) < 4
% %                         error('Not enough input arguments for AnalogInputVoltage channel creation.');
% %                     end
% %
% %                     % Extract and cast the arguments
% %                     terminalConfig = int32(varargin{1});
% %                     minVal = varargin{2};  % double
% %                     maxVal = varargin{3};  % double
% %                     units = int32(varargin{4});
% %
% %                     % The customScaleName is optional
% %                     if numel(varargin) >= 5
% %                         customScaleName = varargin{5};  % cstring
% %                     else
% %                         customScaleName = '';  % Default to an empty string
% %                     end
% %
% %                     % Call the DAQmxCreateAIVoltageChan function
% %                     err = calllib(lib, 'DAQmxCreateAIVoltageChan', ...
% %                                   taskHandle, ...          % voidPtr
% %                                   physicalChannel, ...     % cstring
% %                                   channelName, ...         % cstring
% %                                   terminalConfig, ...      % int32
% %                                   minVal, ...              % double
% %                                   maxVal, ...              % double
% %                                   units, ...               % int32
% %                                   customScaleName);        % cstring
% %
% %                     % Check for errors
% %                     if err ~= 0
% %                         errStr = char(zeros(1, 1024));
% %                         calllib(lib, 'DAQmxGetErrorString', err, errStr, 1024);
% %                         error('DAQmx Error: %s', errStr);
% %                     end
% %                 % Add cases for other channel types as needed
% %                 % e.g., AnalogOutputVoltage, DigitalInput, etc.
% %                 otherwise
% %                     error('Unsupported channel type.');
% %             end
% %         end
% %
% %         % Add other methods as needed (e.g., setChannelProperty)
% %     end
% % end
