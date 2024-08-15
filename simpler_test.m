        dllPath = 'C:\Windows\System32\nicaiu.dll';    
       headerPath = 'C:\Program Files (x86)\National Instruments\NI-DAQ\DAQmx ANSI C Dev\include\NIDAQmx.h';
lib = 'myni';
    if ~libisloaded(lib)
        loadlibrary(dllPath, headerPath, 'alias', lib);
    end

    % Create a task handle
    taskHandle = libpointer('voidPtr', 0);
    err = calllib(lib, 'DAQmxCreateTask', '', taskHandle);
    handleDAQmxError(lib, err);

    % Call DAQmxCreateAIVoltageChan with hardcoded, minimal inputs
    err = calllib(lib, 'DAQmxCreateAIVoltageChan', taskHandle, ...
                  'cDAQ1Mod2/ai0', 'testChan', int32(10106), -10.0, 10.0, int32(10348), '');
    handleDAQmxError(lib, err);
    
    % Clear the task
    calllib(lib, 'DAQmxClearTask', taskHandle);
    fprintf('DAQmxCreateAIVoltageChan succeeded.\n');