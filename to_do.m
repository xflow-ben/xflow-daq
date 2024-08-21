% Determine timing approach% read/calculate timestamps

% Last tests
% - get sample clock of a master task, pass that through to tasks that
% are in the same group (same rate)
% - start multiple tasks groups using trigger, so that they start at the
% same time - working on this in
% trigger_start_separate_tasks_separate_rates
%
%
%
% Highest level of object represents task group that will be sampled
% together - OR highest level is groups of task groups that will be started
% together (but have different rates)

% NOTE - we could remove "Collection" and just have the Groups be set up
% with the proper triggering. Could make object class structure simpler.

% Collection - a number of task groups that will be started/stopped
% together (share start trigger signal). 
%  METHODS
%      - set start trigger. Set from external, or set all to start with
%      master
%      - Start. Starts all task groups together. Records time of start
%      - Get data. Called in a loop

% Group - a grouping of tasks that will all run at the same rate and use
% the same acquisition clock
%  METHODS
%      - Need way to get sample clock of the master and pass it to the
%      other tasks in the group


% Task - a collection of channels from a single module with the same
% settings (I think)
%  METHODS
%     - Get data. Get data from this task
%     - Create/add channel. I beleive channels must be on the same chassis,
%     and MAYBE on the same module, but could be that can they can be on
%     different modules of the same type. 

% Functions to create analog, RTD, counter chans
% functions to get and apply, or set the sample clock and rate
% function to start and stop the entire group
% functions to iterate through and get all the available data from the
% tasks/channels, and return it. This would get called in a while loop from
% some external function
% 

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
% trigger. IMPORTANT - if you use the same sample clock, this is not
% necessary. But if you want multiple task groups to be triggered by
% something, it could 

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

% IMPORTANT INFO
% (cDAQ-9184/9188) The cDAQ-9184/9188 has three AI timing engines, which
% means that three analog input tasks can be running at a time on a
% chassis. An analog input task can include channels from multiple analog
% input modules. However, channels from a single module cannot be used in
% multiple tasks. Multiple timing engines allow the cDAQ-9184/9188 to run
% up to three analog input tasks simultaneously, each using independent
% timing and triggering configurations. The three AI timing engines are ai,
% te0, and te1.
rate = 10000;
nSamples = rate*5;
d = xfedaq();
analogTask = d.createTask('AnalogTask');
analogTask.createChannel('AnalogInputVoltage', 'cDAQ9188-18F21FFMod1/ai0', 'AnalogChan', d.DAQmx_Val_Diff, -10.0, 10.0, d.DAQmx_Val_Volts);
% timingEngine = libpointer('uint32Ptr', 2);

% [err, ~, timingEngine] = calllib('myni', 'DAQmxGetSampTimingEngine', analogTask.taskHandle, timingEngine);

counterTask = d.createTask('CounterTask');
err = calllib('myni','DAQmxCreateCICountEdgesChan',counterTask.taskHandle,'cDAQ9188-18F21FFMod2/ctr0','',d.DAQmx_Val_Rising, int32(0),d.DAQmx_Val_CountUp);
handleDAQmxError('myni', err);
% % Configure the master task (analogTask) to export its sample clock
% err = calllib('myni', 'DAQmxExportSignal', analogTask.taskHandle, d.DAQmx_Val_SampleClock, '/cDAQ9188-18F21FF/PFI0');
% % 
% % Configure the slave task (counterTask) to use the master task's sample clock
% % err = calllib('myni', 'DAQmxCfgSampClkTiming', counterTask.taskHandle, '/cDAQ9188-18F21FF/ai/SampleClock', rate, d.DAQmx_Val_Rising, d.DAQmx_Val_ContSamps, uint64(2000));
% err = calllib('myni', 'DAQmxCfgSampClkTiming', counterTask.taskHandle, '/cDAQ9188-18F21FF/PFI0', rate, d.DAQmx_Val_Rising, d.DAQmx_Val_ContSamps, uint64(2000));
% 
% % Start the slave task first
% counterTask.startTask();
% 
% % Then start the master task
% analogTask.startTask();


% % Configure the master task (analogTask) to export its sample clock
% err = calllib('myni', 'DAQmxSetSampTimingEngine', analogTask.taskHandle, uint32(0));
% err = calllib('myni', 'DAQmxSetSampTimingEngine', counterTask.taskHandle, uint32(0));
% 
% Configure the slave task (counterTask) to use the master task's sample clock
% NOTE - if using the ai/SampleClock, you don't set the analog task sample
% clock (it is ai by default and gets mad if you set it)

% for continuous
err = calllib('myni', 'DAQmxCfgSampClkTiming', analogTask.taskHandle, '/cDAQ9188-18F21FF/te0/SampleClock', rate, d.DAQmx_Val_Rising, d.DAQmx_Val_ContSamps, uint64(nSamples));
err = calllib('myni', 'DAQmxCfgSampClkTiming', counterTask.taskHandle, '/cDAQ9188-18F21FF/te0/SampleClock', rate, d.DAQmx_Val_Rising, d.DAQmx_Val_ContSamps, uint64(nSamples));

% for finite
% err = calllib('myni', 'DAQmxCfgSampClkTiming', analogTask.taskHandle, '/cDAQ9188-18F21FF/te0/SampleClock', rate, d.DAQmx_Val_Rising, d.DAQmx_Val_FiniteSamps, uint64(nSamples));
% err = calllib('myni', 'DAQmxCfgSampClkTiming', counterTask.taskHandle, '/cDAQ9188-18F21FF/te0/SampleClock', rate, d.DAQmx_Val_Rising,d.DAQmx_Val_FiniteSamps, uint64(nSamples));
% 
err = calllib('myni', 'DAQmxCfgSampClkTiming', analogTask.taskHandle, '/cDAQ9188-18F21FF/ai/SampleClock', rate, d.DAQmx_Val_Rising, d.DAQmx_Val_FiniteSamps, uint64(nSamples));
handleDAQmxError('myni', err);
err = calllib('myni', 'DAQmxCfgSampClkTiming', counterTask.taskHandle, '', rate, d.DAQmx_Val_Rising,d.DAQmx_Val_FiniteSamps, uint64(nSamples));
handleDAQmxError('myni', err);

% err = calllib('myni', 'DAQmxCfgDigEdgeStartTrig', analogTask.taskHandle, '/cDAQ9188-18F21FF/ai/StartTrigger', d.DAQmx_Val_Rising);
% err = calllib('myni', 'DAQmxCfgDigEdgeStartTrig', counterTask.taskHandle, '/cDAQ9188-18F21FF/ai/StartTrigger', d.DAQmx_Val_Rising);


% TO DO - get the timestamp of the first samples of these two tasks and
% make sure they are essentially the same
% Start the slave task first
counterTask.startTask();

% Then start the master task
analogTask.startTask();


analogData = zeros(nSamples, 1);
counterData = zeros(nSamples, 1);

readAnalogPtr = libpointer('doublePtr', analogData);
readCounterPtr = libpointer('uint32Ptr', counterData);
sampsPerChanPtr = libpointer('int32Ptr', int32(nSamples));

err = calllib('myni', 'DAQmxReadAnalogF64', analogTask.taskHandle, int32(-1), 10.0, d.DAQmx_Val_GroupByChannel, readAnalogPtr, uint32(nSamples), sampsPerChanPtr, []);
handleDAQmxError('myni', err);
[int32, voidPtr, doublePtr, int32Ptr, uint32Ptr] DAQmxReadAnalogF64(voidPtr, int32, double, uint32, doublePtr, uint32, int32Ptr, uint32Ptr)
calllib('myni', 'DAQmxReadCounterU32', counterTask.taskHandle, int32(nSamples), 10.0, readCounterPtr, uint32(nSamples), []);

analogData = readAnalogPtr.Value;
counterData = readCounterPtr.Value;




% Retrieve the start trigger timestamp for both tasks
cviTimeStruct = struct('cviTime', 0);

analogTimestampPtr = libpointer('doublePtr', 0);
counterTimestampPtr = libpointer('doublePtr', 0);

% Get the timestamp when the start trigger occurred
err = calllib('myni', 'DAQmxGetStartTrigTimestampVal', analogTask.taskHandle, analogTimestampPtr);
handleDAQmxError('DAQmxGetStartTrigTimestamp (Analog)', err);

err = calllib('myni', 'DAQmxGetStartTrigTimestampVal', counterTask.taskHandle, counterTimestampPtr);
handleDAQmxError('DAQmxGetStartTrigTimestamp (Counter)', err);

% Calculate the timestamp for the first sample
analogFirstSampleTimestamp = double(analogTimestampPtr.Value) + 1 / rate;
counterFirstSampleTimestamp = double(counterTimestampPtr.Value) + 1 / rate;

% Display the first sample timestamps
fprintf('Analog Task First Sample Timestamp: %f\n', analogFirstSampleTimestamp);
fprintf('Counter Task First Sample Timestamp: %f\n', counterFirstSampleTimestamp);


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