function generate_QBlade_simulation_input_file_from_data(filename,results,datenum_start,datenum_end,wake_buildup_time)

results.td.datenum = results.td.Time/(24*60*60);
ind = results.td.datenum > datenum_start & results.td.datenum < datenum_end;
time = results.td.Time(ind);
time = time-time(1);

if nargin>3
    time(2:end) = time(2:end) + wake_buildup_time;
end
%% Assemble data in QBlade hub height file format
%Time    RPM
data = [time, ...
    results.td.omega_sensor(ind)*60/(2*pi)];

write_QBlade_simulation_input_file(filename,data)
end

function write_QBlade_simulation_input_file(filename,data)

%% Write file
% Open the file for writing
filename = strrep(filename, ':', '_');
fileID = fopen(filename, 'w');

% Write the header
fprintf(fileID, 'Time\tRPM\n');

% Write the data
for II = 1:size(data, 1)
    fprintf(fileID, '%f\t%f\t\n', data(II,:));
end

% Close the file
fclose(fileID);
end