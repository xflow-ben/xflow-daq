function handleDAQmxError(lib, err)
    if err ~= 0
        % Define a buffer for the error string
        bufferSize = 1024;
        
        % Call DAQmxGetErrorString to get the error message
        [~, errorString] = calllib(lib, 'DAQmxGetErrorString', ...
                                   err, blanks(bufferSize), uint32(bufferSize));
        
        % Remove any trailing null characters
        errorString = strtrim(errorString);
        
        % Throw an error with the message
        error('DAQmx Error: %s', errorString);
    end
end