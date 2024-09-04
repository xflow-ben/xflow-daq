
% Task 1 = strain gauges
% T
% 
% % NOTE - we should make all file rates a power of 2 for TDMS logging
% durationSeconds = 10; % 20 sec file lg


d = xfedaq();
d.resetDevice('cDAQ9184-1A4BA5D'); % make sure any device routs and clock setup is wiped
pause(5)
d.logging.fileNamePrefix = 'anno_and_RPM_TEST';
d.acquisitionType = 'finite';
d.logging.mode = 'log';

d.logging.directoryPath = 'C:\Users\Ben Strom\Documents\Loads_Data\load_calibrations';
d.durationSeconds = 20;


%% 9237 Bridge modules (strain channels)

d.createTask('AI','DummyAnalog',512,5)
d.task(1).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai17','dummyAnalog','RSE',[0 10]);
%%
d.createTask('CI','annoInput',512,1);
d.task(2).addChannel('CICountEdges', 'cDAQ9184-1A4BA5DMod1', 'ctr2', 'anno1', 'rising',0,'up');
d.task(2).sampleClock.source = 'userDefined';
d.task(2).sampleClock.terminal = '/cDAQ9184-1A4BA5D/ai/SampleClock';
d.task(2).setCICICountEdgesTerm('anno1','PFI4') % SE anno
% d.task(2).setCICountEdgesThreshVoltage('anno1',5.0);

% 
d.createTask('CI','annoInput2',512,2);
d.task(3).addChannel('CICountEdges', 'cDAQ9184-1A4BA5DMod1', 'ctr3', 'anno2', 'rising',0,'up');
d.task(3).sampleClock.source = 'userDefined';
d.task(3).sampleClock.terminal = '/cDAQ9184-1A4BA5D/ai/SampleClock';
d.task(3).setCICICountEdgesTerm('anno2','PFI5') % NE Anno

d.createTask('CI','RPM',512,3);
d.task(4).addChannel('CICountEdges', 'cDAQ9184-1A4BA5DMod1', 'ctr1', 'RPM', 'rising',0,'up');
d.task(4).sampleClock.source = 'userDefined';
d.task(4).sampleClock.terminal = '/cDAQ9184-1A4BA5D/ai/SampleClock';
d.task(4).setCICICountEdgesTerm('RPM','PFI3')

% % adding digital filter - needed for debounce
% d.task(2).enableCICountEdgesFltr('anno1');
% d.task(2).setCICountEdgesDigFltrMinPulseWidth('anno1',6.4e-6)
% d.task(3).enableCICountEdgesFltr('anno2');
% d.task(3).setCICountEdgesDigFltrMinPulseWidth('anno2',6.4e-6)
% d.task(4).enableCICountEdgesFltr('RPM');
% d.task(4).setCICountEdgesDigFltrMinPulseWidth('RPM',6.4e-6)

% d.task(2).enableCICountEdgesFltr('anno1');
% d.task(2).setCICountEdgesDigFltrMinPulseWidth('anno1',6.4e-7)
% d.task(3).enableCICountEdgesFltr('anno2');
% d.task(3).setCICountEdgesDigFltrMinPulseWidth('anno2',6.4e-7)
d.task(2).enableCICountEdgesFltr('anno1');
d.task(2).setCICountEdgesDigFltrMinPulseWidth('anno1',20.0e-6)
d.task(2).setCICountEdgesDigFltrTimebaseSrc('anno1','/cDAQ9184-1A4BA5D/100kHzTimebase')
d.task(3).enableCICountEdgesFltr('anno2');
d.task(3).setCICountEdgesDigFltrMinPulseWidth('anno2',20.0e-6)
d.task(3).setCICountEdgesDigFltrTimebaseSrc('anno2','/cDAQ9184-1A4BA5D/100kHzTimebase')

% d.createTask('CI','encInput',512,4);
% d.task(5).addChannel('CIAngEncoder', 'cDAQ9184-1A4BA5DMod1', 'ctr0', 'encoder','PFI0','PFI1','PFI2','X4',1000,'AHighBHigh');
% d.task(5).sampleClock.source = 'userDefined';
% d.task(5).sampleClock.terminal = '/cDAQ9184-1A4BA5D/ai/SampleClock';

%%
d.configureLogging();
d.task(2).configSampleClock();
d.task(3).configSampleClock();
d.task(4).configSampleClock();
d.task(1).configSampleClock();

% d.task(5).configSampleClock();
%%
d.start