
rate = 64;
durationSeconds = 10;

d = xfedaq();
d.createTask('AI','testTask1',rate,durationSeconds);
d.tasks(1).addChannel('AIVoltage','cDAQ2Mod2','ai0','testAnalogChanIn','RSE',[-10 10])
d.logging.mode = 'log';
d.logging.directoryPath = 'C:\Users\Ben Strom\Documents\Coding\xflow_DAQ';
d.logging.fileNamePrefix = 'New_Sys_Test';
d.acquisitionType = 'finite';

d.configureLogging();
d.tasks(1).configSampleClock();

d.start()