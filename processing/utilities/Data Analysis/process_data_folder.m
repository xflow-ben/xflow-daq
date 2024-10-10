function results = process_data_folder(files,cal,consts)
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
            tare_td = convertTDMStoXFlowFormat(tare_TDMS);
            tare(II).data(count,:) = median(tare_td.data,1);
            if count == 1
                tare(II).data_name_conventions = consts.data.file_name_conventions{II};
                tare(II).chanNames = tare_td.chanNames;
            end
        end
    end
end

if isempty(fieldnames(tare))
    % error('No tares were loaded')
end

%% Loop through all the data files, apply their tares, and then combine data of the same filetype

% Find file names that start with the specified naming convensions
for II = 1:length(consts.data.file_name_conventions)
    dataFiles = dir(fullfile(files.absolute_data_dir,files.relative_experiment_dir,consts.data.file_name_conventions{II}));
    if isempty(dataFiles)
        raw_multi_file(II).rate = NaN;
    else
        for JJ = 1:length(dataFiles)
            % Load data
            tdms = readTDMS(dataFiles(JJ).name,fullfile(files.absolute_data_dir,files.relative_experiment_dir));
            raw = convertTDMStoXFlowFormat(tdms);

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
start_time = raw_multi_file(file_ind).data(1,strcmp(raw_multi_file(file_ind).chanNames,'time'));
end_time = raw_multi_file(file_ind).data(end,strcmp(raw_multi_file(file_ind).chanNames,'time'));
new_rate = 1/512;

new_time = start_time:new_rate:end_time;

for II = 1:length(raw_multi_file)
    if ~isnan(raw_multi_file(II).rate)
        ind_time = strcmp(raw_multi_file(II).chanNames,'time');
        if II == 1
            raw_combined = raw_multi_file(II);
            raw_combined.data = interp1(raw_multi_file(II).data(:,ind_time),...
                raw_multi_file(II).data,new_time);
        else
            raw_combined.chanNames = [raw_combined.chanNames, raw_multi_file(II).chanNames(~ind_time)];
            raw_combined.tare_applied = [raw_combined.tare_applied, raw_multi_file(II).tare_applied(~ind_time)];
            
            raw_combined.data = [raw_combined.data, interp1(raw_multi_file(II).data(:,ind_time),...
                raw_multi_file(II).data(:,~ind_time),new_time')];
        end
    end
end
results = calibrate_data(cal,raw_combined);
results.td.Time = new_time;

%% Create sd (statistical data)
N_days = consts.data.N/(24*60*60); % Get sd averaging time in days (our td.time is in datenum which is in units days)

if sum(strcmp(consts.data.save_types, 'sd'))
    % Create sd (statistical data): do N-second averaging here (e.g. 10 second).
    % Split data up into chunks, do the averaging
    sd = struct();

    count = 0;
    fields = fieldnames(results.td);

    % Determine the number of chunks
    start_time = min(results.td.Time);
    end_time = max(results.td.Time);


    if isnan(consts.data.N)% no time span specified, so average the entire file
        N_days = end_time-start_time;
        num_chunks = 1;
    else
        num_chunks = ceil((end_time - start_time) / N_days);
    end


    % Loop through each chunk
    for KK = 1:num_chunks
        % Find the start and end times for this chunk
        chunk_start = start_time + (KK-1) * N_days;
        chunk_end = start_time + KK * N_days;

        % Find indices of data points within this chunk
        indices = find(results.td.Time >= chunk_start & results.td.Time < chunk_end);

        if ~isempty(indices)
            count = count + 1;

            % Compute the average for each field in the struct
            for LL = 1:numel(fields)
                if ~strcmp(fields{LL}, 'Time')
                    % Extract the chunk data statistics
                    chunk_data = results.td.(fields{LL})(indices);
                    results.sd.(fields{LL}).mean(count) = mean(chunk_data);
                    results.sd.(fields{LL}).std(count) = std(chunk_data);
                    results.sd.(fields{LL}).min(count) = min(chunk_data);
                    results.sd.(fields{LL}).max(count) = max(chunk_data);
                end
            end
        end
    end
end


%% Remove td data if it is not a data type flagged to be saved

if strcmp(consts.data.save_types, 'td') == 0
    results = rmfield(results,'td');
end
