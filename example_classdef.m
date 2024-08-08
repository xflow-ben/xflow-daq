classdef MyDAQ
    properties
        lib = 'myni';  % library alias
        dllPath = 'C:\Windows\System32\nicaiu.dll';
        headerPath = 'C:\Program Files (x86)\National Instruments\NI-DAQ\DAQmx ANSI C Dev\include\NIDAQmx.h';
    end
    
    methods
        function obj = MyDAQ()
            % Constructor: Load the library
            if ~libisloaded(obj.lib)
                loadlibrary(obj.dllPath, obj.headerPath, 'alias', obj.lib);
            end
        end
        
        function delete(obj)
            % Destructor: Unload the library
            if libisloaded(obj.lib)
                unloadlibrary(obj.lib);
            end
        end
        
        function startTask(obj, taskHandle)
            % Example method to start a task
            calllib(obj.lib, 'DAQmxStartTask', taskHandle);
        end
        
        function stopTask(obj, taskHandle)
            % Example method to stop a task
            calllib(obj.lib, 'DAQmxStopTask', taskHandle);
        end
        
        function readAnalog(obj, taskHandle, numSampsPerChan, timeout, readArray, arraySizeInSamps, sampsPerChanRead)
            % Example method to read analog data
            calllib(obj.lib, 'DAQmxReadAnalogF64', taskHandle, numSampsPerChan, timeout, readArray, arraySizeInSamps, sampsPerChanRead, []);
        end
        
        % Add more methods as needed to interface with the functions you require
    end
end