% temperature test



% Task 1 = strain gauges
% T
% 
% % NOTE - we should make all file rates a power of 2 for TDMS logging
% durationSeconds = 10; % 20 sec file lg

durationSeconds = 10; % per file for
RTDRate = 4;

d = xfedaq();
d.resetDevice('cDAQ9188-18F21FF'); % make sure any device routs and clock setup is wiped
d.logging.fileNamePrefix = 'Temp_test';
d.acquisitionType = 'finite';
d.logging.mode = 'log';
d.logging.directoryPath = 'C:\Users\Ben Strom\Documents\Loads_Data\new_system_cal\rotor_segment';
d.durationSeconds = durationSeconds;


%% 9237 Bridge modules (strain channels)
d.createTask('AI','hubDaq_temp',RTDRate,1);
d.task(1).addChannel('AIRTD','cDAQ9188-18F21FFMod8','ai2','DAQ Temp',[0 70],'Deg C','Pt3750','4 wire','internal',0.001,100);

%% Votlage channels
d.createTask('AI','nacelleDaq_temp',RTDRate,2);
d.task(2).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod2','ai14','DAQ Temp','RSE',[0.07 0.15]);

%% Set up timing
d.task(1).configSampleClock();
d.task(2).configSampleClock();
d.configureLogging();


%%
d.start();

