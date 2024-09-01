channel = 'Upper Arm My';
filePath = pwd;% 'C:\Users\Ian\Documents\GitHub\xflow-daq';
fileNames = dir(fullfile(filePath,'*rotorStrain*.tdms'));

for II = 1:length(fileNames)
    %% Read tdms file
    df = readTDMS(fileNames(II).name,filePath);
    propNames = {df.property.name};
    ind = find(strcmp(propNames,'Applied_Load'));
    applied_load(II) = str2double(df.property(ind).value);

    chanNames = {df.group(1).channel.name};
    chanInd = find(strcmp(chanNames,channel));
    V(II) = median(df.group(1).channel(chanInd).data);
    %% Extract properties
    rate = df.property(strcmp({df.property.name},'rate')).value; % DAQ sample rate [Hz]

    % % NOTE: I'm assuming the start time is the same for all channels in a file
    % start_time(II) = df.group.channel(1).property(strcmp({df.group.channel(1).property.name},'wf_start_time')).value;
    % 
    % % If the start_time is the same between files, keep incrmenting time
    % % NOTE: I'm assuming the files are read in the right order for this...
    % % will be fixed in the future
    % if II > 1 && start_time(II-1) == start_time(II)
    %     start_time(II) = time(end) + seconds(1)/rate;
    % end
    % 
    % num_points = length(df.group.channel(1).data);
    % time = start_time(II) + seconds(0:num_points-1)/rate;

    %% Plot
    % figure(1)
    %     title('Quick timeseries')
    % for JJ = 1:length(df.group.channel)
    %     plot(time,df.group.channel(JJ).data)
    %     hold on
    % end

    % figure(2)
    % title('Quick median')
    % for JJ = 1:length(df.group.channel)
    %     plot(applied_load(i),median(df.group.channel(JJ).data),'o')
    %     hold on
    % end
end
plot(applied_load,V,'o')