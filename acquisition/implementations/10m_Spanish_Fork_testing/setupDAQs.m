% function d = setupDAQs
duration = 30;
finiteContinuous = 'finite';
filenamePrefix = 'data';
directory = 'C:\Users\XFlow Energy\Documents\GitHub\xflow-daq';
% Togetherness notes
% same task if
% - same chassis
% - same rate
% - (RTD + Voltage) (strain) (individual counter chans)

% task list
%   Rotor Strain
%   Rotor RTD + batt voltage
%   Rotor Accelerometers
%   Guy wire strain + temperature
%   Nacelle Strain
%   Nacelle Accelerometers
%   Anno #1
%   Anno #2
%   Encoder
%   RPM Sensor

encPPR = 1000; % CHECK THIS

i = 1;
task(i).name = 'rotor_strain';
task(i).rate = 12.8e6/(256*31);
task(i).startOrder = 98; 

i = i + 1;
task(i).name = 'rotor_RTD';
task(i).rate = 4;
task(i).startOrder = 1; 

i = i + 1;
task(i).name = 'rotor_acc';
task(i).rate = 20e6/round(20e6/4096);
task(i).startOrder = 2; 

i = i + 1;
task(i).name = 'gw_strain';
task(i).rate = 12.8e6/(256*31);
task(i).startOrder = 99; 

i = i + 1;
task(i).name = 'nacelle_strain';
task(i).rate = 12.8e6/(256*31);
task(i).startOrder = 3; 

i = i + 1;
task(i).name = 'nacelle_voltage';
task(i).rate = 20e6/round(20e6/4096);
task(i).startOrder = 4; 

i = i + 1;
task(i).name = 'anno_1';
task(i).rate = 20e6/round(20e6/4096);
task(i).startOrder = 5; 

i = i + 1;
task(i).name = 'anno_2';
task(i).rate = 20e6/round(20e6/4096);
task(i).startOrder = 6; 

i = i + 1;
task(i).name = 'encoder';
task(i).rate = 20e6/round(20e6/4096);
task(i).startOrder = 7; 

% i = i + 1;
% task(i).name = 'rpm_sensor';
% task(i).rate = 20e6/round(20e6/4096);
% task(i).startOrder = 8; 

i = i + 1;
task(i).name = 'met_tower';
task(i).rate = 2000;
task(i).startOrder = 100; 



chassis_list{1} = 'cDAQ9184-1A4BA5D'; % Nacelle chassis
chassis_list{2} = 'cDAQ9188-151ABD7'; % Tower Base chassis
chassis_list{3} = 'cDAQ9188-18F21FF'; % Hub chassis
chassis_list{4} = 'cDAQ9188-19772AE'; % Met tower chassis

mod_list = {'cDAQ9184-1A4BA5DMod1','cDAQ9184-1A4BA5DMod2',...
    'cDAQ9184-1A4BA5DMod3','cDAQ9188-151ABD7Mod1','cDAQ9188-18F21FFMod1'...
    'cDAQ9188-18F21FFMod2','cDAQ9188-18F21FFMod3','cDAQ9188-18F21FFMod4',...
    'cDAQ9188-18F21FFMod5','cDAQ9188-18F21FFMod6','cDAQ9188-18F21FFMod7',...
    'cDAQ9188-18F21FFMod8','cDAQ9188-19772AEMod3','cDAQ9188-19772AEMod5'};


%% Basic setup tasks


d = xfedaq();
for i = 1:length(chassis_list)
    d.resetDevice(chassis_list{i});
end
pause(10)% wait for them to reconnect
for i = 1:length(mod_list)
    d.resetDevice(mod_list{i});
end
pause(2)


d.logging.fileNamePrefix = filenamePrefix;
d.acquisitionType = finiteContinuous;
d.logging.mode = 'log';

d.logging.directoryPath = directory;
d.durationSeconds = duration;
i = 0;
%% rotor_strain
i = i + 1;

d.createTask('AI',task(i).name,task(i).rate,task(i).startOrder);

d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod1','ai0','Lower Yoke Fx','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod1','ai1','Lower Yoke Fz','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod1','ai2','Lower Yoke My','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod1','ai3','Upper Yoke Fx','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod2','ai0','Upper Yoke Fz','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod2','ai1','Upper Yoke My','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod2','ai2','Lower Arm Mx','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod2','ai3','Lower Arm My','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod3','ai0','Lower Arm Mz','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod3','ai1','Upper Arm Mx','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod3','ai2','Upper Arm My','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod3','ai3','Upper Arm Mz','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod4','ai0','Upper Arm My SC','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod4','ai1','Center Blade Bend','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod4','ai2','Upper Blade Bend','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod4','ai3','Lower Blade Bend','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-18F21FFMod5','ai0','Winglet','mV per Volt',[-25 25],'full','external',9.7,700);


% % sample clock routing
% sampleClockTimebaseRate = task(i).rate*256*31;
% d.routeSignal('/cDAQ9188-18F21FF/20MHzTimebase','/cDAQ9188-18F21FF/PFI0')
% d.task(i).setSampClkTimebaseSrc('/cDAQ9188-18F21FF/PFI0');
% d.task(i).setSampClkTimebaseRate(sampleClockTimebaseRate);


%% rotor_RTD: Rotor RTD + Batt voltage + Hub Daq Temp
i = i + 1;

d.createTask('AI',task(i).name,task(i).rate,task(i).startOrder);

d.task(i).addChannel('AIResistance','cDAQ9188-18F21FFMod7','ai0','Upper Blade Inner',[30 70],'4 wire','internal',0.001);
d.task(i).addChannel('AIResistance','cDAQ9188-18F21FFMod7','ai1','Upper Blade Outer',[30 70],'4 wire','internal',0.001);
d.task(i).addChannel('AIResistance','cDAQ9188-18F21FFMod7','ai2','Center Blade Outer',[30 70],'4 wire','internal',0.001);
d.task(i).addChannel('AIResistance','cDAQ9188-18F21FFMod7','ai3','Center Blade Inner',[30 70],'4 wire','internal',0.001);
d.task(i).addChannel('AIResistance','cDAQ9188-18F21FFMod8','ai0','Lower Blade Inner',[30 70],'4 wire','internal',0.001);
d.task(i).addChannel('AIResistance','cDAQ9188-18F21FFMod8','ai1','Lower Blade Outer',[30 70],'4 wire','internal',0.001);
d.task(i).addChannel('AIRTD','cDAQ9188-18F21FFMod8','ai2','Hub DAQ Temp',[0 70],'Deg C','Pt3750','4 wire','internal',0.001,100);


%% rotor_acc: Rotor Accs
i = i + 1;

d.createTask('AI',task(i).name,task(i).rate,task(i).startOrder);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai0','Acc Winglet X Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai1','Acc Winglet Y Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai2','Acc Winglet Z Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai3','Acc Upper Arm X Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai4','Acc Upper Arm Y Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai5','Acc Upper Arm Z Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai6','Acc Lower Arm X Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai7','Acc Lower Arm Y Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai16','Acc Lower Arm Z Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai8','Acc Winglet X','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai9','Acc Winglet Y','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai10','Acc Winglet Z','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai11','Acc Upper Arm X','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai12','Acc Upper Arm Y','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai13','Acc Upper Arm Z','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai14','Acc Lower Arm X','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai15','Acc Lower Arm Y','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai24','Acc Lower Arm Z','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9188-18F21FFMod6','ai17','Battery Voltage','RSE',[0 10]);
%% gw_strain: Guy Wire Strain + Tower Base DAQ Temp
i = i + 1;
d.createTask('AI',task(i).name,task(i).rate,task(i).startOrder);

d.task(i).addChannel('AIBridge','cDAQ9188-151ABD7Mod1','ai0','Upper GW N','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(i).addChannel('AIBridge','cDAQ9188-151ABD7Mod1','ai1','Lower GW N','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(i).addChannel('AIBridge','cDAQ9188-151ABD7Mod1','ai2','Upper GW E','mV per Volt',[-25 25],'full','external',9.7,700);
d.task(i).addChannel('AIBridge','cDAQ9188-151ABD7Mod1','ai3','Lower GW E','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-151ABD7Mod2','ai0','Upper GW S','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-151ABD7Mod2','ai1','Lower GW S','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-151ABD7Mod2','ai2','Upper GW W','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-151ABD7Mod2','ai3','Lower GW W','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9188-151ABD7Mod3','ai0','Tower Base DAQ Temp','mV per Volt',[-25 25],'half','external',9.7,350);

% sampleClockTimebaseRate = task(i).rate*256*31;
% d.routeSignal('/cDAQ9188-151ABD7/20MHzTimebase','/cDAQ9188-151ABD7/PFI0')
% d.task(i).setSampClkTimebaseSrc('/cDAQ9188-151ABD7/PFI0');
% d.task(i).setSampClkTimebaseRate(sampleClockTimebaseRate);
%% nacelle_strain: Nacelle Strain
i = i + 1;
d.createTask('AI',task(i).name,task(i).rate,task(i).startOrder);

d.task(i).addChannel('AIBridge','cDAQ9184-1A4BA5DMod2','ai0','Torque Arm Left','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9184-1A4BA5DMod2','ai1','Torque Arm Right','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9184-1A4BA5DMod2','ai2','Nacelle Bending A','mV per Volt',[-25 25],'full','external',9.7,350);
d.task(i).addChannel('AIBridge','cDAQ9184-1A4BA5DMod2','ai3','Nacelle Bending B','mV per Volt',[-25 25],'full','external',9.7,350);

%% nacelle_voltage: Nacelle Accelerometer + Power Transducer + Nacelle DAQ Temp
i = i + 1;
d.createTask('AI',task(i).name,task(i).rate,task(i).startOrder);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai0','Acc Nacelle X Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai1','Acc Nacelle Y Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai2','Acc Nacelle Z Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai7','RPM Sensor','Diff',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai8','Acc Nacelle X','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai9','Acc Nacelle Y','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai10','Acc Nacelle Z','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai3','Power Transducer Filt','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai11','Power Transducer','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai12','Gearbox Temp','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai13','Generator Temp','RSE',[-10 10]);
d.task(i).addChannel('AIVoltage','cDAQ9184-1A4BA5DMod3','ai14','Nacelle DAQ Temp','RSE',[-10 10]);

%% Anno #1
i = i + 1;
d.createTask('CI',task(i).name,task(i).rate,task(i).startOrder);
d.task(i).addChannel('CICountEdges', 'cDAQ9184-1A4BA5DMod1', 'ctr1', 'Anno 1', 'rising',0,'up');
d.task(i).setCICICountEdgesTerm('Anno 1','PFI4') % SE anno
%% Anno #2
i = i + 1;
d.createTask('CI',task(i).name,task(i).rate,task(i).startOrder);
d.task(i).addChannel('CICountEdges', 'cDAQ9184-1A4BA5DMod1', 'ctr2', 'Anno 2', 'rising',0,'up');
d.task(i).setCICICountEdgesTerm('Anno 2','PFI5') % SE anno
%% Encoder
i = i + 1;
d.createTask('CI',task(i).name,task(i).rate,task(i).startOrder);
d.task(i).addChannel('CIAngEncoder', 'cDAQ9184-1A4BA5DMod1', 'ctr0', 'Encoder','PFI0','PFI1','PFI2','X4',encPPR,'AHighBHigh');
%% RPM Sensor
% i = i + 1;
% d.createTask('CI',task(i).name,task(i).rate,task(i).startOrder);
% d.task(i).addChannel('CICountEdges', 'cDAQ9184-1A4BA5DMod1', 'ctr3', 'RPM', 'rising',0,'up');
% d.task(i).setCICICountEdgesTerm('RPM','PFI3')
%% Met Tower
i = i + 1;
d.loadTask('AI',task(i).name,task(i).rate,task(i).startOrder);

%% Start trigger routing

% hub daq
taskNames = {task.name};
rotor_strain_ind = find(ismember(taskNames,'rotor_strain'));
rotor_RTD_ind = find(ismember(taskNames,'rotor_RTD'));
rotor_acc_ind = find(ismember(taskNames,'rotor_acc'));

% route rotor_strain to PFI1 on chassis
d.task(rotor_strain_ind).configSampleClock();
d.routeSignal(d.task(rotor_strain_ind).startTrigger.autoTerminal,'/cDAQ9188-18F21FF/PFI1');

% use PFI1 for start trigger for rotor_RTD and rotor_acc
d.task(rotor_RTD_ind).setStartTrigTerm('/cDAQ9188-18F21FF/PFI1');
d.task(rotor_RTD_ind).configSampleClock();
d.task(rotor_acc_ind).setStartTrigTerm('/cDAQ9188-18F21FF/PFI1');
d.task(rotor_acc_ind).configSampleClock();

% route gw_strain start trigger to PFI1, which is physically wired to
% nacelle daq /cDAQ9184-1A4BA5DMod3/PFI0
gw_strain_ind = find(ismember(taskNames,'gw_strain'));
d.task(gw_strain_ind).configSampleClock();
d.routeSignal(d.task(gw_strain_ind).startTrigger.autoTerminal,'/cDAQ9188-151ABD7/PFI1');

nacelle_task_to_trig = {'nacelle_strain', 'nacelle_voltage'};
for i = 1:length(nacelle_task_to_trig)
    task_ind = find(ismember(taskNames,nacelle_task_to_trig{i}));
    if ~isempty(task_ind)
        d.task(task_ind).setStartTrigTerm('/cDAQ9184-1A4BA5DMod3/PFI0');
        d.task(task_ind).configSampleClock();
    end
end

% set nacelle counter chans to use nacelle_voltage sample clock
countChans = {'anno_1','anno_2','encoder'};
nacelle_v_ind = find(ismember(taskNames,'nacelle_voltage'));
d.reserveHardware;
scterm = d.task(nacelle_v_ind).getSampleClockTerm;
d.unreserveHardware;
for i = 1:length(countChans)
    ind = find(ismember(taskNames,countChans{i}));
    if ~isempty(ind)
        d.task(ind).sampleClock.source = 'userDefined';
        d.task(ind).sampleClock.terminal = scterm;
    end
end
%% config all tasks again to make sure we are good, and configure logging
d.unreserveHardware;
for i = 1:length(task)
    d.task(i).configSampleClock();
end
d.configureLogging;
d.unreserveHardware;
d.reserveHardware;
% end