



% Task 1 = strain gauges
% T
% 
% % NOTE - we should make all file rates a power of 2 for TDMS logging
% durationSeconds = 10; % 20 sec file lg

durationSeconds = 20; % per file for
strainAcqRate = 512;
RTDRate = 4;

d = xfedaq();
d.resetDevice('cDAQ9188-18F21FF'); % make sure any device routs and clock setup is wiped
pause(5)
d.logging.fileNamePrefix = 'lower_arm_cal';
d.acquisitionType = 'finite';
d.logging.mode = 'log';

d.logging.directoryPath = 'C:\Users\Ben Strom\Documents\Loads_Data\load_calibrations\lower_arm';
d.durationSeconds = durationSeconds;


%% 9237 Bridge modules (strain channels)
d.createTask('AI','rotorStrain',strainAcqRate,2);

d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod1','ai0','Lower Yoke Fx','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod1','ai1','Lower Yoke Fz','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod1','ai2','Lower Yoke My','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod2','ai2','Lower Arm Mx','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod2','ai3','Lower Arm My','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod3','ai0','Lower Arm Mz','mV per Volt',[-25 25],'full','external',9.7,350);

%% Votlage channels
d.createTask('AI','BladeRTDs',RTDRate,1);

d.task(2).addChannel('AIRTD','cDAQ9188-18F21FFMod8','ai2','DAQ Temp',[0 70],'Deg C','Pt3750','4 wire','internal',0.001,100);
d.task(2).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai17','Battery Voltage','RSE',[0 10]);


%% Set up timing

% sample clock routing for Strain channels
sampleClockTimebaseRate = strainAcqRate*256*31;
d.routeSignal('/cDAQ9188-18F21FF/20MHzTimebase','/cDAQ9188-18F21FF/PFI0')
d.task(1).setSampClkTimebaseSrc('/cDAQ9188-18F21FF/PFI0');
d.task(1).setSampClkTimebaseRate(sampleClockTimebaseRate);

d.task(1).configSampleClock();
% route start terminal from strain to RTDs
d.routeSignal(d.task(1).startTrigger.autoTerminal,'/cDAQ9188-18F21FF/PFI1')
d.task(2).setStartTrigTerm('/cDAQ9188-18F21FF/PFI1')
d.task(2).configSampleClock();
d.configureLogging();


%% Run this for every acquisition point
d.task(1).metaData.Applied_Load = 0;
d.task(1).metaData.Test_Name = 'Lower_yoke_-My';
d.unreserveHardware;
pause(0.25)
d.task(2).getModuleTemperature('cDAQ9188-18F21FFMod6')
d.reserveHardware;
d.start();