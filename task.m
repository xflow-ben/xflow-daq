classdef task < sharedFunctions
    properties
        taskName;         % Name of the task
        taskHandle;       % Task handle
        channels;         % List of channel objects
        lib;              % Library alias (inherited from xfedaq)
        availableChannels % Stored available channels for validation
        isMaster;         % 1 = this is the task that drives trigger + sample clock
        numChans = 0;
    end
    
    methods
        function obj = task(taskName, lib)
            % Constructor: Initialize task properties and create a DAQmx task
            obj.taskName = taskName;
            obj.lib = lib;
            %obj.availableChannels = availableChannels;
            obj.taskHandle = libpointer('voidPtr', 0);
            err = calllib(lib, 'DAQmxCreateTask', taskName, obj.taskHandle);
            obj.handleDAQmxError(lib, err);
            obj.channels = {};
        end
        
        function delete(obj)
            % Destructor: Clear the task
            if ~isempty(obj.taskHandle)
                calllib(obj.lib, 'DAQmxClearTask', obj.taskHandle);
            end
        end

        function configSampleClock(obj,sampleClockTerminal,rate,sampleMode,sampsPerChanToAcquire)

            if isempty(sampleClockTerminal) || strcmp(sampleClockTerminal,'')
                sampleClockTerminal = '';
            end
            sampleModeInt = obj.getConstInputVal('sampleMode',sampleMode,{'finite','continuous'},[obj.DAQmx.Val_FiniteSamps,obj.DAQmx.Val_ContSamps]);
            err = calllib(obj.lib, 'DAQmxCfgSampClkTiming', obj.taskHandle, sampleClockTerminal, rate, obj.DAQmx.Val_Rising, sampleModeInt, uint64(sampsPerChanToAcquire));
            obj.handleDAQmxError(obj.lib, err);
        end
        
        function chanObj = createChannel(obj, channelType, physicalChannel, varargin)
            % Validate the physical channel before creating the channel
            % obj.validateChannel(physicalChannel);
            switch channelType
                case 'AIVoltage'
                    chanObj = AIVoltageChannel(obj.taskHandle, physicalChannel, obj.lib, varargin);
                    obj.numChans = obj.numChans + 1;
                case 'CICountEdges'
                    chanObj = CICountEdgesChannel(obj.taskHandle, physicalChannel, obj.lib, varargin);
                    obj.numChans = obj.numChans + 1;
                case 'AIResistance'
                    chanObj = AIResistanceChannel(obj.taskHandle,physicalChannel,obj.lib,varargin);
                    obj.numChans = obj.numChans + 1;
                case 'AIBridge'
                    chanObj = AIBridgeChannel(obj.taskHandle,physicalChannel,obj.lib,varargin);
                    obj.numChans = obj.numChans + 1;
            end
            
            % Create a new channel object and add it to the channels list
            obj.channels{end+1} = chanObj;
        end

        function startTime = startTask(obj)
            % Start the task
            startTime(1) = datetime("now");
            [err,~] = calllib(obj.lib, 'DAQmxStartTask', obj.taskHandle);
            startTime(2) = datetime("now");
            obj.handleDAQmxError(obj.lib, err);
            fprintf('Task "%s" started successfully.\n', obj.taskName);
        end

        function stopTask(obj)
            % Stop the task
            [err,~]  = calllib(obj.lib, 'DAQmxStopTask', obj.taskHandle);
            obj.handleDAQmxError(obj.lib, err);
            fprintf('Task "%s" stopped successfully.\n', obj.taskName);
        end

        function data = readData(obj, numSampsPerChan,timeout)
            % Read analog data from the task's channels
            arraySizeInSamps = obj.numChans*numSampsPerChan;
            % Preallocate array to store read data

            sampsPerChanRead = libpointer('int32Ptr', 0);
            fillMode = uint32(0); % 0 for DAQmx.Val_GroupByChannel, 1 for DAQmx.Val_GroupByScanNumber
            
            switch obj.taskName(1:2)
                case 'AI' % read from analog tasks
            readArray = libpointer('doublePtr', zeros(1, arraySizeInSamps));
            err = calllib(obj.lib, 'DAQmxReadAnalogF64', obj.taskHandle, int32(numSampsPerChan), ...
                timeout, fillMode, readArray, uint32(arraySizeInSamps), sampsPerChanRead, []);
                case 'CI' % read from counter tasks
                    readArray = libpointer('uint32Ptr', zeros(1, arraySizeInSamps));
                    err = calllib(obj.lib, 'DAQmxReadCounterU32', obj.taskHandle, int32(numSampsPerChan), ...
                        timeout, fillMode, readArray, uint32(arraySizeInSamps), sampsPerChanRead, []);
                otherwise
                    error('I don''t know how to read data from task type: %s',obj.taskName);
            end

            obj.handleDAQmxError(obj.lib, err);
            if sampsPerChanRead.Value > 0
                data = reshape(readArray.Value(1:sampsPerChanRead.Value*obj.numChans),[sampsPerChanRead.Value,obj.numChans]);
            else
                data = [];
            end
        end


        function sampleClockString = getSampleClockTerm(obj)
            bufferSize = 255;
            [err,~,sampleClockString] = calllib(obj.lib,'DAQmxGetSampClkTerm',obj.taskHandle,blanks(bufferSize),uint32(bufferSize));
            obj.handleDAQmxError(obj.lib, err);
        end

      function startTrigTermString = getStartTrigTerm(obj)
            bufferSize = 255;
            [err,~,startTrigTermString] = calllib(obj.lib,'DAQmxGetStartTrigTerm',obj.taskHandle,blanks(bufferSize),uint32(bufferSize));
            obj.handleDAQmxError(obj.lib, err);
        end


        function setStartTrigTerm(obj,sampleClockTerm)
            err = calllib(obj.lib,'DAQmxSetStartTrigType',obj.taskHandle,obj.DAQmx.Val_DigEdge);
            obj.handleDAQmxError(obj.lib, err);
            err = calllib(obj.lib,'DAQmxSetDigEdgeStartTrigSrc',obj.taskHandle,sampleClockTerm);
            obj.handleDAQmxError(obj.lib, err);
            err = calllib(obj.lib,'DAQmxSetDigEdgeStartTrigEdge',obj.taskHandle,obj.DAQmx.Val_Rising);
            obj.handleDAQmxError(obj.lib, err);
        end


        function setTaskState(obj,targetState)
            targetStateInt = obj.getConstInputVal('targetState',targetState,{'start','stop','verify','commit','reserve','unreserve','abort'},[obj.DAQmx.Val_Task_Start,obj.DAQmx.Val_Task_Stop,obj.DAQmx.Val_Task_Verify,obj.DAQmx.Val_Task_Commit,obj.DAQmx.Val_Task_Reserve,obj.DAQmx.Val_Task_Unreserve,obj.DAQmx.Val_Task_Abort]);
            err = calllib(obj.lib,'DAQmxTaskControl',obj.taskHandle,targetStateInt);
            obj.handleDAQmxError(obj.lib, err);
        end
        
        function rate = getAIConvRate(obj)
            ratePtr = libpointer('doublePtr',0);
            [err,~,rate] = calllib(obj.lib,'DAQmxGetAIConvRate',obj.taskHandle,ratePtr);
            obj.handleDAQmxError(obj.lib, err);
            % [int32, voidPtr, doublePtr] DAQmxGetAIConvRate(voidPtr, doublePtr)
            % int32 __CFUNC DAQmxGetAIConvTimebaseSrc(TaskHandle taskHandle, int32 *data);


        end

        function rate = getSampClkRate(obj)
            ratePtr = libpointer('doublePtr',0);
            [err,~,rate] = calllib(obj.lib,'DAQmxGetSampClkRate',obj.taskHandle,ratePtr);
            obj.handleDAQmxError(obj.lib, err);
            % [int32, voidPtr, doublePtr] DAQmxGetAIConvRate(voidPtr, doublePtr)
            % int32 __CFUNC DAQmxGetAIConvTimebaseSrc(TaskHandle taskHandle, int32 *data);


        end

       function sampClkTimebaseSrc = getSampClkTimebaseSrc(obj)
            bufferSize = uint32(255);
            [err,~,sampClkTimebaseSrc] = calllib(obj.lib,'DAQmxGetSampClkTimebaseSrc',obj.taskHandle,blanks(bufferSize),bufferSize);
            obj.handleDAQmxError(obj.lib, err);
            % [int32, voidPtr, doublePtr] DAQmxGetAIConvRate(voidPtr, doublePtr)
            % int32 __CFUNC DAQmxGetAIConvTimebaseSrc(TaskHandle taskHandle, int32 *data);

       end

       function setSampClkTimebaseSrc(obj,timebaseSrc)
            err = calllib(obj.lib,'DAQmxSetSampClkTimebaseSrc',obj.taskHandle,timebaseSrc);
            obj.handleDAQmxError(obj.lib, err);
       end

       function setSampClkTimebaseRate(obj,rate)
           err = calllib(obj.lib,'DAQmxSetSampClkTimebaseRate',obj.taskHandle,rate);
           obj.handleDAQmxError(obj.lib, err);
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

