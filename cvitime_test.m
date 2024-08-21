% Define a structure to match CVIAbsoluteTime in C
cviTimeStruct = struct('cviTime', 0);

% Create a pointer to this structure
timestampPtr = libpointer('doublePtr', 0);

% Call the function
err = calllib('myni', 'DAQmxGetStartTrigTimestampVal', analogTask.taskHandle, timestampPtr);

% Error handling
if err ~= 0
    bufferSize = 2048;
    errorMsg = libpointer('cstring', blanks(bufferSize));
    calllib('myni', 'DAQmxGetErrorString', err, errorMsg, uint32(bufferSize));
    error('DAQmx Error: %s', errorMsg.Value);
else
    % Access the timestamp value
    cviTimeValue = timestampPtr.Value;
    
    % Convert the cviTimeValue to a more readable format
    timestampDatetime = datetime(1904, 1, 1, 0, 0, 0) + seconds(cviTimeValue);
    fprintf('Start Trigger Timestamp: %s\n', datestr(timestampDatetime));
end