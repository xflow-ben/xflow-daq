
durationSeconds = 20; % per file for
strainAcqRate = 512;
RTDRate = 4;

d = xfedaq();
d.resetDevice('cDAQ9188-151ABD7'); % make sure any device routes and clock setup is wiped
pause(5)
d.logging.fileNamePrefix = 'guy_wire_cal';
d.acquisitionType = 'finite';
d.logging.mode = 'log';

d.logging.directoryPath = 'E:\loads_data\guy_wire_cal';
d.durationSeconds = durationSeconds;


%% 9237 Bridge modules (strain channels)
d.createTask('AI','towerBaseStrain',strainAcqRate,1);

d.task(1).addChannel('AIBridge','cDAQ9188-151ABD7Mod1','ai0','Upper GW N','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-151ABD7Mod1','ai1','Lower GW N','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-151ABD7Mod1','ai2','Upper GW E','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-151ABD7Mod1','ai3','Lower GW E','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-151ABD7Mod2','ai0','Upper GW S','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-151ABD7Mod2','ai1','Lower GW S','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-151ABD7Mod2','ai2','Upper GW W','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-151ABD7Mod2','ai3','Lower GW W','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-151ABD7Mod3','ai0','Tower Base DAQ Temp','mV per Volt',[-25 25],'half','external',9.7,350);

%% Set up timing

sampleClockTimebaseRate = strainAcqRate*256*31;
d.routeSignal('/cDAQ9188-151ABD7/20MHzTimebase','/cDAQ9188-151ABD7/PFI0')
d.task(1).setSampClkTimebaseSrc('/cDAQ9188-151ABD7/PFI0');
d.task(1).setSampClkTimebaseRate(sampleClockTimebaseRate);

d.task(1).configSampleClock();
d.configureLogging();


%% Run this for every acquisition point
disp('New point')
d.task(1).metaData.Applied_Load = 0;
d.task(1).metaData.Test_Name = 'Lower_GW_W';
d.start();