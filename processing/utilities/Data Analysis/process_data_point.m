function results = process_data_point(files,cal,consts,tare)
% files contains absolute and relative path information
% cal is an array of calibration structs
% consts is a struct with project specific values
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
% of the data conversion
results.cal_applied = zeros(size(results.chanNames)); % initialize 

for II = 1:length(cal)
    % Check is data is avalible for ALL relevant input channels
    flag = 1;
    data_ind = [];
    for JJ = 1:length(cal(II).input_channels)
         temp = find(strcmp(cal(II).input_channels{JJ},in.chanNames));
        if isempty(temp)
            flag = 0;
        elseif length(temp) > 1
            error(sprintf('Input channel %s is found twice in data',strcmp(cal(II).input_channels{JJ})))
        else
            data_ind(JJ) = temp;
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
        results.cal_applied(data_ind) = ones(size(data_ind));
    end
end

%% Put td in export struct
results.td = td;
end