
rate1 = 1000;  % Sample rate in Hz
rate2 = 800;
nSamples1 = rate1 * 2;  % Number of samples for 5 seconds
nSamples2 = rate2 * 2;  % Number of samples for 5 seconds

d = xfedaq();

% Create and configure the analog input task (AnalogTask)
analogTask = d.createTask('AnalogTask');
analogTask.createChannel('AnalogInputVoltage', 'cDAQ9188-18F21FFMod6/ai0', 'AnalogChan', d.DAQmx_Val_RSE, -10.0, 10.0, d.DAQmx_Val_Volts);


err = calllib('myni', 'DAQmxCfgSampClkTiming', analogTask.taskHandle, '', rate1, d.DAQmx_Val_Rising, d.DAQmx_Val_FiniteSamps, uint64(nSamples1));
handleDAQmxError('myni', err);

analogTask2 = d.createTask('AnalogTask2');
analogTask2.createChannel('AnalogInputVoltage', 'cDAQ9188-18F21FFMod6/ai3', 'AnalogChan2', d.DAQmx_Val_RSE, -5.0, 5.0, d.DAQmx_Val_Volts);

% Configure the analog task for finite sampling using the internal ai/SampleClock
err = calllib('myni', 'DAQmxCfgSampClkTiming', analogTask2.taskHandle, '', rate2, d.DAQmx_Val_Rising, d.DAQmx_Val_FiniteSamps, uint64(nSamples2));
handleDAQmxError('myni', err);

triggerSourcePtr = libpointer('cstring', blanks(256));
err = calllib('myni', 'DAQmxGetStartTrigSrc', analogTask.taskHandle, triggerSourcePtr, uint32(256));


% TO DO 

% For internally synced, need to get the start trigger of the master task,
% then assign it to the everything else that needs to start with that

% DAQmxGetStartTrigType:
% 
% Retrieves the type of start trigger configured for the task.
% DAQmxGetStartTrigSrc:
% 
% Retrieves the source of the start trigger (e.g., PFI line, internal signal).
% DAQmxGetStartTrigDelayUnits:
% 
% Retrieves the units for the start trigger delay.
% DAQmxGetStartTrigDelay:
% 
% Retrieves the delay between the trigger and the start of the acquisition.



analogTask.startTask();
pause(1);
analogTask.stopTask();


% Create and configure the counter task (CounterTask)
counterTask = d.createTask('CounterTask');
err = calllib('myni', 'DAQmxCreateCICountEdgesChan', counterTask.taskHandle, 'cDAQ9188-18F21FFMod2/ctr0', '', d.DAQmx_Val_Rising, int32(0), d.DAQmx_Val_CountUp);
handleDAQmxError('DAQmxCreateCICountEdgesChan', err);



% Configure the counter task for finite sampling using the same sample clock
err = calllib('myni', 'DAQmxCfgSampClkTiming', counterTask.taskHandle, '/cDAQ9188-18F21FF/te0/SampleClock', rate, d.DAQmx_Val_Rising, d.DAQmx_Val_FiniteSamps, uint64(nSamples));
handleDAQmxError('DAQmxCfgSampClkTiming (Counter)', err);

% Start the counter task (slave) first
counterTask.startTask();


% Start the analog input task (master)
analogTask.startTask();


% Allocate space for data
analogData = zeros(nSamples*2, 1);
counterData = zeros(nSamples, 1);

% Create pointers to read data
readAnalogPtr = libpointer('doublePtr', analogData);
readCounterPtr = libpointer('uint32Ptr', counterData);
sampsPerChanPtr = libpointer('int32Ptr', int32(nSamples));

% Read data from the analog task
err = calllib('myni', 'DAQmxReadAnalogF64', analogTask.taskHandle, int32(-1), 10.0, d.DAQmx_Val_GroupByChannel, readAnalogPtr, uint32(nSamples), sampsPerChanPtr, []);
handleDAQmxError('myni', err);

% Read data from the counter task (optional, depending on your needs)
err = calllib('myni', 'DAQmxReadCounterU32', counterTask.taskHandle, int32(-1), 10.0, readCounterPtr, uint32(nSamples), sampsPerChanPtr,[]);
handleDAQmxError('myni', err);
