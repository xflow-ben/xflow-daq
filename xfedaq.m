classdef xfedaq < daqmx_header_consts

    
    properties
        lib = 'myni';  % Library alias
        dllPath = 'C:\Windows\System32\nicaiu.dll';
        headerPath = 'C:\Program Files (x86)\National Instruments\NI-DAQ\DAQmx ANSI C Dev\include\NIDAQmx.h';
        tasks;  % List of task objects
        availableDevices;  % List of available devices
        availableChannels; % Map of device to available channels
    end
    
    methods
        function obj = xfedaq()
            % Constructor: Load the library and retrieve device/channel info
            if ~libisloaded(obj.lib)
                loadlibrary(obj.dllPath, obj.headerPath, 'alias', obj.lib);
            end
            obj.tasks = {};
            
            % Retrieve and store available devices and their channels
            obj.availableDevices = obj.getAvailableDevices();
        end
        
        function delete(obj)
            % Destructor: Unload the library and clear tasks
            for i = 1:numel(obj.tasks)
                delete(obj.tasks{i});  % Ensure all tasks are properly deleted
            end
            
            if libisloaded(obj.lib)
                unloadlibrary(obj.lib);
            end
        end
        
        function taskObj = createTask(obj, taskName)
            % Create a new task object and add it to the tasks list
            taskObj = task(taskName, obj.lib, obj.availableChannels);
            obj.tasks{end+1} = taskObj;
        end
        
        function devices = getAvailableDevices(obj)
            bufferSize = 1024;  % Define an appropriate buffer size

            % Call the function and capture the returned string
            [err, deviceNamesStr] = calllib(obj.lib, 'DAQmxGetSysDevNames', blanks(bufferSize), uint32(bufferSize));

            % Check for errors
            handleDAQmxError(obj.lib, err);

            % Trim and split the device names by commas
            devices = strsplit(strtrim(deviceNamesStr), ',');
        end
        
        function channels = getDeviceAIPhysicalChans(obj, device)
            bufferSize = 2048;

            % Call the function, passing the pointer to the string buffer
             [err, ~,channelNamesStr] = calllib(obj.lib, 'DAQmxGetDevAIPhysicalChans', device, blanks(bufferSize), uint32(bufferSize));
            
             % Check for errors
             handleDAQmxError(obj.lib, err);

            % Trim and split the channel names by commas
            channels = strsplit(strtrim(channelNamesStr), ',');
        end
    end
end


% classdef xfedaq < daqmx_header_consts
%     properties
%         lib = 'myni';  % Library alias
%         dllPath = 'C:\Windows\System32\nicaiu.dll';
%         headerPath = 'C:\Program Files (x86)\National Instruments\NI-DAQ\DAQmx ANSI C Dev\include\NIDAQmx.h';
%         tasks;  % List of task objects
%     end
% 
%     methods
%         function obj = xfedaq()
%             % Constructor: Load the library
%             if ~libisloaded(obj.lib)
%                 loadlibrary(obj.dllPath, obj.headerPath, 'alias', obj.lib);
%             end
%             obj.tasks = {};
%         end
% 
%         function delete(obj)
%             % Destructor: Clear tasks and unload the library
%             for i = 1:numel(obj.tasks)
%                 delete(obj.tasks{i});  % Ensure all tasks are properly deleted
%             end
% 
%             if libisloaded(obj.lib)
%                 unloadlibrary(obj.lib);
%             end
%         end
% 
%         function taskObj = createTask(obj, taskName)
%             % Create a new task object and add it to the tasks list
%             taskObj = task(taskName, obj.lib);
%             obj.tasks{end+1} = taskObj;
%         end
% 
%         function taskObj = getTask(obj, index)
%             % Retrieve a task object by index
%             if index > 0 && index <= numel(obj.tasks)
%                 taskObj = obj.tasks{index};
%             else
%                 error('Task index out of range.');
%             end
%         end
%     end
% end
% 
% 
% % classdef xfedaq < daqmx_header_consts
% %     properties
% %         lib = 'myni';  % Library alias
% %         dllPath = 'C:\Windows\System32\nicaiu.dll';
% %         headerPath = 'C:\Program Files (x86)\National Instruments\NI-DAQ\DAQmx ANSI C Dev\include\NIDAQmx.h';
% %         tasks;  % List of task objects
% %     end
% % 
% %     methods
% %         function obj = xfedaq()
% %             % Constructor: Load the library
% %             if ~libisloaded(obj.lib)
% %                 loadlibrary(obj.dllPath, obj.headerPath, 'alias', obj.lib);
% %             end
% %             obj.tasks = {};
% %         end
% % 
% %         function delete(obj)
% %             % Destructor: Unload the library and clear tasks
% %             if libisloaded(obj.lib)
% %                 unloadlibrary(obj.lib);
% %             end
% %         end
% % 
% %         function taskObj = createTask(obj, taskName)
% %             % Create a new task object and add it to the tasks list
% %             taskObj = task(taskName, obj.lib);
% %             obj.tasks{end+1} = taskObj;
% %         end
% % 
% %         function taskObj = getTask(obj, index)
% %             % Retrieve a task object by index
% %             if index > 0 && index <= numel(obj.tasks)
% %                 taskObj = obj.tasks{index};
% %             else
% %                 error('Task index out of range.');
% %             end
% %         end
% %     end
% % end