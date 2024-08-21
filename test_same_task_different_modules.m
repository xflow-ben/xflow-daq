% A better solution is to query the AI task for its sample clock terminal
% and route the result of that query over to the 'source' input of DAQmx
% Timing for your edge counting task.  You probably will also need to first
% call DAQmx Control for your AI task to either reserve or commit it before
% doing the query.   See this thread for more info.
rate = 10000;  % Sample rate in Hz
nSamples = rate * 5;  % Number of samples for 5 seconds

d = xfedaq();

% Create and configure the analog input task (AnalogTask)
analogTask = d.createTask('AnalogTask');
analogTask.createChannel('AnalogInputVoltage', 'cDAQ1Mod2/ai0', 'AnalogChan', d.DAQmx_Val_DIFF, -5.0, 5.0, d.DAQmx_Val_Volts);
analogTask.createChannel('AnalogInputVoltage', 'cDAQ1Mod4/ai0', 'AnalogChan2', d.DAQmx_Val_RSE, -10.0, 10.0, d.DAQmx_Val_Volts);
% Configure the analog task for finite sampling using the internal ai/SampleClock
err = calllib('myni', 'DAQmxCfgSampClkTiming', analogTask.taskHandle, '', rate, d.DAQmx_Val_Rising, d.DAQmx_Val_FiniteSamps, uint64(nSamples));
handleDAQmxError('DAQmxCfgSampClkTiming (Analog)', err);
% start then stop the task. Otherwise for some reason the te0 sample clock
% won't run

analogTask.startTask();
pause(1);
analogTask.stopTask();
