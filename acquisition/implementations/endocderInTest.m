
% Task 1 = strain gauges
% T
% 
% % NOTE - we should make all file rates a power of 2 for TDMS logging
% durationSeconds = 10; % 20 sec file lg


d = xfedaq();
d.resetDevice('cDAQ9184-1A4BA5D'); % make sure any device routs and clock setup is wiped
pause(5)
d.logging.fileNamePrefix = 'encoder';
d.acquisitionType = 'finite';
d.logging.mode = 'log';

d.logging.directoryPath = 'C:\Users\Ben Strom\Documents\Loads_Data\new_system_cal\rotor_segment';
d.durationSeconds = 10;


%% 9237 Bridge modules (strain channels)

d.createTask('AI','DummyAnalog',512,3)
d.task(1).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai17','dummyAnalog','RSE',[0 10]);
%%
d.createTask('CI','encInput',512,1);
d.task(2).addChannel('CIAngEncoder', 'cDAQ9184-1A4BA5DMod1', 'ctr0', 'encoder','PFI0','PFI1','PFI2','X4',1000,'AHighBHigh');
d.task(2).sampleClock.source = 'userDefined';
d.task(2).sampleClock.terminal = '/cDAQ9184-1A4BA5D/ai/SampleClock';


%%
d.configureLogging();
d.task(1).configSampleClock();
d.task(2).configSampleClock();

%%
d.start