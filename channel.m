classdef channel < sharedFunctions
    properties
        channelType;      % Type of the channel (e.g., AI, AO, DI, DO)
        physicalChannel;  % Physical channel string (e.g., 'Dev1/ai0')
        channelName;      % Name of the channel
        lib;              % Library alias
        taskHandle;       % Handle to the parent task
    end
    
    methods
    end
end

