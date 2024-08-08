lib = 'myni';	% library alias

dll_path = 'C:\Windows\System32\nicaiu.dll';

header_path = 'C:\Program Files (x86)\National Instruments\NI-DAQ\DAQmx ANSI C Dev\include\NIDAQmx.h';

funclist = loadlibrary(dll_path,header_path,'alias',lib);

taskHandle = libpointer('int32Ptr', 0);
calllib(lib, 'DAQmxCreateTask', '', taskHandle);
taskHandleValue = get(taskHandle, 'Value');


% Add an Analog Input Channel
channelName = 'Dev1/ai0'; % Change according to your hardware
calllib(lib, 'DAQmxCreateAIVoltageChan', taskHandleValue, channelName, '', -10.0, 10.0, 10348, []);


% Configure Timing
calllib(lib, 'DAQmxCfgSampClkTiming', taskHandleValue, '', 1000, 10280, 10178, 0); % Adjust clock source, rate, etc.




% Define the number of samples to read in one go
numSamples = 1000; % Number of samples to wait for

% Set up a loop to continuously acquire data
while true
    % Check the number of available samples
    availableSamples = libpointer('int32Ptr', 0);
    calllib(lib, 'DAQmxGetReadAvailSampPerChan', taskHandleValue, availableSamples);

    % Check if the number of available samples meets or exceeds the threshold
    if get(availableSamples, 'Value') >= numSamples
        % Allocate memory for the data
        data = zeros(1, numSamples);
        readArray = libpointer('doublePtr', data);
        
        % Read data from the buffer
        [status, readArray, samplesRead] = calllib(lib, 'DAQmxReadAnalogF64', taskHandleValue, numSamples, 10, 0, readArray, numSamples, libpointer('int32Ptr', 0), libpointer('int32Ptr', 0));
        
        % Check for errors
        if status ~= 0
            error('DAQmx Error: %s', calllib(lib, 'DAQmxGetErrorString', status));
        end
        
        % Process or handle the data
        disp('Processing Data:');
        disp(readArray.Value);
        
        % Exit the loop if you only want to acquire data once
        break;
    end

    % Pause briefly to avoid busy-waiting
    pause(0.1);
end