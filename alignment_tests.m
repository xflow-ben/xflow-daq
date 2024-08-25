
% 
% % NOTE - we should make all file rates a power of 2 for TDMS logging
% durationSeconds = 10; % 20 sec file lg

durationSeconds = 20;
strainAcqRate = 1024;

d = xfedaq();
d.resetDevice('cDAQ9188-18F21FF'); % make sure any device routs and clock setup is wiped
d.resetDevice('cDAQ9184-1A4BA5D'); % make sure any device routs and clock setup is wiped

d.logging.fileNamePrefix = 'align_test';
d.acquisitionType = 'finite';
d.logging.mode = 'log';
d.logging.directoryPath = 'C:\Users\Ben Strom\Documents\Coding\xflow_DAQ';
d.durationSeconds = durationSeconds;


%% 9237 Bridge modules (strain channels)
d.createTask('AI','hubDaq',strainAcqRate,2);

d.task(1).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai17','Battery Voltage','RSE',[-10 10]);
%% Votlage channels
d.createTask('AI','nacelleDaq',1024,1);

d.task(2).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod2','ai17','Battery Voltage','RSE',[-10 10]);

%% Set up timing



d.task(1).configSampleClock();
% d.routeSignal(d.task(1).startTrigger.autoTerminal,'/cDAQ9188-18F21FF/PFI1')
% % d.routeSignal('/cDAQ9188-18F21FF/PFI1','/cDAQ9188-18F21FF/te0/StartTrigger')
% d.task(2).setStartTrigTerm('/cDAQ9188-18F21FF/PFI1')
d.task(2).configSampleClock();
d.configureLogging();
% 
% d.task(1).configSampleClock();
% d.task(2).configSampleClock();
% 
% d.task(2).setStartTrigTerm(d.task(1).startTrigger.autoTerminal)
% d.task(2).configSampleClock();
%%
d.start();

%% 9411 RTD modules
d_rtd = xfedaq();
d_rtd.rate = 1;
d_rtd.acquisitionType = 'finite';
d_rtd.logging.fileLengthSeconds = fileLg;

d_rtd.addAIResistanceChan('cDAQ9188-18F21FFMod6/ai0','Upper blade outer',[30 70],'4 wire','internal',0.001)
d_rtd.addAIResistanceChan('cDAQ9188-18F21FFMod6/ai0','Upper blade inner',[30 70],'4 wire','internal',0.001)
d_rtd.addAIResistanceChan('cDAQ9188-18F21FFMod6/ai0','Center blade outer',[30 70],'4 wire','internal',0.001)
d_rtd.addAIResistanceChan('cDAQ9188-18F21FFMod6/ai0','Center blade inner',[30 70],'4 wire','internal',0.001)
d_rtd.addAIResistanceChan('cDAQ9188-18F21FFMod6/ai0','Lower blade outer',[30 70],'4 wire','internal',0.001)
d_rtd.addAIResistanceChan('cDAQ9188-18F21FFMod6/ai0','Lower blade inner',[30 70],'4 wire','internal',0.001)
d_rtd.addAIResistanceChan('cDAQ9188-18F21FFMod6/ai0','DAQ temp',[30 70],'4 wire','internal',0.001)

%% 9205 Voltage modules (accelerometers and other things)
% battery voltage

