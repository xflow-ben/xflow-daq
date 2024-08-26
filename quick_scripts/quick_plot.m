clear all
% close all
clc

filePath = 'C:\Users\Ian\Documents\GitHub\xflow-daq';
fileName ='full_hub_test_rotorStrain_0001.tdms';
d = readTDMS(fileName,filePath);

rate = d.property(strcmp({d.property.name},'rate')).value; % DAQ sample rate [Hz]

% NOTE: I'm assuming the start time is the same for all channels in a file
start_time = d.group.channel(1).property(strcmp({d.group.channel(1).property.name},'wf_start_time')).value;
num_points = length(d.group.channel(1).data);
time = start_time + seconds(1:num_points)/rate;

%%
for JJ = 1:length(d.group.channel)
    plot(time,d.group.channel(JJ).data)
    hold on
end