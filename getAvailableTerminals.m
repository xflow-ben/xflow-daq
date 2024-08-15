function terminals = getAvailableTerminals(lib, deviceName)
    bufferSize = 2048*5;
    % terminalNames = libpointer('cstring', blanks(bufferSize));
    
    % Retrieve the list of available terminals
    [err,~,terminalNames] = calllib(lib, 'DAQmxGetDevTerminals', deviceName, blanks(bufferSize), uint32(bufferSize));
    handleDAQmxError(lib, err);
    
    % Split the terminal names by commas
    terminals = strsplit(strtrim(terminalNames), ',');
end


