
% This works!

rate = 10000;  % Sample rate in Hz
nSamples = rate * 5;  % Number of samples for 5 seconds

d = xfedaq();

% Create and configure the analog input task (AnalogTask)
analogTask = d.createTask('AnalogTask');
analogTask.createChannel('AnalogInputVoltage', 'cDAQ9188-18F21FFMod1/ai0', 'AnalogChan', d.DAQmx_Val_RSE, -10.0, 10.0, d.DAQmx_Val_Volts);

% Create and configure the counter task (CounterTask)
counterTask = d.createTask('CounterTask');
err = calllib('myni', 'DAQmxCreateCICountEdgesChan', counterTask.taskHandle, 'cDAQ9188-18F21FFMod2/ctr0', '', d.DAQmx_Val_Rising, int32(0), d.DAQmx_Val_CountUp);
handleDAQmxError('DAQmxCreateCICountEdgesChan', err);

% Configure the analog task for finite sampling using the internal ai/SampleClock
err = calllib('myni', 'DAQmxCfgSampClkTiming', analogTask.taskHandle, '', rate, d.DAQmx_Val_Rising, d.DAQmx_Val_FiniteSamps, uint64(nSamples));
handleDAQmxError('DAQmxCfgSampClkTiming (Analog)', err);

% Configure the counter task for finite sampling using the same sample clock
err = calllib('myni', 'DAQmxCfgSampClkTiming', counterTask.taskHandle, '/cDAQ9188-18F21FF/ai/SampleClock', rate, d.DAQmx_Val_Rising, d.DAQmx_Val_FiniteSamps, uint64(nSamples));
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
