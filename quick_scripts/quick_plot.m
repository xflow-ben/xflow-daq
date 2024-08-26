clear all
close all
clc

filePath = 'C:\Users\Ian\Documents\GitHub\xflow-daq';
fileNames =dir(fullfile(filePath,'*.tdms'));

for II = 1:length(fileNames)
    %% Read tdms file
    d = readTDMS(fileNames(II).name,filePath);

    %% Extract properties
    rate = d.property(strcmp({d.property.name},'rate')).value; % DAQ sample rate [Hz]

    % NOTE: I'm assuming the start time is the same for all channels in a file
    start_time(II) = d.group.channel(1).property(strcmp({d.group.channel(1).property.name},'wf_start_time')).value;

    % If the start_time is the same between files, keep incrmenting time
    if II > 1 && start_time(II-1) == start_time(II)
        start_time(II) = time(end) + seconds(1)/rate;
    end

    num_points = length(d.group.channel(1).data);
    time = start_time(II) + seconds(0:num_points-1)/rate;

    %% Plot
    for JJ = 1:length(d.group.channel)
        plot(time,d.group.channel(JJ).data)
        hold on
    end
end