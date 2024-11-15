function results_all = process_data_folder(files,cal,consts)
% files contains absolute and relative path information
% cal is an array of calibration structs
% consts is a struct with project specific values

if consts.isCalibration
    consts.data.file_name_conventions = consts.data.cali.file_name_conventions;
    consts.data.default_rates = consts.data.cali.default_rates;
    consts.data.calibrate_before_resample = consts.data.cali.calibrate_before_resample;
end

%% Load tares
% Check if list of applicable tares is present in dataDir
tareList = dir(fullfile(files.absolute_data_dir,files.relative_experiment_dir,'tare*.mat'));

% If tare list is present, extract all tares into struct array
if isempty(tareList)
    error(sprintf('No tare list file in %s',fullfile(files.absolute_data_dir,files.relative_experiment_dir)))
elseif length(tareList) > 1
    error(sprintf('These is more than one tare list file in %s',fullfile(files.absolute_data_dir,files.relative_experiment_dir)))
else
    load(fullfile(files.absolute_data_dir,files.relative_experiment_dir,tareList.name))
end

% Create tare struct
% tare is a struct array with XX elements where XX specifies the naming
% convention for the files it applies to. Each tare(XX) contains:
% data_name_conventions: the naming convention for the files this tare
% struct applies to
% chanNames: The data channel names
% data: The median values from each tare file fom tareList which matches
% the naming convention
tare(1:length(consts.data.file_name_conventions)) = struct();

for II = 1:length(consts.data.file_name_conventions)
    count = 0;
    pattern = strrep(consts.data.file_name_conventions{II}, '*', '.*');
    for JJ = 1:length(tareList)
        if ~isempty(regexp(tareList{JJ},pattern,'once'))
            count = count + 1;
            tare_TDMS = readTDMS(tareList{JJ},fullfile(files.absolute_data_dir,files.relative_tare_dir));
            tare_td = convertTDMStoXFlowFormat(tare_TDMS,consts.data.default_rates(II));
            tare(II).data(count,:) = median(tare_td.data,1);
            if count == 1
                tare(II).data_name_conventions = consts.data.file_name_conventions{II};
                tare(II).chanNames = tare_td.chanNames;
            end
        end
    end
end

if isempty(fieldnames(tare))
    error('No tares were loaded')
end

%% Loop through all the data files, apply their tares, and then combine data of the same filetype

% Find file names that start with the specified naming convensions
for II = 1:length(consts.data.file_name_conventions)
    II/length(consts.data.file_name_conventions)
    if isfield(files,'filename_timestamp')
        if consts.isCalibration
            dataFiles = dir(fullfile(files.absolute_data_dir,files.relative_experiment_dir,sprintf('full_hub_test_%s%d*.tdms',consts.data.cali.file_name_conventions{II},files.filename_timestamp)));
        else
            dataFiles = dir(fullfile(files.absolute_data_dir,files.relative_experiment_dir,sprintf('data_%d%s',files.filename_timestamp,consts.data.file_name_conventions{II})));
        end
    else
        dataFiles = dir(fullfile(files.absolute_data_dir,files.relative_experiment_dir,consts.data.file_name_conventions{II}));
    end

    if isempty(dataFiles)
        raw_multi_file(II).rate = NaN;
        raw_multi_file(II).chanNames = NaN;
        raw_multi_file(II).data = NaN;
        raw_multi_file(II).tare_applied = NaN;

    else
        if consts.debugMode
            forLoopInd = 1;
        else
            forLoopInd = 1:length(dataFiles);
        end
        for JJ = forLoopInd
            dataFiles(JJ).name
            % Load data
            tdms = readTDMS(dataFiles(JJ).name,fullfile(files.absolute_data_dir,files.relative_experiment_dir));
            if JJ == 1
                [raw, start_time, end_time] = convertTDMStoXFlowFormat(tdms,consts.data.default_rates(II));
            else % pass previous start and end times
                [raw, start_time, end_time] = convertTDMStoXFlowFormat(tdms,consts.data.default_rates(II),start_time, end_time);
            end

            % Apply the tare(s)
            % subtract off the tares from the raw data (for channels with tares)
            if isempty(fieldnames(tare))
                raw.tare_applied = zeros(size(raw.chanNames)); % no tares applied
            else
                raw = consts.tare_func(raw,tare(II));
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%THIS IS A FIX TO A MISNAMED LOAD FROM THE ROTOR SEGMENT %%%%%%%%%%%%
            %%%%%%%ON THE GROUND TESTS.THIS DOES NOT IMPACT FUTURE DATA%%%%%%%%%%%%
            if sum(strcmp([raw.chanNames],'LowerArm Mz'))>0
                raw.chanNames(strcmp([raw.chanNames],'LowerArm Mz')) = {'Lower Arm Mz'};
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Combine data from similar files
            if JJ == 1
                raw_multi_file(II) = raw;
            else
                raw_multi_file(II).data = [raw_multi_file(II).data; raw.data];
            end
        end
    end
end


%% Bring all data at the same rate together and calibrate
if consts.isCalibration
    file_ind = strcmp(consts.data.file_name_conventions,'*rotorStrain*');
else
    file_ind = strcmp(consts.data.file_name_conventions,'*rotor_strain*.tdms');

end

master_time =  raw_multi_file(file_ind).data(:,strcmp(raw_multi_file(file_ind).chanNames,'time'));
temp = find(diff(master_time)>1);
segment_start_ind = [1;temp + 1]; % indcies where a segment of continous data starts
segment_end_ind = [temp; length(master_time)]; % indcies where a segment of continous data ends

for KK = 1:length(segment_start_ind)
    start_time = master_time(segment_start_ind(KK));
    end_time = master_time(segment_end_ind(KK));

    new_time = start_time:1/consts.DAQ.downsampled_rate:end_time;

    %% Calibrate each file type individually
    % if it is the encoder file, it needs the reset commands from the RPM
    % sensor
    for II = 1:length(raw_multi_file)
        if consts.data.calibrate_before_resample(II) && ~isnan(raw_multi_file(II).rate)
            calibrated_data(II) = calibrate_data(cal,raw_multi_file(II));
            calibrated_fields = fieldnames(calibrated_data(II).td);
            ind_time = strcmp(calibrated_fields,'Time');
            for JJ = 1:length(calibrated_fields)
                if strcmp(calibrated_fields{JJ},'theta_encoder') % digitally resample counter channel
                    %%% BEN: Put your encoder resetting here
                    % resets are at calibrated_data(8).resetTimes
                    % encoder thetas are at calibrate_data(II).theta_encoder
                    % encoder time is at calibrate_data(II).Time
                    % you should delete the resetTimes since it's going to be
                    % resampled in the next step and become junk... or we can
                    % make an exception so it stays useful information. Your
                    % call.

                end

            end
        end
    end
    %% Downsample all the calibrated data together into results struct
    for II = 1:length(calibrated_data)
        if ~isempty(calibrated_data(II).td)
            calibrated_fields = fieldnames(calibrated_data(II).td);
            for JJ = 1:length(calibrated_fields)
                if ~strcmp(calibrated_fields{JJ},'Time') && ~strcmp(calibrated_fields{JJ},'resetTimes')
                    [t_resampled,y_resampled] = resample_w_time(calibrated_data(II).rate,consts.DAQ.downsampled_rate,...
                        calibrated_data(II).td.Time,calibrated_data(II).td.(calibrated_fields{JJ}));
                    results(KK).td.(calibrated_fields{JJ}) =  interp1(t_resampled,y_resampled,new_time');
                end
            end
        end
    end

    %% Combine remaining channels raw data at downsampled rate then calibrate it
    flag = 0;
    for II = 1:length(raw_multi_file)
        if ~consts.data.calibrate_before_resample(II) && ~isnan(raw_multi_file(II).rate) % is there is no data, skip II
            ind_time = strcmp(raw_multi_file(II).chanNames,'time');
            if flag == 0
                raw_combined = raw_multi_file(II);
                raw_combined.rate = consts.DAQ.downsampled_rate;
                [t_resampled,y_resampled] = resample_w_time(raw_multi_file(II).rate,consts.DAQ.downsampled_rate,raw_multi_file(II).data(:,ind_time),raw_multi_file(II).data);
                y_resampled(:,ind_time) = t_resampled';
                raw_combined.data = interp1(t_resampled,y_resampled,new_time);
                flag = 1;
            else
                raw_combined.chanNames = [raw_combined.chanNames, raw_multi_file(II).chanNames(~ind_time)];
                raw_combined.tare_applied = [raw_combined.tare_applied, raw_multi_file(II).tare_applied(~ind_time)];
                [t_resampled,y_resampled] = resample_w_time(raw_multi_file(II).rate,consts.DAQ.downsampled_rate,...
                    raw_multi_file(II).data(:,ind_time),raw_multi_file(II).data(:,~ind_time));
                raw_combined.data = [raw_combined.data, interp1(t_resampled,y_resampled,new_time')];
            end

        end
    end
    if exist('raw_combined')
        temp = calibrate_data(cal,raw_combined);
        temp_fieldnames = fieldnames(temp.td);
        for II = 1:length(temp_fieldnames)
            results(KK).td.(temp_fieldnames{II}) = temp.td.(temp_fieldnames{II});
        end
        results(KK).rate = temp.rate;
    end
    results(KK).td.Time = new_time';

end

% Loop through each field and concatenate the arrays from all structs
results_all = results(1);
field = fieldnames(results_all.td);
for II = 2:length(results)
    for JJ = 1:length(field)
        results_all.td.(field{JJ}) = [results_all.td.(field{JJ}); results(II).td.(field{JJ})];
    end
end