% Initialize task handles
d = xfedaq();
taskHandle1 = libpointer('uint32Ptr', 0);
taskHandle2 = libpointer('uint32Ptr', 0);


% Manually route Task 1 start trigger to te0 start trigger
err = calllib('myni', 'DAQmxConnectTerms', '/cDAQ9188-18F21FF/ai/StartTrigger', '/cDAQ9188-18F21FF/PFI0', d.DAQmx.Val_DoNotInvertPolarity);
if err ~= 0
    disp('Error routing Task 1 trigger to PFI0');
    return;
end


% Create Task 1 (Master Task)
err = calllib('myni', 'DAQmxCreateTask', '', taskHandle1);
if err ~= 0
    disp('Error creating Task 1');
    return;
end



err = calllib('myni', 'DAQmxCreateAIBridgeChan', taskHandle1, 'cDAQ9188-18F21FFMod5/ai0', '', -0.025, 0.025, d.DAQmx.Val_VoltsPerVolt,d.DAQmx.Val_FullBridge,d.DAQmx.Val_Internal,10.0,360.0,'');
if err ~= 0
    disp('Error configuring AI channel for Task 1');
    return;
end

% Configure the sample clock for Task 1
err = calllib('myni', 'DAQmxCfgSampClkTiming', taskHandle1, '', 1000.0, 10280, 10178, 1000);
if err ~= 0
    disp('Error configuring sample clock for Task 1');
    return;
end

% Manually commit Task 1
err = calllib('myni', 'DAQmxTaskControl', taskHandle1, d.DAQmx.Val_Task_Commit); % DAQmx_Val_Task_Commit = 3
if err ~= 0
    disp('Error committing Task 1');
    return;
end

% Create Task 2 (Slave Task)
err = calllib('myni', 'DAQmxCreateTask', '', taskHandle2);
if err ~= 0
    disp('Error creating Task 2');
    return;
end

% Configure an analog input channel for Task 2
err = calllib('myni', 'DAQmxCreateAIVoltageChan', taskHandle2, 'cDAQ9188-18F21FFMod6/ai0', '',d.DAQmx.Val_RSE, -10.0, 10.0, d.DAQmx.Val_Volts, []);
if err ~= 0
    disp('Error configuring AI channel for Task 2');
    return;
end


% Configure the sample clock for Task 2
err = calllib('myni', 'DAQmxCfgSampClkTiming', taskHandle2, '', 100.0,d.DAQmx.Val_Rising, uint32(10178), uint64(1000));
if err ~= 0
    disp('Error configuring sample clock for Task 2');
    return;
end

% Set the start trigger for Task 2 to listen to the start trigger from Task
% 1 through PFI0
err = calllib('myni', 'DAQmxCfgDigEdgeStartTrig', taskHandle2, '/cDAQ9188-18F21FF/PFI0', d.DAQmx.Val_Rising); % 10280 = DAQmx_Val_Rising
if err ~= 0
    disp('Error configuring start trigger for Task 2');
    return;
end

% Manually commit Task 2
err = calllib('myni', 'DAQmxTaskControl', taskHandle2, d.DAQmx.Val_Task_Commit); % DAQmx_Val_Task_Commit = 3
if err ~= 0
    disp('Error committing Task 2');
    return;
end

% check for what the start trigger is set to
strBufferSize = 255;
[err,~,startTrigTermString] = calllib('myni','DAQmxGetStartTrigTerm',taskHandle2,blanks(strBufferSize),uint32(strBufferSize));

% Start Task 2 (Slave Task) - It will wait for the trigger
err = calllib('myni', 'DAQmxStartTask', taskHandle2);
if err ~= 0
    disp('Error starting Task 2');
    return;
end

% Start Task 1 (Master Task) - This will generate the trigger
err = calllib('myni', 'DAQmxStartTask', taskHandle1);
if err ~= 0
    disp('Error starting Task 1');
    return;
end

% Cleanup
calllib('myni', 'DAQmxStopTask', taskHandle1);
calllib('myni', 'DAQmxClearTask', taskHandle1);

calllib('myni', 'DAQmxStopTask', taskHandle2);
calllib('myni', 'DAQmxClearTask', taskHandle2);
