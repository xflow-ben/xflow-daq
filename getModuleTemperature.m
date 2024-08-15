function temperature = getModuleTemperature(lib, deviceName)
    % Create a pointer to store the temperature value
    temperaturePtr = libpointer('doublePtr', 0);
    tic;
    % Call the DAQmx function to get the internal temperature
    err = calllib(lib, 'DAQmxGetCalDevTemp', deviceName, temperaturePtr);
    toc
    % Check for errors
    if err ~= 0
        % If an error occurs, retrieve the error message
        bufferSize = 2048;
        errorMsg = libpointer('cstring', blanks(bufferSize));
        calllib(lib, 'DAQmxGetErrorString', err, errorMsg, uint32(bufferSize));
        error('DAQmx Error: %s', errorMsg.Value);
    end
    
    % Retrieve the temperature value
    temperature = temperaturePtr.Value;
end

