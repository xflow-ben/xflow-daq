
d = xfedaq();



    d.resetDevice('cDAQ9184-1A4BA5D');
    pause(10)
     d.resetDevice('cDAQ9184-1A4BA5DMod2');

%%
d.logging.fileNamePrefix = 'nacell_strain_test';
d.acquisitionType = 'finite';
d.logging.mode = 'log';

d.logging.directoryPath = 'C:\Users\XFlow Energy\Documents\GitHub\xflow-daq';
d.durationSeconds = 5;

task = struct;
i = 1;
task(i).name = 'nacelle_strain';
task(i).rate = 2048;
task(i).startOrder = 1;
%%
d.createTask('AI',task(i).name,12.8e6/(256*31),2);

d.task(i).addChannel('AIBridge','cDAQ9184-1A4BA5DMod2','ai0','Torque Arm Left','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).startTrigger.terminal = '/cDAQ9184-1A4BA5DMod3/PFI0';
i = i + 1;
d.createTask('AI','dummyai',512,1);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai0','dumm chan','RSE',[-10 10]);
% %sampleClockTimebaseRate = task(1).rate*256*31;
% d.task(i).setSampClkTimebaseSrc('/cDAQ9184-1A4BA5D/100kHzTimebase');
% % d.task(i).setSampClkTimebaseRate(sampleClockTimebaseRate);
% d.task(i).configSampleClock();
% things to try
% direct routing
% route through ai sampleclock timebase
% route through FrequnecyOutput
sampleClockTimebaseRate = task(i).rate*256*5;
d.routeSignal('/cDAQ9184-1A4BA5D/100kHzTimebase','/cDAQ9184-1A4BA5DMod3/PFI0')
d.task(i).setSampClkTimebaseSrc('/cDAQ9184-1A4BA5D/ai/SampleClockTimebase');
d.task(i).setSampClkTimebaseRate(sampleClockTimebaseRate);
d.task(1).configSampleClock();