function results_all = process_data_folder(files,cal,consts)
% files contains absolute and relative path information
% cal is an array of calibration structs
% consts is a struct with project specific values

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
        dataFiles = dir(fullfile(files.absolute_data_dir,files.relative_experiment_dir,sprintf('data_%d%s',files.filename_timestamp,consts.data.file_name_conventions{II})));
    else
        dataFiles = dir(fullfile(files.absolute_data_dir,files.relative_experiment_dir,consts.data.file_name_conventions{II}));
    end

    if isempty(dataFiles)
        raw_multi_file(II).rate = NaN;
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
file_ind = strcmp(consts.data.file_name_conventions,'*rotor_strain*.tdms');
master_time =  raw_multi_file(file_ind).data(:,strcmp(raw_multi_file(file_ind).chanNames,'time'));
temp = find(diff(master_time)>1);
segment_start_ind = [1,temp + 1]; % indcies where a segment of continous data starts
segment_end_ind = [temp, length(master_time)]; % indcies where a segment of continous data ends

for KK = 1:length(segment_start_ind)
    start_time = master_time(segment_start_ind(KK));
    end_time = master_time(segment_end_ind(KK));

    new_time = start_time:1/consts.DAQ.downsampled_rate:end_time;

    %% Calibrate each file type individually
    % if it is the encoder file, it needs the reset commands from the RPM
    % sensor
    for II = 1:length(raw_multi_file)
        if consts.data.calibrate_before_resample(II) & ~isempty(raw_multi_file(II).chanNames)
            calibrated_data(II) = calibrate_data(cal,raw_multi_file(II));
            calibrated_fields = fieldnames(calibrated_data(II).td);
            ind_time = strcmp(calibrated_fields,'Time');
            for JJ = 1:length(calibrated_fields)
                if strcmp(calibrated_fields{JJ},'theta_encoder') % digitally resample counter channel
                    if ~isfield(calibrated_data(8).td,'resetTimes')
                        error('calibrated_data(8) doesn''t have reset times')
                    end
                    tr = calibrated_data(8).td.resetTimes;
                    tenc = calibrated_data(II).td.Time;
                    theta = calibrated_data(II).td.theta_encoder;
                    if theta(end) == 0
                        theta(end) = NaN;
                    end
                    j = 1;
                    for i = 1:length(tr)
                        % Skip if tr(i) is outside the range of tenc
                        if tr(i) < tenc(1) || tr(i) > tenc(end)
                            continue;
                        end

                        % Move j forward until tenc(j) is greater than or equal to tr(i)
                        while j < length(tenc) && tenc(j) < tr(i)
                            j = j + 1;
                        end

                        if ~isnan(theta(j)) && ~isnan(theta(j-1))
                            % Check if tr(i) exactly matches tenc(j)
                            if tr(i) == tenc(j)
                                % Perform special operation when tr(i) == tenc(j)
                                theta(j:end) = theta(j:end) - theta(j);
                            else
                                % Store indices on either side of tr(i)
                                idx1 = j - 1;
                                idx2 = j;
                                theta_interp = theta(idx1) + (tr(i) - tenc(idx1)) * (theta(idx2) - theta(idx1)) / (tenc(idx2) - tenc(idx1));
                                theta(j:end) = theta(j:end) - theta_interp;
                            end
                        end
                        
                    end
                  
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
                if ~strcmp(calibrated_fields{JJ},'Time')
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
        if ~consts.data.calibrate_before_resample(II) & ~isempty(raw_multi_file(II).chanNames) % is there is no data, skip II
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
    temp = calibrate_data(cal,raw_combined);
    temp_fieldnames = fieldnames(temp.td);
    for II = 1:length(temp_fieldnames)
        results(KK).td.(temp_fieldnames{II}) = temp.td.(temp_fieldnames{II});
    end
    results(KK).rate = temp.rate;
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