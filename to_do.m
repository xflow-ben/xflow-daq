% Determine timing approach% read/calculate timestamps
% function to get data from running task
% linking clocks of tasks
% make sure PC buffer is large enough to not run into trouble
% continuous vs finite acquisition

%% PFI output example, for use as a digital IO
% trying to create a counter, but only switching the idle state
taskHandle = libpointer('voidPtr', 0);
err = calllib('myni', 'DAQmxCreateTask', '', taskHandle);
handleDAQmxError('myni', err);
err = calllib('myni', 'DAQmxCreateCOPulseChanTicks', taskHandle, 'cDAQ9188-18F21FF/ctr0', '','/cDAQ9188-18F21FF/20MHzTimebase',uint32(10214),uint32(2), uint32(2),uint32(2)); 
handleDAQmxError('myni', err);

% set it to output just one pulse
err = calllib('myni', 'DAQmxCfgImplicitTiming', taskHandle, uint32(10178), uint64(1));

handleDAQmxError('myni', err);
setCounterOutputTerminal('myni', taskHandle, 'cDAQ9188-18F21FF/ctr0', '/cDAQ9188-18F21FF/PFI0')
% for high state
changeIdleState('myni', taskHandle, 'cDAQ9188-18F21FF/ctr0', 10192); % high state
err = calllib('myni', 'DAQmxStartTask', taskHandle);
handleDAQmxError('myni', err);
pause(0.01)
err = calllib('myni', 'DAQmxStopTask', taskHandle);
handleDAQmxError('myni', err);
% for low state
changeIdleState('myni', taskHandle, 'cDAQ9188-18F21FF/ctr0', 10214); % low state
err = calllib('myni', 'DAQmxStartTask', taskHandle);
handleDAQmxError('myni', err);
pause(0.01)
err = calllib('myni', 'DAQmxStopTask', taskHandle);
handleDAQmxError('myni', err);
%% starting tasks - 
% Set one task as the master that generates the start trigger signal
% all other tasks to be started with this task set up to use the same start
% trigger

% Assuming you have two tasks: analogTask and counterTask

% Configure the master task (analogTask) to generate a digital trigger on its start
calllib(analogTask.lib, 'DAQmxCfgDigEdgeStartTrig', analogTask.taskHandle, '/Dev1/PFI0', analogTask.DAQmx_Val_Rising);

% Configure the slave task (counterTask) to use the same start trigger
calllib(counterTask.lib, 'DAQmxCfgDigEdgeStartTrig', counterTask.taskHandle, '/Dev1/PFI0', counterTask.DAQmx_Val_Rising);

% Start the slave task first
counterTask.startTask();

% Then start the master task
analogTask.startTask();

% Both tasks will start together based on the shared trigger



% EXAMPLE NOT USING PFI PIN

% Configure the analog task (master) to generate its start trigger internally
% No need to call DAQmxCfgDigEdgeStartTrig for the master task since it is the trigger source

% Configure the counter task (slave) to use the analog task's internal start trigger
calllib(counterTask.lib, 'DAQmxCfgDigEdgeStartTrig', counterTask.taskHandle, '/Dev1/ai/StartTrigger', counterTask.DAQmx_Val_Rising);

% Start the slave task first
counterTask.startTask();

% Start the master task
analogTask.startTask();

% Both tasks will start together based on the internal start trigger

%% Synchronized tasks on the same chassis, different modules
% for tasks at same data rate
% export the clock from the master task
% use shared clock for slave tasks

d = xfedaq();
analogTask = d.createTask('AnalogTask');
analogTask.createChannel('AnalogInputVoltage', 'cDAQ9188-18F21FFMod1/ai0', 'AnalogChan', d.DAQmx_Val_Diff, -10.0, 10.0, d.DAQmx_Val_Volts);

counterTask = d.createTask('CounterTask');
DAQmxCreateCICountEdgesChan
% Configure the master task (analogTask) to export its sample clock
err = calllib('myni', 'DAQmxExportSignal', analogTask.taskHandle, 'DAQmx_Val_SampleClock', '/Dev1/ai/SampleClock');

% Configure the slave task (counterTask) to use the master task's sample clock
calllib(counterTask.lib, 'DAQmxCfgSampClkTiming', counterTask.taskHandle, '/Dev1/ai/SampleClock', 1000, counterTask.DAQmx_Val_Rising, counterTask.DAQmx_Val_ContSamps, 1000);

% Start the slave task first
counterTask.startTask();

% Then start the master task
analogTask.startTask();

%% Modifying buffer size example
% has to be done on a per task basis
function configureBuffer(lib, taskHandle, bufferSize)
    % Call DAQmxCfgInputBuffer to set the buffer size
    err = calllib(lib, 'DAQmxCfgInputBuffer', taskHandle, uint32(bufferSize));
    
    % Check for errors
    if err ~= 0
        % Retrieve and display the error message
        bufferSize = 2048;
        errorMsg = libpointer('cstring', blanks(bufferSize));
        calllib(lib, 'DAQmxGetErrorString', err, errorMsg, uint32(bufferSize));
        error('DAQmx Error: %s', errorMsg.Value);
    end
end

% Example usage:
lib = 'myni';  % Assuming 'myni' is your library alias
taskHandle = ...  % Your task handle
bufferSize = 100000;  % Set buffer size to 100,000 samples per channel
configureBuffer(lib, taskHandle, bufferSize);