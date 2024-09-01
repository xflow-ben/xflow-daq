classdef xfedaq < sharedFunctions
    % s = xfedaq creates a new task group (i.e. session). A session
    % contains a group of tasks that will be sampled at the same rate
    % (similar to d = daq('ni')) Currently, the first task added must be an
    % analog input, as that is the sample clock we use. This could be made
    % more flexible later
    %
    % sampleClock.source = 'auto', 'userDefined'
    % sampleClock.terminal = sample clock used by all tasks in this
    %   xfedaq instance
    % sampleClock.exportTerminal = where to export the terminal, if
    %   needed
    % sampleClock.rate = Acquisition rate
    %
    % startTrigger.source = 'software', 'userDefined'
    % startTrigger.terminal = start trigger used for all tasks in this
    %   xfedaq instance
    % startTrigger.exportTerminal = where to export the start trigger
    %   to, if needed
    %
    % logging.mode - options 'off','log', 'log and read'
    % logging.directoryPath - directory to save files in
    % logging.fileName - name of files to save
    %
    % groupName, name of this collection of tasks, used for group in tdms
    % logging


    % TO DO

    % each task needs to log to its own file
    % rate can now go just into the main file props, no need to do nonsense
    % with groups
    % add task type in addition to name. Name used in file name and in
    % group name of tdms file
    % Make start groups? So groups of tasks that are started together can
    % be indicated? Set up like slave_group_1, master_group_1, etc.
    % Modify start command to deal with groupings of tasks. Slave tasks get
    % start time of masters
    % file names gen via input + task name

    % when the start of this is triggered by another xfedaq instance, it
    % would be nice to still write the rate in, and any other data needed

    properties
        acquisitionType = ''; % 'finite' or 'continuous' - could leave this out for now
        logging = struct('mode','','directoryPath','','fileNamePrefix','');
        durationSeconds; % For continuous, number seconds of data per file. For finite, finite length of acquisition
    end

    properties (SetAccess = private, GetAccess = public)
        % visible to user, but not editable
        isFinalized = 0;
        task = taskDef.empty;  % List of task objects
        loggingConfigured = 0;
    end

    properties (Access = private)
        % not externally visible/editable
        lib = 'myni';  % Library alias



        dllPath = '..\..\lib\nicaiu.dll';%'C:\Windows\System32\nicaiu.dll';
        headerPath = '..\..\lib\NIDAQmx.h';%'C:\Program Files (x86)\National Instruments\NI-DAQ\DAQmx ANSI C Dev\include\NIDAQmx.h';
    end

    methods
        function obj = xfedaq(dllPath,headerPath)
            % Constructor: Load the library and retrieve device/channel info
            if ~libisloaded(obj.lib)
                if nargin == 1
                    error('Must provide both dllPath and headerPath, or neither');
                elseif nargin == 2
                    obj.dllPath = dllPath;
                    obj.headerPath  = headerPath;
                end
                mFilePath = fileparts(mfilename('fullpath'));
                obj.dllPath = fullfile(mFilePath,obj.dllPath);
                obj.headerPath = fullfile(mFilePath,obj.headerPath);

                if isempty(dir(obj.dllPath))
                    error('dll file not found at %s',obj.dllPath);
                end
                if isempty(dir(obj.headerPath))
                    error('dll file not found at %s',obj.dllPath);
                end
                warning off MATLAB:loadlibrary:TypeNotFound
                warning off MATLAB:loadlibrary:TypeNotFoundForStructure
                try
                    loadlibrary(obj.dllPath, obj.headerPath, 'alias', obj.lib);
                catch
                    error('Unable to load library. Note, Microsoft Visual C++ Redistributable for Visual Studio and MinGW compiler for MATLAB are required to be installed');
                end
            end
            % default options
            obj.acquisitionType = 'continuous';
            obj.logging.mode = 'off';
            obj.logging.directoryPath = '';

            obj.durationSeconds = 10;

        end

        function set.acquisitionType(obj,value)
            allowableValues = {'finite','continuous'};
            if ~ismember(value,allowableValues)
                error('Allowable values for acquisitionType are ''finite'' and ''continuous''')
            end
            for i = 1:length(obj.task)
                obj.task(i).acquisitionType = value;
            end
            obj.acquisitionType = value;
        end

        function set.durationSeconds(obj,value)
            if mod(value,1) ~= 0
                error('durationSeconds must be an integer')
            end
            obj.durationSeconds = value;
            for i = 1:length(obj.task)
                obj.task(i).durationSeconds = value;
            end
        end



        function set.logging(obj,value)
            allowableFields = {'mode','directoryPath','fileNamePrefix'};
            allowableModes = {'off','log','log and read'};
            fieldNames = fields(value);
            for i = 1:length(fieldNames)
                if ~ismember(fieldNames{i},allowableFields)
                    error('Allowable fields for logging are ''mode'', ''fileNamePrefix'', and ''directoryPath''')
                end
            end
            if ~ismember(value.mode,allowableModes)
                error('Allowable modes for logging are ''off'', ''log'', and ''log and read''')
            end
            if ~isempty(value.directoryPath) && isempty(dir(value.directoryPath))
                error('Directory provided %s not found',value.directoryPath);
            end
            obj.logging = value;
            for i = 1:length(obj.task)
                obj.task(i).logging = value;
            end
        end

        function stop(obj)
            % Stop all tasks
            for i = 1:length(obj.task)
                obj.task(i).stopTask();
            end

        end

        function reserveHardware(obj)
            for i = 1:length(obj.task)
                obj.task(i).setTaskState('reserve');
            end
        end


        function unreserveHardware(obj)
            for i = 1:length(obj.task)
                obj.task(i).setTaskState('unreserve');
            end
        end

        function delete(obj)
            % Destructor: Unload the library and clear tasks
            for i = 1:numel(obj.task)
                delete(obj.task(i));  % Ensure all tasks are properly deleted
            end

            if libisloaded(obj.lib)
                unloadlibrary(obj.lib);
            end
            if libisloaded('tdmlib')
                unloadlibrary('tdmlib')
            end
        end

        function taskObj = createTask(obj, taskType, taskName, rate, startOrder)
            % Create a new task object and add it to the tasks list
            % make sure the name doesn't already exist
            for i = 1:length(obj.task)
                if strcmp(obj.task(i).taskName,taskName)
                    error('A task with name %s already exists',taskName);
                end
            end
            taskObj = taskDef(taskType, taskName, rate, startOrder, obj.logging, obj.acquisitionType, obj.durationSeconds, obj.lib);
            obj.task(end+1) = taskObj;
        end


        function index = getTaskIndex(obj,taskName)

            if isempty(obj.task)
                index = -1;
            else
                names = {obj.task.taskName};
                index = find(ismember(names,taskName));
                if numel(index)>1
                    error('We ended up with more than one task of the same type somehow')
                elseif isempty(index)
                    index = -1;
                end
            end
        end

        % function finalizeSetup(obj)
        %
        %
        %
        %     if isempty(obj.task)
        %         error('You gotta add some channels before calling this')
        %     end
        %
        %     obj.task(1).configSampleClock(obj.acquisitionType);
        %
        %     if strcmp(obj.startTrigger.source,'userDefined') || ~isempty(obj.startTrigger.terminal)
        %         obj.task(1).setStartTrigTerm(obj.startTrigger.terminal)
        %         obj.startedExternally = 1;
        %     else
        %         obj.startedExternally = 0;
        %     end
        %
        %
        %
        %     % get the first task ready enough that the sample clock and
        %     % trigger gets set in the DAQ
        %     obj.task(1).setTaskState('verify');
        %     obj.task(1).setTaskState('reserve');
        %
        %     configureLogging(obj,directoryPath,fileNamePrefix,loggingMode,fileDurationSeconds)
        %
        %     if strcmp(obj.acquisitionType,'finite')
        %         obj.bufferSize = round(obj.durationSeconds*obj.rate);
        %     elseif strcmp(obj.acquisitionType,'continuous')
        %         obj.bufferSize = round(obj.rate);
        %     end
        %
        %     %% CHECK THE SAMPLE CLOCK
        %
        %     % get the sample clock and start terminal of the trigger of
        %     % first task
        %     rate_actual = obj.task(1).getSampClkRate();
        %     if rate_actual ~= obj.rate
        %         warning('Sample rate has been force modified by the DAQ to %.0f, buffer will be set to 2x this',rate_actual);
        %         obj.task(1).setTaskState('unreserve');
        %         obj.rate = rate_actual;
        %         if strcmp(obj.acquisitionType,'finite')
        %             obj.bufferSize = round(obj.durationSeconds*obj.rate);
        %         elseif strcmp(obj.acquisitionType,'continuous')
        %             obj.bufferSize = round(obj.rate);
        %         end
        %         obj.task(1).configSampleClock(obj.sampleClock.terminal,obj.rate,obj.acquisitionType,obj.bufferSize);
        %         obj.task(1).setTaskState('verify');
        %         obj.task(1).setTaskState('reserve');
        %     end
        %
        %     obj.task(1).setTaskState('commit');
        %     obj.numChans = obj.task(1).numChans;
        %     % Now we can set up the rest of the tasks
        %     for i = 2:length(obj.task)
        %         obj.task(i).configSampleClock(obj.sampleClock.autoTerminal,obj.rate,obj.acquisitionType,obj.bufferSize);
        %         if strcmp(obj.startTrigger.source,'userDefined')
        %             obj.task(i).setStartTrigTerm(obj.startTrigger.terminal);
        %         else
        %             obj.task(i).setStartTrigTerm(obj.startTrigger.autoTerminal);
        %         end
        %         obj.task(i).setTaskState('verify');
        %         err = obj.task(i).setTaskState('reserve');
        %         if err == -89131
        %             obj.task(i).configSampleClock('',obj.rate,obj.acquisitionType,obj.bufferSize);
        %             err = obj.task(i).setTaskState('reserve');
        %             if err == -89131
        %                 error('Same terminal routing error for sample clock')
        %             end
        %         end
        %
        %         obj.task(i).setTaskState('commit');
        %         obj.numChans = obj.numChans + obj.task(i).numChans;
        %     end
        %     % fprintf('Daq object is ready to star\n')
        %
        %     obj.isFinalized = 1;
        %
        % end

        function routeSignal(obj,sourceTerminal,destinationTerminal)
            err = calllib(obj.lib, 'DAQmxConnectTerms', sourceTerminal, destinationTerminal,obj.DAQmx.Val_DoNotInvertPolarity);
            obj.handleDAQmxError(obj.lib, err);
        end
        


        function resetDevice(obj,device)
            err = calllib(obj.lib, 'DAQmxResetDevice', device);
            obj.handleDAQmxError(obj.lib, err);
        end


        % function disconnectAllTerminals(obj)
        % 
        % 
        %     bufferSize = 2048;
        % 
        %     % Call DAQmxGetSysDevNames to get a comma-separated list of all device names
        %     [err, deviceNames] = calllib(obj.lib, 'DAQmxGetSysDevNames', blanks(bufferSize), bufferSize);
        %     obj.handleDAQmxError(obj.lib,err);
        % 
        %     % Split the device names into a cell array
        %     deviceList = strsplit(strtrim(deviceNames), ',');
        % 
        %     % Loop through each device to get and disconnect all terminals
        %     for i = 1:length(deviceList)
        %         device = strtrim(deviceList{i});
        %         bufferSize = 16384;
        %         % Get the list of terminals for this device
        %         [err, ~, terminalNames] = calllib(obj.lib, 'DAQmxGetDevTerminals', device, blanks(bufferSize), uint32(bufferSize));
        %         obj.handleDAQmxError(obj.lib,err);
        % 
        %         if err == 0
        %             % Split the terminal names into a cell array
        %             terminals = strsplit(strtrim(terminalNames), ',');
        % 
        %             % Disconnect each terminal
        %             for j = 1:length(terminals)
        %                 terminal = strtrim(terminals{j});
        %                 err = calllib(obj.lib, 'DAQmxDisconnectTerms', terminal, '');
        %                 if err ~= 0
        %                     disp(['Error disconnecting routes from ', terminal]);
        %                 else
        %                     disp(['Disconnected all routes from ', terminal]);
        %                 end
        %             end
        %         else
        %             disp(['Error getting terminals for device: ', device]);
        %         end
        %     end
        % 
        % end

        function data = readData(obj,samplesToRead,timeOut)
            if strcmp(obj.logging.mode,'log')
                error('Cannot read data when logging.mode is set to ''log''');
            end
            data = zeros([samplesToRead,obj.numChans]);
            col = 1;
            for i = 1:length(obj.task)
                data(:,col:col+obj.task(i).numChans-1) = obj.task(i).readData(samplesToRead,timeOut);
                col = col + obj.task(i).numChans;
            end
        end

        function configureLogging(obj,fileNamePrefix,directoryPath,mode)
            % Note: If the Logging.LoggingMode attribute/property is set to
            % Log Only, Logging.SampsPerFile must be divisible by the
            % Logging.FileWriteSize attribute/property, which is based, by
            % default, on the buffer size.
            %
            % If logging and reading data, ensure the number of samples per
            % channel to read is evenly divisible by the sector size of the
            % hard disk.

            % If manually configuring the buffer size, choose a multiple of
            % eight times the sector size of the hard disk. For instance,
            % if your sector size is 512 bytes, your buffer size might be
            % 4,096 samples. default, on the buffer size.

            % sectorSize = 4096; % bytes on a typical HD sector


            if nargin>1 && ~isempty(fileNamePrefix)
                obj.logging.fileNamePrefix = fileNamePrefix;
            elseif isempty(obj.logging.fileNamePrefix)
                error('fileName must be configured via this function or the logging.fileName property')
            end

            if nargin>2 && ~isempty(directoryPath)
                obj.logging.directoryPath = directoryPath;
            elseif isempty(obj.logging.directoryPath)
                error('directoryPath must be configured via this function or the logging.directoryPath property')
            end

            if nargin>3 && ~isempty(mode)
                obj.logging.mode = mode;
            elseif isempty(obj.logging.mode)
                obj.logging.mode = 'log';
                warning('logging.mode not set. Defaulting to ''log''')
            end

            for i = 1:length(obj.task)
                obj.task(i).configureLogging(obj.logging.directoryPath,obj.logging.fileNamePrefix,obj.logging.mode);
            end
            obj.loggingConfigured = 1;

        end

        function start(obj)
            % start the task group, or prepare it to start before a master
            % task group or harware trigger
            % if ~obj.isFinalized
            %     error('call obj.finalizeSetup before starting')
            % end

            if ismember(obj.logging.mode,{'log','log and read'})
                % then we need to deal with file / meta data
                setUpTDMSLibrary; % need this to edit the file
            end



            % check if any tasks are running
            for i = 1:length(obj.task)
                if ~obj.task(i).isTaskDone()
                    error('task %s is running already, can''t start',obj.task(i).name)
                end
                startOrders(i) = obj.task(i).startOrder;
            end

            if numel(unique(startOrders)) ~= length(startOrders)
                error('The tasks need to all have unique start order numbers')
            end
            [~,startInds] = sort(startOrders,'ascend');
            % make sure all tasks have a unique start order number

            for i = 1:length(obj.task)
                obj.task(startInds(i)).startTask();
            end




        end





        % function devices = getAvailableDevices(obj)
        %     bufferSize = 1024;  % Define an appropriate buffer size
        %
        %     % Call the function and capture the returned string
        %     [err, deviceNamesStr] = calllib(obj.lib, 'DAQmxGetSysDevNames', blanks(bufferSize), uint32(bufferSize));
        %
        %     % Check for errors
        %     handleDAQmxError(obj.lib, err);
        %
        %     % Trim and split the device names by commas
        %     devices = strsplit(strtrim(deviceNamesStr), ',');
        % end

        % function channels = getDeviceAIPhysicalChans(obj, device)
        %     bufferSize = 2048;
        %
        %     % Call the function, passing the pointer to the string buffer
        %      [err, ~,channelNamesStr] = calllib(obj.lib, 'DAQmxGetDevAIPhysicalChans', device, blanks(bufferSize), uint32(bufferSize));
        %
        %      % Check for errors
        %      handleDAQmxError(obj.lib, err);
        %
        %     % Trim and split the channel names by commas
        %     channels = strsplit(strtrim(channelNamesStr), ',');
        % end
    end

    methods (Access = private)

        function groupHandlesOut = getTDMSGroupHandles(obj,fileHandle)
            groupNames = {obj.task.taskName};

            % Step 1: Get the number of channel groups
            numGroupsPtr = libpointer('uint32Ptr', 0);
            err = calllib('tdmlib', 'DDC_GetNumChannelGroups', fileHandle, numGroupsPtr);
            numGroups = numGroupsPtr.Value;

            if err ~= 0
                error('Error getting number of channel groups: %d', err);
            end

            % Step 2: Get the channel group handles
            groupHandles = libpointer('int64Ptr', zeros(1, numGroups, 'int64'));
            err = calllib('tdmlib', 'DDC_GetChannelGroups', fileHandle, groupHandles, uint64(numGroups));

            if err ~= 0
                error('Error getting channel group handles: %d', err);
            end

            % Step 3: Get the names of all channel groups at once
            allGroupNames = cell(1, numGroups);
            for i = 1:numGroups
                groupHandle = groupHandles.Value(i);

                % Get the length of the group name
                nameLengthPtr = libpointer('uint32Ptr', 0);
                err = calllib('tdmlib', 'DDC_GetChannelGroupStringPropertyLength', groupHandle, 'name', nameLengthPtr);
                nameLength = nameLengthPtr.Value + 1; % Account for null-terminator

                if err ~= 0
                    error('Error getting group name length: %d', err);
                end

                % Get the group name

                [err, ~, groupNameStr] = calllib('tdmlib', 'DDC_GetChannelGroupPropertyString', groupHandle, 'name', blanks(nameLength), uint64(nameLength));

                if err ~= 0
                    error('Error getting group name: %d', err);
                end

                % Store the name in the cell array
                allGroupNames{i} = strtrim(groupNameStr);
            end

            % Step 4: Find the matching group handles for the provided group names
            groupHandlesOut = cell(1, numGroups);
            for k = 1:length(groupNames)
                idx = find(strcmp(allGroupNames, groupNames{k}));
                if ~isempty(idx)
                    groupHandlesOut{k} = groupHandles.Value(idx);
                else
                    warning('Group "%s" not found in file.', groupNames{k});
                end
            end
        end

    end
end

