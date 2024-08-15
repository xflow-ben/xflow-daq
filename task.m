classdef task
    properties
        taskName;         % Name of the task
        taskHandle;       % Task handle
        channels;         % List of channel objects
        lib;              % Library alias (inherited from xfedaq)
        availableChannels % Stored available channels for validation
    end
    
    methods
        function obj = task(taskName, lib, availableChannels)
            % Constructor: Initialize task properties and create a DAQmx task
            obj.taskName = taskName;
            obj.lib = lib;
            obj.availableChannels = availableChannels;
            obj.taskHandle = libpointer('voidPtr', 0);
            err = calllib(lib, 'DAQmxCreateTask', taskName, obj.taskHandle);
            handleDAQmxError(lib, err);
            obj.channels = {};
        end
        
        function delete(obj)
            % Destructor: Clear the task
            if ~isempty(obj.taskHandle)
                calllib(obj.lib, 'DAQmxClearTask', obj.taskHandle);
            end
        end
        
        function chanObj = createChannel(obj, channelType, physicalChannel, channelName, varargin)
            % Validate the physical channel before creating the channel
            % obj.validateChannel(physicalChannel);
            
            % Create a new channel object and add it to the channels list
            chanObj = channel(channelType, obj.taskHandle, physicalChannel, channelName, obj.lib, varargin{:});
            obj.channels{end+1} = chanObj;
        end

        function startTask(obj)
            % Start the task
            [err,~] = calllib(obj.lib, 'DAQmxStartTask', obj.taskHandle);
            handleDAQmxError(obj.lib, err);
            fprintf('Task "%s" started successfully.\n', obj.taskName);
        end

        function stopTask(obj)
            % Stop the task
            [err,~]  = calllib(obj.lib, 'DAQmxStopTask', obj.taskHandle);
            handleDAQmxError(obj.lib, err);
            fprintf('Task "%s" stopped successfully.\n', obj.taskName);
        end

        function data = readAnalog(obj, numSampsPerChan, timeout, arraySizeInSamps)
            % Read analog data from the task's channels
            
            % Preallocate array to store read data
            % readArray = zeros(1, arraySizeInSamps);
            readArray = libpointer('doublePtr', zeros(1, arraySizeInSamps));
            sampsPerChanRead = libpointer('int32Ptr', 0);
            fillMode = uint32(0); % 0 for DAQmx_Val_GroupByChannel, 1 for DAQmx_Val_GroupByScanNumber

            % Call the DAQmx function to read the data
            % err = calllib(obj.lib, 'DAQmxReadAnalogF64', ...
            %               obj.taskHandle, int32(numSampsPerChan), ...
            %               timeout, double(0), readArray, ...
            %               uint32(arraySizeInSamps), sampsPerChanRead, []);

        err = calllib(obj.lib, 'DAQmxReadAnalogF64', obj.taskHandle, int32(numSampsPerChan), ...
              timeout, fillMode, readArray, uint32(arraySizeInSamps), sampsPerChanRead, []);

            % voidPtr, int32, double, uint32, doublePtr, uint32, int32Ptr, uint32Ptr)
            %TaskHandle taskHandle, int32 numSampsPerChan, float64 timeout, bool32 fillMode, float64 readArray[], uInt32 arraySizeInSamps, int32 *sampsPerChanRead, bool32 *reserved);

            handleDAQmxError(obj.lib, err);
            
            % Return the data, trimming the array to the number of samples actually read
            data = readArray.Value(1:sampsPerChanRead.Value);
        end


        % function validateChannel(obj, physicalChannel)
        %     % Iterate through available channels to validate the input channel
        %     validChannels = [];
        %     keys = obj.availableChannels.keys;
        %     for i = 1:numel(keys)
        %         validChannels = [validChannels, obj.availableChannels(keys{i})];
        %     end
        % 
        %     if ~ismember(physicalChannel, validChannels)
        %         error('Invalid physical channel: %s. It does not exist on the connected devices.', physicalChannel);
        %     end
        % 
        %     % Check if the channel has already been added to the task
        %     for i = 1:numel(obj.channels)
        %         if strcmp(obj.channels{i}.physicalChannel, physicalChannel)
        %             error('Duplicate channel: %s has already been added to this task.', physicalChannel);
        %         end
        %     end
        % end
    end
end



% classdef task
%     properties
%         taskName;     % Name of the task
%         taskHandle;   % Task handle
%         channels;     % List of channel objects
%         lib;          % Library alias (inherited from xfedaq)
%     end
% 
%     methods
%         function obj = task(taskName, lib)
%             % Constructor: Initialize task properties and create a DAQmx task
%             obj.taskName = taskName;
%             obj.lib = lib;
%             obj.taskHandle = libpointer('voidPtr', 0);
%             err = calllib(lib, 'DAQmxCreateTask', taskName, obj.taskHandle);
%             handleDAQmxError(lib, err);
%             obj.channels = {};
%         end
% 
%         function delete(obj)
%             % Destructor: Clear the task
%             if ~isempty(obj.taskHandle)
%                 calllib(obj.lib, 'DAQmxClearTask', obj.taskHandle);
%             end
%         end
% 
%         function chanObj = createChannel(obj, channelType, physicalChannel, channelName, varargin)
%             % Create a new channel object and add it to the channels list
%             chanObj = channel(channelType, obj.taskHandle, physicalChannel, channelName, obj.lib, varargin{:});
%             obj.channels{end+1} = chanObj;
%         end
% 
%         function chanObj = getChannel(obj, index)
%             % Retrieve a channel object by index
%             if index > 0 && index <= numel(obj.channels)
%                 chanObj = obj.channels{index};
%             else
%                 error('Channel index out of range.');
%             end
%         end
% 
%         function startTask(obj)
%             % Start the task
%             err = calllib(obj.lib, 'DAQmxStartTask', obj.taskHandle);
%             handleDAQmxError(obj.lib, err);
%         end
% 
%         function stopTask(obj)
%             % Stop the task
%             err = calllib(obj.lib, 'DAQmxStopTask', obj.taskHandle);
%             handleDAQmxError(obj.lib, err);
%         end
% 
%         function readAnalog(obj, numSampsPerChan, timeout, readArray, arraySizeInSamps, sampsPerChanRead)
%             % Read analog data from the task
%             err = calllib(obj.lib, 'DAQmxReadAnalogF64', obj.taskHandle, numSampsPerChan, timeout, readArray, arraySizeInSamps, sampsPerChanRead, []);
%             handleDAQmxError(obj.lib, err);
%         end
%     end
% end
% 
% % classdef task
% %     properties
% %         taskName;     % Name of the task
% %         taskHandle;   % Task handle
% %         channels;     % List of channel objects
% %         lib;          % Library alias (inherited from xfedaq)
% %     end
% % 
% %     methods
% %         function obj = task(taskName, lib)
% %             % Constructor: Initialize task properties and create a DAQmx task
% %             obj.taskName = taskName;
% %             obj.lib = lib;
% %             obj.taskHandle = libpointer('voidPtr', 0);
% %             err = calllib(lib, 'DAQmxCreateTask', taskName, obj.taskHandle);
% %             handleDAQmxError(lib, err);
% %             obj.channels = {};
% %         end
% % 
% %         function delete(obj)
% %             % Destructor: Clear the task
% %             if ~isempty(obj.taskHandle)
% %                 calllib(obj.lib, 'DAQmxClearTask', obj.taskHandle);
% %             end
% %         end
% % 
% %         function chanObj = createChannel(obj, channelType, physicalChannel, channelName, varargin)
% %             % Create a new channel object and add it to the channels list
% %             % Pass along the arguments required by the channel constructor
% %             chanObj = channel(channelType, obj.taskHandle, physicalChannel, channelName, obj.lib, varargin{:});
% %             obj.channels{end+1} = chanObj;
% %         end
% % 
% %         function chanObj = getChannel(obj, index)
% %             % Retrieve a channel object by index
% %             if index > 0 && index <= numel(obj.channels)
% %                 chanObj = obj.channels{index};
% %             else
% %                 error('Channel index out of range.');
% %             end
% %         end
% % 
% %         function startTask(obj)
% %             % Start the task
% %             err = calllib(obj.lib, 'DAQmxStartTask', obj.taskHandle);
% %             handleDAQmxError(obj.lib, err);
% %         end
% % 
% %         function stopTask(obj)
% %             % Stop the task
% %             err = calllib(obj.lib, 'DAQmxStopTask', obj.taskHandle);
% %             handleDAQmxError(obj.lib, err);
% %         end
% % 
% %         function readAnalog(obj, numSampsPerChan, timeout, readArray, arraySizeInSamps, sampsPerChanRead)
% %             % Read analog data from the task
% %             err = calllib(obj.lib, 'DAQmxReadAnalogF64', obj.taskHandle, numSampsPerChan, timeout, readArray, arraySizeInSamps, sampsPerChanRead, []);
% %             handleDAQmxError(obj.lib, err);
% %         end
% % 
% %         % Add more task-related methods as needed
% %     end
% % end
