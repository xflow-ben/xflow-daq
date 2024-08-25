function setCounterOutputTerminal(lib, taskHandle, channelName, terminalName)
    % Set the terminal for the counter output channel
    err = calllib(lib, 'DAQmxSetCOPulseTerm', taskHandle, channelName, terminalName);
    handleDAQmxError(lib, err);
    
    fprintf('Counter output on %s routed to terminal %s.\n', channelName, terminalName);
end