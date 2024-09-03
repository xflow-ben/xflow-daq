function d = setupHubDAQ



% Task 1 = strain gauges
% T
% 
% % NOTE - we should make all file rates a power of 2 for TDMS logging
% durationSeconds = 10; % 20 sec file lg

durationSeconds = 10; % per file for
strainAcqRate = 512;
RTDRate = 4;

d = xfedaq();
d.resetDevice('Hub'); % make sure any device routs and clock setup is wiped
pause(5)
d.logging.fileNamePrefix = 'upper_arm_tests';
d.acquisitionType = 'finite';
d.logging.mode = 'log';

d.logging.directoryPath = 'C:\Users\Ben Strom\Documents\Loads_Data\new_system_cal\rotor_segment';
d.durationSeconds = durationSeconds;


%% 9237 Bridge modules (strain channels)
d.createTask('AI','rotorStrain',strainAcqRate,2);

d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod1','ai0','Lower Yoke Fx','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod1','ai1','Lower Yoke Fz','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod1','ai2','Lower Yoke My','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod1','ai3','Upper Yoke Fx','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod2','ai0','Upper Yoke Fz','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod2','ai1','Upper Yoke My','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod2','ai2','Lower Arm Mx','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod2','ai3','Lower Arm My','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod3','ai0','Lower Arm Mz','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod3','ai1','Upper Arm Mx','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod3','ai2','Upper Arm My','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod3','ai3','Upper Arm Mz','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod4','ai0','Upper Arm My SC','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod4','ai1','Center Blade Bend','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod4','ai2','Upper Blade Bend','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod4','ai3','Lower Blade Bend','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(1).addChannel('AIBridge','cDAQ9188-18F21FFMod5','ai0','Winglet','mV per Volt',[-25 25],'full','external',9.7,700);

%% Votlage channels
d.createTask('AI','BladeRTDs',RTDRate,1);


d.task(2).addChannel('AIResistance','cDAQ9188-18F21FFMod7','ai0','Upper Blade Inner',[30 70],'4 wire','internal',0.001);
d.task(2).addChannel('AIResistance','cDAQ9188-18F21FFMod7','ai1','Upper Blade Outer',[30 70],'4 wire','internal',0.001);
d.task(2).addChannel('AIResistance','cDAQ9188-18F21FFMod7','ai2','Center Blade Outer',[30 70],'4 wire','internal',0.001);
d.task(2).addChannel('AIResistance','cDAQ9188-18F21FFMod7','ai3','Center Blade Inner',[30 70],'4 wire','internal',0.001);
d.task(2).addChannel('AIResistance','cDAQ9188-18F21FFMod8','ai0','Lower Blade Inner',[30 70],'4 wire','internal',0.001);
d.task(2).addChannel('AIResistance','cDAQ9188-18F21FFMod8','ai1','Lower Blade Outer',[30 70],'4 wire','internal',0.001);
d.task(2).addChannel('AIRTD','cDAQ9188-18F21FFMod8','ai2','DAQ Temp',[0 70],'Deg C','Pt3750','4 wire','internal',0.001,100);
d.task(2).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai17','Battery Voltage','RSE',[0 10]);


%% Set up timing

% sample clock routing for Strain channels
sampleClockTimebaseRate = strainAcqRate*256*31;
d.routeSignal('/Hub/20MHzTimebase','/Hub/PFI0')
d.task(1).setSampClkTimebaseSrc('/Hub/PFI0');
d.task(1).setSampClkTimebaseRate(sampleClockTimebaseRate);

d.task(1).configSampleClock();
% route start terminal from strain to RTDs
d.routeSignal(d.task(1).startTrigger.autoTerminal,'/Hub/PFI1')
d.task(2).setStartTrigTerm('/Hub/PFI1')
d.task(2).configSampleClock();
d.configureLogging();


%% Run this for every acquisition point
% d.task(1).metaData.Applied_Load = 0;
% d.task(1).metaData.Test_Name = 'drift_test';
d.unreserveHardware;
pause(0.25)
d.task(2).getModuleTemperature('cDAQ9188-18F21FFMod6')
d.reserveHardware;
d.start();