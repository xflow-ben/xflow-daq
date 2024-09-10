function results = process_data_point(files,cal,consts,tare)
% cal is an array of calibration structs
% tare is an array of tare structs

results = struct; % initialize result struct

%% Load data
tdms = readTDMS(files.dataFile,fullfile(files.absolute_data_dir,files.relative_experiment_dir));
in = convertTDMStoXFlowFormat(tdms);

%% Apply the tare(s)
% subtract off the tares from the raw data (for channels with tares)

[in,results] = consts.tare_func(in,tare,results);

% might want a catch so that channels that need tares but don't have them,
% don't get processed


%% Add chanNames to results for comparison with tare_applied
results.chanNames = in.chanNames;

%% Extract time
td.time = in.data(:,strcmp(in.chanNames,'time'));

%% Apply calibrations
% loop through the cal structs here. This should take care of the majority
% of the data conversion, with the exception of the encoder

for II = 1:length(cal)
    % Check is data is avalible for ALL relevant input channels
    flag = 1;
    for JJ = 1:length(cal(II).input_channels)
        pass = sum(strcmp(cal(II).input_channels{JJ},in.chanNames));
        if pass ~= 1
            flag = 0;
        end
    end

    % Apply calibration if data is avalible for ALL relevant input channels
    % (flag = 1)
    if flag
        temp = apply_calibration(in.data,in.chanNames,cal(II));
        fields = fieldnames(temp);
        for JJ = 1:length(fields) % make sure this works properly
            td.(fields{JJ}) = temp.(fields{JJ});
        end
    end
end

%% Put td in export struct
results.td = td;
end