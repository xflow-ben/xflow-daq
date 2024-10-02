function td = convertTDMStoXFlowFormat(d,previous_start_time,previous_end_time)

%% Extract timestamps
rate = d.property(strcmp({d.property.name},'rate')).value; % DAQ sample rate [Hz]

% NOTE: I'm assuming the start time is the same for all channels in a file
start_time = d.group.channel(1).property(strcmp({d.group.channel(1).property.name},'wf_start_time')).value;

if nargin > 1
    % If the start_time is the same between files, keep incrmenting time
    % NOTE: I'm assuming the files are read in the right order for this...
    % will be fixed in the future
    if start_time == previous_start_time
        start_time = previous_end_time + seconds(1)/rate;
    end
end
num_points = length(d.group.channel(1).data);
time = start_time + seconds(0:num_points-1)/rate;

%%

chanNames = {d.group.channel.name};
chanNames{end + 1} = 'time';

data = [d.group.channel.data];
data(:,end + 1) = datenum(time)*24*60*60;

td.chanNames = chanNames;
td.data = data;