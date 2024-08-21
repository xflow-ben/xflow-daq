classdef xfedaq < sharedFunctions
    % s = xfedaq creates a new task group (i.e. session). A session
    % contains a group of tasks that will be sampled at the same rate
    % (similar to d = daq('ni')) Currently, the first task added must be an
    % analog input, as that is the sample clock we use. This could be made
    % more flexible later
    %




    
% Highest level of object represents task group that will be sampled
% together - OR highest level is groups of task groups that will be started
% together (but have different rates)

% NOTE - we could remove "Collection" and just have the Groups be set up
% with the proper triggering. Could make object class structure simpler.

% Collection - a number of task groups that will be started/stopped
% together (share start trigger signal). 
%  METHODS
%      - set start trigger. Set from external, or set all to start with
%      master
%      - Start. Starts all task groups together. Records time of start
%      - Get data. Called in a loop

% Group - a grouping of tasks that will all run at the same rate and use
% the same acquisition clock
%  METHODS
%      - Need way to get sample clock of the master and pass it to the
%      other tasks in the group


% Task - a collection of channels from a single module with the same
% settings (I think)
%  METHODS
%     - Get data. Get data from this task
%     - Create/add channel. I beleive channels must be on the same chassis,
%     and MAYBE on the same module, but could be that can they can be on
%     different modules of the same type. 

% Functions to create analog, RTD, counter chans
% functions to get and apply, or set the sample clock and rate
% function to start and stop the entire group
% functions to iterate through and get all the available data from the
% tasks/channels, and return it. This would get called in a while loop from
% some external function

    properties
        lib = 'myni';  % Library alias
        dllPath = 'C:\Windows\System32\nicaiu.dll';
        headerPath = 'C:\Program Files (x86)\National Instruments\NI-DAQ\DAQmx ANSI C Dev\include\NIDAQmx.h';
        rate = 0.0; % acquisition rate of this task group
        bufferSize = 0; % Buffer size (on pc) per channel for
        acquisitionType = ''; % 'finite' or 'continuous' - could leave this out for now
        startTrigger = struct; % properties pertaining to how this task group starts
        startTime = [datetime,datetime];
        numChans = 0;
        % startTrigger.source = 'software', 'userDefined'
        % startTrigger.terminal = start trigger used for all tasks in this
        % xfedaq instance
        % startTrigger.exportTerminal = where to export the start trigger
        % to, if needed
        sampleClock = struct; % properties pertaining to the sample clock
        % sampleClock.source = 'auto', 'userDefined'
        % sampleClock.terminal = sample clock used by all tasks in this
        % xfedaq instance
        % sampleClock.exportTerminal = where to export the terminal, if
        % needed
        % sampleClock.rate = Acquisition rate
        tasks = task.empty;  % List of task objects
        isFinalized = 0;

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
                 if isempty(dir(obj.dllPath))
                        error('dll file not found at %s',obj.dllPath);
                 end
                 if isempty(dir(obj.headerPath))
                        error('dll file not found at %s',obj.dllPath);
                 end
                warning off MATLAB:loadlibrary:TypeNotFound
                warning off MATLAB:loadlibrary:TypeNotFoundForStructure
                loadlibrary(obj.dllPath, obj.headerPath, 'alias', obj.lib);
            end
            % default options
            obj.acquisitionType = 'continuous';
            obj.startTrigger.source = 'software'; % options are 'software' and 'userDefined'
            obj.startTrigger.terminal = '';
            obj.startTrigger.exportTerminal = '';
            obj.sampleClock.source = 'auto';
            obj.sampleClock.terminal = '';
            obj.sampleClock.exportTerminal = '';
            obj.rate = 1000;
            obj.bufferSize = 2000;
        end

        function checkIfConfigured(obj)
            % Check if the user has set up all required parameters before
            if obj.rate == 0.0
                error('obj.rate Rate must first be set');
            end
            if obj.bufferSize == 0
                error('obj.bufferSize must first be set');
            end
            if isempty(obj.acquisitionType)
                error('obj.acquisitionType must first be set');
            end

        end

        function start(obj)
            % start the task group, or prepare it to start before a master
            % task group or harware trigger
            if ~obj.isFinalized
                error('call obj.finalizeSetup before starting')
            end

            % Start the slave tasks
            for i = 2:length(obj.tasks)
                obj.tasks(i).startTask();
            end

            obj.startTime(1) = datetime("now");
            obj.tasks(1).startTask();
            obj.startTime(2) = datetime("now");

        end

         function stop(obj)
            % Stop the task group
        end

        function data = getData(obj)
            % gets the data available in the task buffers, if any


        end
        
        function delete(obj)
            % Destructor: Unload the library and clear tasks
            for i = 1:numel(obj.tasks)
                delete(obj.tasks(i));  % Ensure all tasks are properly deleted
            end
            
            if libisloaded(obj.lib)
                unloadlibrary(obj.lib);
            end
        end
        
        function taskObj = createTask(obj, taskName)
            % Create a new task object and add it to the tasks list
            taskObj = task(taskName, obj.lib);
            obj.tasks(end+1) = taskObj;
        end

        function addAIVoltageChan(obj,physicalChannel,terminalConfig,inputRange)
             checkIfConfigured(obj);
             % check for existing task AIVoltage task, make it if needed
             % if it already exists, could be good to check if it is on the
             % same device (cDAQ chassis, USB daq, PCIe-daq, etc.)
             terminalConfigInt = obj.getConstInputVal('terminalConfig',terminalConfig,{'RSE','Diff','NRSE'},[obj.DAQmx.Val_RSE,obj.DAQmx.Val_Diff,obj.DAQmx.Val_NRSE]);

             taskIndex = getTaskIndex(obj,'AIVoltage');
             if taskIndex == -1
                 obj.tasks(1) = createTask(obj,'AIVoltage');
                 taskIndex = 1;
             end
             obj.tasks(taskIndex).createChannel('AIVoltage', physicalChannel, terminalConfigInt, inputRange(1),inputRange(2));
        end

        function addCICountEdgesChan(obj,counterChannel,edgeDirection,countDirection)
            checkIfConfigured(obj);
            edgeDirectionInt = obj.getConstInputVal('edgeDirection',edgeDirection,{'rising','falling'},[obj.DAQmx.Val_Rising,obj.DAQmx.Val_Falling]);
            countDirectionInt = obj.getConstInputVal('countDirection',countDirection,{'up','down','external'},[obj.DAQmx.Val_CountUp, obj.DAQmx.Val_CountDown, obj.DAQmx.Val_ExtControlled]);
            taskIndex = getTaskIndex(obj,'CICountEdges');
            if taskIndex == -1
                taskHandle = createTask(obj,'CICountEdges');
            else
                taskHandle = obj.tasks(taskIndex);
            end
            taskHandle.createChannel('CICountEdges', counterChannel, edgeDirectionInt,int32(0),countDirectionInt);

        end

        function addAIBridgeChan(obj,physicalChannel,units,inputRange,bridgeConfig,voltageExcitSource,voltageExcitVal,nominalBridgeResistance)
            checkIfConfigured(obj);
            unitsInt = obj.getConstInputVal('units',units,{'Volts per Volt','mV per Volt'},[obj.DAQmx.Val_VoltsPerVolt,obj.DAQmx.Val_mVoltsPerVolt]);
            bridgeConfigInt = obj.getConstInputVal('bridgeConfig',bridgeConfig,{'full','half','quarter'},[obj.DAQmx.Val_FullBridge,obj.DAQmx.Val_HalfBridge,obj.DAQmx.Val_QuarterBridge]);
            voltageExcitSourceInt = obj.getConstInputVal('voltageExcitSource',voltageExcitSource,{'internal','external','none'},[obj.DAQmx.Val_Internal,obj.DAQmx.Val_External,obj.DAQmx.Val_None]);
      
            taskIndex = getTaskIndex(obj,'AIBridge');
            if taskIndex == -1
                taskHandle = createTask(obj,'AIBridge');
            else
                taskHandle = obj.tasks(taskIndex);
            end
            taskHandle.createChannel('AIBridge', physicalChannel, inputRange(1),inputRange(2),unitsInt,bridgeConfigInt,voltageExcitSourceInt,voltageExcitVal,nominalBridgeResistance);
        end


        function addAIResistanceChan(obj,physicalChannel,inputRange,resistanceConfig,currentExcitSource,currentExcitVal)
             checkIfConfigured(obj);
             % check for existing task AIVoltage task, make it if needed
             % if it already exists, could be good to check if it is on the
             % same device (cDAQ chassis, USB daq, PCIe-daq, etc.)
             resistanceConfigInt = obj.getConstInputVal('resistanceConfig',resistanceConfig,{'2 wire','3 wire','4 wire'},[obj.DAQmx.Val_2Wire,obj.DAQmx.Val_3Wire,obj.DAQmx.Val_4Wire]);
             currentExcitSourceInt = obj.getConstInputVal('currentExcitSource',currentExcitSource,{'internal','external','none'},[obj.DAQmx.Val_Internal,obj.DAQmx.Val_External,obj.DAQmx.Val_None]);

             taskIndex = getTaskIndex(obj,'AIResistance');
             if taskIndex == -1
                 taskHandle = createTask(obj,'AIResistance');
             else
                 taskHandle = obj.tasks(taskIndex);
             end
             taskHandle.createChannel('AIResistance', physicalChannel, inputRange(1),inputRange(2), resistanceConfigInt,currentExcitSourceInt,currentExcitVal);

        end

        function index = getTaskIndex(obj,taskName)

            if isempty(obj.tasks)
                index = -1;
            else
                names = {obj.tasks.taskName};
                index = find(ismember(names,taskName));
                if numel(index)>1
                    error('We ended up with more than one task of the same type somehow')
                elseif isempty(index)
                    index = -1;
                end
            end
        end
           
        function finalizeSetup(obj)
            
            if isempty(obj.tasks)
                error('You gotta add some channels before calling this')
            end
            if ~strcmp(obj.tasks(1).taskName(1:2),'AI')
                error('This system needs the first task to be some sort of analog input');
            end
            
            % config the first channel sample clock
            obj.tasks(1).configSampleClock(obj.sampleClock.terminal,obj.rate,obj.acquisitionType,obj.bufferSize);
            
            if strcmp(obj.startTrigger.source,'userDefined')
                obj.tasks(1).setStartTrigTerm(obj.startTigger.terminal)
            end
            
            % get the first task ready enough that the sample clock and
            % trigger gets set in the DAQ
            obj.tasks(1).setTaskState('verify');
            obj.tasks(1).setTaskState('reserve');

            %% CHECK THE SAMPLE CLOCK
            
            % get the sample clock and start terminal of the trigger of
            % first task
            rate_actual = obj.tasks(1).getSampClkRate();
            if round(rate_actual) ~= round(obj.rate)
                warning('Sample rate has been force modified by the DAQ to %.0f, buffer will be set to 2x this',rate_actual);
                obj.tasks(1).setTaskState('unreserve');
                obj.bufferSize = round(rate_actual*2);
                obj.rate = rate_actual;
                obj.tasks(1).configSampleClock(obj.sampleClock.terminal,obj.rate,obj.acquisitionType,obj.bufferSize);
                obj.tasks(1).setTaskState('verify');
                obj.tasks(1).setTaskState('reserve');
            end

            sampleClockString = obj.tasks(1).getSampleClockTerm();
            if strcmp(obj.sampleClock.source,'userDefined')
                if ~strcmp(sampleClockString,obj.sampleClock.terminal)
                    error('Tried to set sample clock to %s, but it was set to %s',obj.sampleClock.terminal,sampleClockString)
                end
            end
            obj.sampleClock.terminal = sampleClockString;

            startTrigTermString = obj.tasks(1).getStartTrigTerm();
            if strcmp(obj.startTrigger.source,'userDefined')
                if ~strcmp(startTrigTermString,obj.startTrigger.terminal)
                    error('Tried to set start trigger terimal to %s, but it was set to %s',obj.startTrigger.terminal,startTrigTermString)
                end
            end
            obj.startTrigger.terminal = startTrigTermString;

            obj.tasks(1).setTaskState('commit');
            obj.numChans = obj.tasks(1).numChans;
            % Now we can set up the rest of the tasks
            for i = 2:length(obj.tasks)
                obj.tasks(i).configSampleClock(obj.sampleClock.terminal,obj.rate,obj.acquisitionType,obj.bufferSize);
                % obj.tasks(i).setStartTrigTerm(obj.startTrigger.terminal);
                obj.tasks(i).setTaskState('verify');
                obj.tasks(i).setTaskState('reserve');
                obj.tasks(i).setTaskState('commit');
                obj.numChans = obj.numChans + obj.tasks(i).numChans;
            end
            % fprintf('Daq object is ready to star\n')
            
            obj.isFinalized = 1;


        end

        function routeSignal(obj,sourceTerminal,destinationTerminal)
            err = calllib(obj.lib, 'DAQmxConnectTerms', sourceTerminal, destinationTerminal,obj.DAQmx.Val_DoNotInvertPolarity);
            obj.handleDAQmxError(obj.lib, err);
        end
        
        function data = readData(obj,samplesToRead,timeOut)
            data = zeros([samplesToRead,obj.numChans]);
            col = 1;
            for i = 1:length(obj.tasks)
                data(:,col:col+obj.tasks(i).numChans-1) = obj.tasks(i).readData(samplesToRead,timeOut);
                col = col + obj.tasks(i).numChans;
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
end

