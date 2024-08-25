function changeIdleState(lib, taskHandle, channelName, idleState)
    % Change the idle state of the counter output channel
    err = calllib(lib, 'DAQmxSetCOPulseIdleState', taskHandle, channelName, int32(idleState));
    handleDAQmxError(lib, err);
    
    fprintf('Idle state of %s set to %d.\n', channelName, idleState);
end
