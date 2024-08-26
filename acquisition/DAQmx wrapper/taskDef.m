classdef taskDef < sharedFunctions
    properties
        taskName = '';    % Name of the task (supplied by user)
        taskType;
        rate;             % task rate
        startTrigger = struct('source','software','terminal','','exportTerminal','','autoTerminal','') % properties pertaining to how this task group starts
        sampleClock = struct('source','auto','terminal','','exportTerminal','','autoTerminal',''); % properties pertaining to the sample clock
        startOrder = 0;
        metaData = struct;
        recordModuleTemp = struct('interval',0,'moduleNames',{}); 
    end

    properties (SetAccess = private, GetAccess = public)
        numChans = 0;
        channels;         % List of channel objects
        taskHandle;       % Task handle
        startedExternally;
        bufferSize = 0; % Buffer size (on pc) per channel for
        startTime = struct('t',[datetime,datetime],'hasStartTime',[]);
    end

    properties (Access = private)
        lib;              % Library alias (inherited from xfedaq)
        fileTimer = timer;
        logFileNamePath = '';
    end

    properties (Hidden, SetAccess = public, GetAccess = public)
         logging = struct;
        durationSeconds;
        acquisitionType;
    end

    methods
        function obj = taskDef(taskType, taskName, rate, startOrder, logging, acquisitionType, durationSeconds,lib)
            % Constructor: Initialize task properties and create a DAQmx task
            obj.durationSeconds = durationSeconds;
            obj.acquisitionType = acquisitionType;
            obj.logging = logging;
            obj.startOrder = startOrder;
            obj.taskType = taskType;
            obj.taskName = taskName;
            obj.rate = rate;
            obj.lib = lib;
            %obj.availableChannels = availableChannels;
            obj.taskHandle = libpointer('voidPtr', 0);
            err = calllib(lib, 'DAQmxCreateTask', taskName, obj.taskHandle);
            obj.handleDAQmxError(lib, err);
            obj.channels = {};

            obj.startTrigger.source = 'software'; % options are 'software' and 'userDefined'
            obj.startTrigger.terminal = '';
            obj.startTrigger.exportTerminal = '';
            obj.sampleClock.source = 'auto';
            obj.sampleClock.terminal = '';
            obj.sampleClock.exportTerminal = '';

            obj.bufferSize = round(obj.rate*2);
            obj.startedExternally = 0;
            obj.fileTimer = timer('Name',obj.taskName);
        end

        function set.taskType(obj,value)
            if ~ismember(value,obj.taskTypeOptions)
                errString = 'Allowable options for task type are ';
                for i = 1:length(obj.taskTypeOptions)
                    errString = [errString,', ',obj.taskTypes{i}];
                end
                errString = [errString(1:end-1),'\n'];
                error(errString)
            end
            obj.taskType = value;
        end


        function set.startTrigger(obj,value)
            allowableFields = {'source','terminal','exportTerminal','autoTerminal'};
            allowableSources = {'software','userDefined'};
            fieldNames = fields(value);
            for i = 1:length(fieldNames)
                if ~ismember(fieldNames{i},allowableFields)
                    error('Allowable fields for startTrigger are ''source, terminal'', and ''exportTerminal''')
                end
            end
            if ~ismember(value.source,allowableSources)
                error('Allowable values for source are ''software'' and ''userDefined''')
            end
            if ~strcmp(value.terminal,'')
                value.source = 'userDefined';
                obj.startedExternally = 1;
            end
            obj.startTrigger = value;
        end

        function set.sampleClock(obj,value)
            allowableFields = {'source','terminal','exportTerminal','autoTerminal'};
            allowableSources = {'auto','userDefined'};
            fieldNames = fields(value);
            for i = 1:length(fieldNames)
                if ~ismember(fieldNames{i},allowableFields)
                    error('Allowable fields for sampleClock are ''source, terminal'', and ''exportTerminal''')
                end
            end
            if ~ismember(value.source,allowableSources)
                error('Allowable values for source are ''auto'' and ''userDefined''')
            end
            if ~strcmp(value.terminal,'')
                value.source = 'userDefined';
                obj.startedExternally = 1;
            end
            obj.sampleClock = value;
        end


        function delete(obj)
            % Destructor: Clear the task
            if ~isempty(obj.taskHandle)
                err = calllib(obj.lib, 'DAQmxClearTask', obj.taskHandle);
                obj.handleDAQmxError(obj.lib,err)
            end
        end

        function configSampleClock(obj)
            % obj.setTaskState('unreserve');
            if isempty(obj.sampleClock.terminal) || strcmp(obj.sampleClock.terminal,'')
                sampleClockTerminal = '';
            else
                sampleClockTerminal = obj.sampleClock.terminal;
            end

            if ismember(obj.logging.mode,{'log','log and read'}) % make sure buffer isze is right if we are logging
                [obj.bufferSize, ~, ~] = obj.calculateSizes(obj.rate, obj.durationSeconds);
            end
            sampleModeInt = obj.getConstInputVal('sampleMode',obj.acquisitionType,{'finite','continuous'},[obj.DAQmx.Val_FiniteSamps,obj.DAQmx.Val_ContSamps]);
            if strcmp(obj.acquisitionType,'finite')
                err = calllib(obj.lib, 'DAQmxCfgSampClkTiming', obj.taskHandle, sampleClockTerminal, obj.rate, obj.DAQmx.Val_Rising, sampleModeInt, uint64(obj.rate*obj.durationSeconds));
            else
                 err = calllib(obj.lib, 'DAQmxCfgSampClkTiming', obj.taskHandle, sampleClockTerminal, obj.rate, obj.DAQmx.Val_Rising, sampleModeInt, uint64(obj.bufferSize));
            end
            obj.handleDAQmxError(obj.lib, err);
            
            obj.setTaskState('verify');
            obj.setTaskState('reserve');
            obj.setTaskState('commit');

            if ~isempty(obj.startTrigger.terminal)
                obj.setStartTrigTerm(obj.startTrigger.terminal);
            end
        

            obj.sampleClock.autoTerminal = obj.getSampleClockTerm();
            % sampleClockString = obj.getSampleClockTerm();
            % if strcmp(obj.sampleClock.source,'userDefined')
            %     if ~strcmp(sampleClockString,obj.sampleClock.terminal)
            %         error('Tried to set sample clock to %s, but it was set to %s',obj.sampleClock.terminal,sampleClockString)
            %     end
            %     obj.sampleClock.autoTerminal = obj.sampleClock.terminal;
            % else
            %     obj.sampleClock.autoTerminal = sampleClockString;
            % end

            obj.startTrigger.autoTerminal = obj.getStartTrigTerm();
            % startTrigTermString = obj.getStartTrigTerm();
            % if strcmp(obj.startTrigger.source,'userDefined')
            %     if ~strcmp(startTrigTermString,obj.startTrigger.terminal)
            %         error('Tried to set start trigger terimal to %s, but it was set to %s',obj.startTrigger.terminal,startTrigTermString)
            %     end
            %     obj.startTrigger.autoTerminal = obj.startTrigger.terminal;
            % else
            %     obj.startTrigger.autoTerminal = startTrigTermString;
            % end

            rate_actual = obj.getSampClkRate();
            if rate_actual ~= obj.rate
                warning('Sample rate has been force modified by the DAQ to %.0f',rate_actual);
                obj.setTaskState('unreserve');
                obj.rate = rate_actual;
                [obj.bufferSize, ~] = obj.calculateSizes(obj.rate, obj.durationSeconds);
                obj.configSampleClock();
                obj.setTaskState('verify');
                obj.setTaskState('commit');
                obj.setTaskState('reserve');
            end
   


        end

        function temperature = getModuleTemperature(obj, deviceName)
            % Create a pointer to store the temperature value
            temperaturePtr = libpointer('doublePtr', 0);

            % Call the DAQmx function to get the internal temperature
            err = calllib(obj.lib, 'DAQmxGetCalDevTemp', deviceName, temperaturePtr);

            obj.handleDAQmxError(obj.lib,err)
            % Retrieve the temperature value
            temperature = temperaturePtr.Value;
        end

        function chanObj = addChannel(obj, channelType, device, physicalChannel, name, varargin)
            switch channelType
                case 'AIVoltage'
                    if ~strcmp(obj.taskType,'AI')
                        error('Task must be of type ''AI'' to add AIVoltage channel')
                    end
                    % could check input formats here
                case 'CICountEdges'
                    if ~strcmp(obj.taskType,'CI')
                        error('Task must be of type ''CI'' to add CICountEdges channel')
                    end
                case 'AIResistance'
                    if ~strcmp(obj.taskType,'AI')
                        error('Task must be of type ''AI'' to add AIResistance channel')
                    end
                case 'AIRTD'
                    if ~strcmp(obj.taskType,'AI')
                        error('Task must be of type ''AI'' to add AIRTD channel')
                    end
                case 'AIBridge'
                    if ~strcmp(obj.taskType,'AI')
                        error('Task must be of type ''AI'' to add AIBridge channel')
                    end
                otherwise
                    error('Channel type %s not yet programmed, or spelled incorrectly',channelType)
            end
            chanObj = channel(obj.lib, obj.taskHandle, channelType, device, physicalChannel, name, varargin);
            obj.numChans = obj.numChans + 1;
            % Create a new channel object and add it to the channels list
            obj.channels{end+1} = chanObj;
        end

                % function checkIfConfigured(obj)
        %     % Check if the user has set up all required parameters before
        %     if obj.rate == 0.0
        %         error('obj.rate Rate must first be set');
        %     end
        %     if obj.bufferSize == 0
        %         error('obj.bufferSize must first be set');
        %     end
        %     if isempty(obj.acquisitionType)
        %         error('obj.acquisitionType must first be set');
        %     end
        % 
        % end

        function startTask(obj)
            
            if ~isempty(obj.recordModuleTemp) && obj.recordModuleTemp.interval ~= 0
                if obj.recordModuleTemp.interval == -1
                    for i = 1:length(obj.recordModuleTemp.moduleNames)
                        obj.metaData.([temperature,'_',obj.recordModuleTemp.moduleNames{i}]) = obj.getModuleTemperature(obj.recordModuleTemp.moduleNames{i});
                    end
                else
                    error('I haven''t programmed getting the module temps on a reoccuring basis');
                end
            end
            % Start the task
            obj.startTime.t(1) = datetime("now");
            [err,~] = calllib(obj.lib, 'DAQmxStartTask', obj.taskHandle);
            obj.startTime.t(1) = datetime("now");
            obj.startTime.hasStartTime = 1;
            obj.handleDAQmxError(obj.lib, err);
            fprintf('Task "%s" started successfully.\n', obj.taskType);


            if ismember(obj.logging.mode,{'log','log and read'})
                obj.fileTimer.StartDelay = obj.durationSeconds;              % Set the delay before execution
                obj.fileTimer.TimerFcn = @(src,event)obj.insertMetaData(src,event);        % Set the function to be executed
                obj.fileTimer.ExecutionMode = 'singleShot'; % Execute the function only once
                start(obj.fileTimer)
            end
        end

        function stopTask(obj)
            % Stop the task
                [err,~]  = calllib(obj.lib, 'DAQmxStopTask', obj.taskHandle);
                obj.handleDAQmxError(obj.lib, err);

        end

        function doneFlag = isTaskDone(obj)
            isTaskDonePtr = libpointer('uint32Ptr', 0);
            err = calllib(obj.lib, 'DAQmxIsTaskDone', obj.taskHandle, isTaskDonePtr);
            obj.handleDAQmxError(obj.lib,err);
            doneFlag = isTaskDonePtr.Value;
        end

        function data = readData(obj, numSampsPerChan,timeout)
            % Read analog data from the task's channels
            arraySizeInSamps = obj.numChans*numSampsPerChan;
            % Preallocate array to store read data

            sampsPerChanRead = libpointer('int32Ptr', 0);
            fillMode = uint32(0); % 0 for DAQmx.Val_GroupByChannel, 1 for DAQmx.Val_GroupByScanNumber

            switch obj.taskType(1:2)
                case 'AI' % read from analog tasks
                    readArray = libpointer('doublePtr', zeros(1, arraySizeInSamps));
                    err = calllib(obj.lib, 'DAQmxReadAnalogF64', obj.taskHandle, int32(numSampsPerChan), ...
                        timeout, fillMode, readArray, uint32(arraySizeInSamps), sampsPerChanRead, []);
                case 'CI' % read from counter tasks
                    readArray = libpointer('uint32Ptr', zeros(1, arraySizeInSamps));
                    err = calllib(obj.lib, 'DAQmxReadCounterU32', obj.taskHandle, int32(numSampsPerChan), ...
                        timeout, fillMode, readArray, uint32(arraySizeInSamps), sampsPerChanRead, []);
                otherwise
                    error('I don''t know how to read data from task type: %s',obj.taskType);
            end

            obj.handleDAQmxError(obj.lib, err);
            if sampsPerChanRead.Value > 0
                data = reshape(readArray.Value(1:sampsPerChanRead.Value*obj.numChans),[sampsPerChanRead.Value,obj.numChans]);
            else
                data = [];
            end
        end


        function sampleClockString = getSampleClockTerm(obj)
            strBufferSize = 255;
            [err,~,sampleClockString] = calllib(obj.lib,'DAQmxGetSampClkTerm',obj.taskHandle,blanks(strBufferSize),uint32(strBufferSize));
            obj.handleDAQmxError(obj.lib, err);
        end

        function startTrigTermString = getStartTrigTerm(obj)
            strBufferSize = 255;
            [err,~,startTrigTermString] = calllib(obj.lib,'DAQmxGetStartTrigTerm',obj.taskHandle,blanks(strBufferSize),uint32(strBufferSize));
            obj.handleDAQmxError(obj.lib, err);
        end


        function setStartTrigTerm(obj,sourceTerminal)
            err = calllib(obj.lib,'DAQmxCfgDigEdgeStartTrig',obj.taskHandle,sourceTerminal,obj.DAQmx.Val_Rising);
            obj.handleDAQmxError(obj.lib, err);
            % err = calllib(obj.lib,'DAQmxSetStartTrigType',obj.taskHandle,obj.DAQmx.Val_DigEdge);
            % obj.handleDAQmxError(obj.lib, err);
            % err = calllib(obj.lib,'DAQmxSetDigEdgeStartTrigSrc',obj.taskHandle,sourceTerminal);
            % obj.handleDAQmxError(obj.lib, err);
            % err = calllib(obj.lib,'DAQmxSetDigEdgeStartTrigEdge',obj.taskHandle,obj.DAQmx.Val_Rising);
            % obj.handleDAQmxError(obj.lib, err);
            obj.startTrigger.terminal = sourceTerminal;
            % obj.setTaskState('verify');
            % obj.setTaskState('reserve');
            % obj.setTaskState('commit');
        end


        function err = setTaskState(obj, targetState)
            try
                % Convert the target state to the corresponding integer value
                targetStateInt = obj.getConstInputVal('targetState', targetState, ...
                    {'start', 'stop', 'verify', 'commit', 'reserve', 'unreserve', 'abort'}, ...
                    [obj.DAQmx.Val_Task_Start, obj.DAQmx.Val_Task_Stop, obj.DAQmx.Val_Task_Verify, ...
                    obj.DAQmx.Val_Task_Commit, obj.DAQmx.Val_Task_Reserve, obj.DAQmx.Val_Task_Unreserve, ...
                    obj.DAQmx.Val_Task_Abort]);

                % Call the DAQmx function
                err = calllib(obj.lib, 'DAQmxTaskControl', obj.taskHandle, targetStateInt);

                % Handle any potential DAQmx errors
                obj.handleDAQmxError(obj.lib, err);
            catch ME
                if err ~= -89131
                    % Display the error message but continue returning the err value
                    disp(['Error in setTaskState: ', ME.message]);
                end
            end
        end


        function rate = getAIConvRate(obj)
            ratePtr = libpointer('doublePtr',0);
            [err,~,rate] = calllib(obj.lib,'DAQmxGetAIConvRate',obj.taskHandle,ratePtr);
            obj.handleDAQmxError(obj.lib, err);
        end

        function rate = getSampClkRate(obj)
            ratePtr = libpointer('doublePtr',0);
            [err,~,rate] = calllib(obj.lib,'DAQmxGetSampClkRate',obj.taskHandle,ratePtr);
            obj.handleDAQmxError(obj.lib, err);
        end

        function sampClkTimebaseSrc = getSampClkTimebaseSrc(obj)
            strBufferSize = uint32(255);
            [err,~,sampClkTimebaseSrc] = calllib(obj.lib,'DAQmxGetSampClkTimebaseSrc',obj.taskHandle,blanks(strBufferSize),strBufferSize);
            obj.handleDAQmxError(obj.lib, err);
        end

        function setSampClkTimebaseSrc(obj,timebaseSrc)
            err = calllib(obj.lib,'DAQmxSetSampClkTimebaseSrc',obj.taskHandle,timebaseSrc);
            obj.handleDAQmxError(obj.lib, err);
        end

        function setSampClkTimebaseRate(obj,rate)
            err = calllib(obj.lib,'DAQmxSetSampClkTimebaseRate',obj.taskHandle,rate);
            obj.handleDAQmxError(obj.lib, err);
        end

        function configureLogging(obj,directoryPath,fileNamePrefix,loggingMode)
            %sampsPerFile,fileWriteSize,filePreallocationSize 
            
            % buffer size = 10x file write size
            % file write size = 1 second
           % determine file name
           obj.logFileNamePath = obj.makeNextFileNum(directoryPath,fileNamePrefix,obj.taskName);
           if ismember(loggingMode,{'log','log and read'})
               % if obj.rate > 512 && mod(log2(obj.rate),1) ~= 0
               %     error('For file logging faster than 512 samp/s, rate must be a power of 2')
               % end
               if obj.durationSeconds < 1.0
                    error('durationSeconds must be at least 1 second')
               end
               if mod(obj.durationSeconds,1) ~= 0
                   error('durationSeconds must be an integer number of seconds')
               end
           end

           [obj.bufferSize, fileWriteSize, sampsPerFile] = obj.calculateSizes(obj.rate, obj.durationSeconds);
            fprintf('rate %.2f, durationSeconds %d, Buffersize %d, filewritesize %d, sampsperfil %d\n',obj.rate,obj.durationSeconds,obj.bufferSize,fileWriteSize,sampsPerFile)
           % filePreallocationSize = sampsPerFile; % probs need to configure them later


            loggingModeInt = obj.getConstInputVal('loggingMode',loggingMode,{'off','log','log and read'},[obj.DAQmx.Val_Off,obj.DAQmx.Val_Log,obj.DAQmx.Val_LogAndRead]);
            err = calllib(obj.lib,'DAQmxConfigureLogging',obj.taskHandle,obj.logFileNamePath, loggingModeInt, obj.taskName, obj.DAQmx.Val_Create);
            obj.handleDAQmxError(obj.lib, err);

            err = calllib(obj.lib,'DAQmxSetLoggingSampsPerFile',obj.taskHandle, uint64(sampsPerFile));
            obj.handleDAQmxError(obj.lib, err);

            err = calllib(obj.lib,'DAQmxSetLoggingFileWriteSize',obj.taskHandle, uint32(fileWriteSize));
            obj.handleDAQmxError(obj.lib, err);

            %     err = calllib(obj.lib,'DAQmxSetLoggingFilePreallocationSize',obj.taskHandle, uint64(filePreallocationSize));
            %     obj.handleDAQmxError(obj.lib, err);

        end


        function disableLogging(obj)
            err = calllib(obj.lib,'DAQmxConfigureLogging',obj.taskHandle,obj.logFileNamePath, obj.DAQmx.Val_Off, obj.taskName, obj.DAQmx.Val_Create);
            obj.handleDAQmxError(obj.lib, err);
        end

        function newFileName = incrementFileNumber(~,fileName)
            if strcmp(fileName(end-4:end),'.tdms')
                fileName = fileName(1:end-5);
            end

            if all(isstrprop(fileName(end-3:end),'digit'))
                fileNum = str2double(fileName(end-3:end));
                fileName = fileName(1:end-4);
            else
                fileNum = 0;
                fileName = [fileName,'_'];
            end
            fileNum = fileNum + 1;
            newFileName = sprintf('%s%04.0f.tdms',fileName,fileNum);
        end

        function fullFilePathOut = makeNextFileNum(~,directoryPath,fileNamePrefix,taskName)

           TemplogFileNamePath = fullfile(directoryPath,[fileNamePrefix,'_',taskName,'*.tdms']);
           files = dir(TemplogFileNamePath);
           if isempty(files)
               nextFileNum = 0;
           else
               for i = 1:length(files)
                    fileNums(i) = str2double(files(i).name(end-8:end-5));
               end
               if any(isnan(fileNums))
                   error('error retreiving file numbers')
               end
               nextFileNum = max(fileNums) + 1;
           end
           fullFilePathOut = fullfile(directoryPath,[fileNamePrefix,'_',taskName,'_',sprintf('%04.0f',nextFileNum),'.tdms']);
        end


        function [bufferSize, fileWriteSize, samplesPerFile] = calculateSizes(~,rate, fileLengthSeconds)

            % Constants
            SECTOR_SIZE = 512;          % bytes
            SAMPLE_SIZE = 8;            % bytes per sample (float64)
            SAMPLES_PER_SECTOR = SECTOR_SIZE / SAMPLE_SIZE; % 64 samples
            BUFFER_MULTIPLIER = 8;      % Buffer size should be a multiple of 8 times the sector size

            % Calculate samplesPerFile
            samplesPerFile = rate * fileLengthSeconds;

            % Ensure rate is a power of 2 if it is above 512
            % if mod(log2(rate), 1) ~= 0 && rate ~= 1
            %     error('Rate must be a power of 2, or equal to 1');
            % end

            fileWriteSize = rate;
            % % Calculate fileWriteSize that is a multiple of 64 samples and meets other constraints
            % % If samplesPerFile is small, choose the smallest aligned fileWriteSize
            % if samplesPerFile < SAMPLES_PER_SECTOR
            %     fileWriteSize = SAMPLES_PER_SECTOR;
            % else
            %     % potentialFileWriteSizes = SAMPLES_PER_SECTOR:SAMPLES_PER_SECTOR:samplesPerFile;
            %     % validFileWriteSizes = potentialFileWriteSizes(mod(potentialFileWriteSizes, rate) == 0);
            %     % fileWriteSize = min(validFileWriteSizes);
            %     fileWriteSize = ceil(rate / SAMPLES_PER_SECTOR) * SAMPLES_PER_SECTOR;
            % end



            bufferSize = 8 * fileWriteSize;
            % 
            % if bufferSize < 8 * SAMPLES_PER_SECTOR
            %     bufferSize = 8 * SAMPLES_PER_SECTOR;
            % else
            %     bufferSize = round(bufferSize / (SAMPLES_PER_SECTOR * 8)) *  (SAMPLES_PER_SECTOR * 8);
            % end
            % % Ensure buffer size is aligned with 8 times the sector size
            % % bufferSize = max(bufferSize, BUFFER_MULTIPLIER * SAMPLES_PER_SECTOR);
            % % bufferSize = ceil(bufferSize / (BUFFER_MULTIPLIER * SAMPLES_PER_SECTOR)) * (BUFFER_MULTIPLIER * SAMPLES_PER_SECTOR);
            % 
            % % Final validation
            % if mod(fileWriteSize, SAMPLES_PER_SECTOR) ~= 0 || mod(bufferSize, BUFFER_MULTIPLIER * SAMPLES_PER_SECTOR) ~= 0
            %     error('The resulting buffer size or file write size does not meet the alignment requirements.');
            % end
        end



        function insertMetaData(obj,~,~)


            tdmsFilePath = obj.logFileNamePath;
            
            if strcmp(obj.acquisitionType,'finite') % if acquisition mode is finite, need to
                % 1) wait until task(s) are done
                count = 0;
                tasksDone = 0;
                while ~tasksDone && count < 100
                    tasksDone = obj.isTaskDone();
                    count = count + 1;
                    pause(0.05)
                end
                if tasksDone == 0
                    error('Tasks did not finish before timeout')
                end

                % 2) stop the tasks
                obj.stopTask();
                pause(0.05)
                % 3) disable logging

                obj.disableLogging(); % may need to switch the target file for logging here

                obj.setTaskState('verify');
                obj.setTaskState('commit');
                obj.setTaskState('reserve');

            end



            % Handle to the TDMS file
            fileHandle = int64(0);

            % Open the TDMS file
            [err, ~,~,fileHandle] = calllib('tdmlib', 'DDC_OpenFile', tdmsFilePath, '', fileHandle);

            if err ~= 0
                count = 0;
                while count < 10 && err ~= 0
                    pause(0.5)
                    count = count + 1;
                    fileHandle = int64(0);
                    [err, ~,~,fileHandle] = calllib('tdmlib', 'DDC_OpenFile', tdmsFilePath, '', fileHandle);
                end

                if err ~= 0
                    error('Unable to open the new file')
                end
            end

            if ~isempty(fields(obj.metaData))
                % add the metaData
                fieldNames = fields(obj.metaData);
                for i = 1:length(fieldNames)
                    value = obj.metaData.(fieldNames{i});
                    if isnumeric(value)
                        strValue = sprintf('%.10f',value);
                    elseif ischar(value)
                        strValue = value;
                    else
                        error('Unknown data type for metaData field %s',fieldNames{i})
                    end
                    err = calllib('tdmlib', 'DDC_CreateFilePropertyString', fileHandle, fieldNames{i},strValue);
                    assert(err == 0, 'Failed to set metaData field to property in tdmsfile');
                end
            end

            err = calllib('tdmlib','DDC_CreateFilePropertyDouble',fileHandle,'rate',obj.rate);
            assert(err == 0, 'Failed to set rate to tdms file');


            if obj.startTime.hasStartTime
                % add the start times

                % Get the current time (or define your specific time)
                startPropertyNames = {'MATLABStartTimeBefore','MATLABStartTimeAfter'};

                for i = 1:2
                    nyear = year(obj.startTime.t(i));
                    nmonth = month(obj.startTime.t(i));
                    nday = day(obj.startTime.t(i));
                    nhour = hour(obj.startTime.t(i));
                    nminute = minute(obj.startTime.t(i));
                    nsecond = floor(second(obj.startTime.t(i)));
                    nmillisecond = mod(second(obj.startTime.t(i)),1)*1000;

                    % Set the timestamp property
                    err = calllib('tdmlib', 'DDC_CreateFilePropertyTimestampComponents', fileHandle, startPropertyNames{i}, ...
                        uint32(nyear), uint32(nmonth), uint32(nday), uint32(nhour), uint32(nminute), uint32(nsecond),nmillisecond);
                    assert(err == 0, 'Failed to set MATLAB start time property in tdms file');
                end
            end


            err = calllib('tdmlib', 'DDC_SaveFile', fileHandle);
            assert(err == 0, 'Failed to save TDMS file');

            err = calllib('tdmlib', 'DDC_CloseFile', fileHandle);
            assert(err == 0, 'Failed to close TDMS file');
            
            % If logging is finite, re-enable logging, incrementing the file number
            if strcmp(obj.acquisitionType,'finite') % if acquisition mode is finite, need to
                obj.setTaskState('unreserve');
                obj.configureLogging(obj.logging.directoryPath,obj.logging.fileNamePrefix,obj.logging.mode);
                obj.setTaskState('verify');
                obj.setTaskState('commit');
                obj.setTaskState('reserve');
            end

        end


    end
end

