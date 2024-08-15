% Create an instance of the xfedaq class
d = xfedaq();

% Create a new task
task1 = d.createTask('Task1');
% Create an analog input voltage channel
chan1 = task1.createChannel('AnalogInputVoltage', 'cDAQ9188-18F21FFMod1/ai0', 'testChan0',d.DAQmx_Val_Diff, -10.0, 10.0, d.DAQmx_Val_Volts);
chan2 = task1.createChannel('AnalogInputVoltage', 'cDAQ9188-18F21FFMod1/ai1', 'testChan1',d.DAQmx_Val_Diff, -10.0, 10.0, d.DAQmx_Val_Volts);
chan3 = task1.createChannel('AnalogInputVoltage', 'cDAQ9188-18F21FFMod1/ai2', 'testChan2',d.DAQmx_Val_Diff, -10.0, 10.0, d.DAQmx_Val_Volts);
chan4 = task1.createChannel('AnalogInputVoltage', 'cDAQ9188-18F21FFMod1/ai3', 'testChan3',d.DAQmx_Val_Diff, -10.0, 10.0, d.DAQmx_Val_Volts);
% Modify the channel properties
% chan1.setChannelProperty('Min', -5.0);
% chan1.setChannelProperty('Max', 5.0);

% Start the task
task1.startTask();

% Read data (example usage)
numSampsPerChan = 100;
timeout = 10.0;
readArray = zeros(1, 4*numSampsPerChan);
arraySizeInSamps = 4*numSampsPerChan;
sampsPerChanRead = libpointer('int32Ptr', 0);
data = task1.readAnalog(numSampsPerChan, timeout, arraySizeInSamps);

% Stop the task
task1.stopTask();