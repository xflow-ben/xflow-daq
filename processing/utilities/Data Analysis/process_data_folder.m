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


%% Process data files
% Loop through all the data files and run them through process_data_point

% Find file names that start with the specified naming convensions
for II = 1:length(consts.data.file_name_conventions)
    dataFiles = dir(fullfile(files.absolute_data_dir,files.relative_experiment_dir,consts.data.file_name_conventions{II}));
    for JJ = 1:length(dataFiles)
        files.dataFile = dataFiles(JJ).name;
        results(II,JJ) = process_data_point(files,cal,consts,tare(II));
    end
end

%% Create sd (statistical data)
N_days = consts.data.N/(24*60*60); % Get sd averaging time in days

if sum(strcmp(consts.data.save_types, 'sd'))
    % Create sd (statistical data): do N-second averaging here (e.g. 10 second).
    % Split data up into chunks, do the averaging
    sd = struct();

    for II = 1:size(results,1)
        for JJ = 1:size(results,2)
            count = 0;
            if ~isempty(results(II,JJ).td)
                fields = fieldnames(results(II,JJ).td);

                % Determine the number of chunks
                start_time = min(results(II,JJ).td.time);
                end_time = max(results(II,JJ).td.time);
                num_chunks = ceil((end_time - start_time) / N_days);

                % Loop through each chunk
                for KK = 1:num_chunks
                    % Find the start and end times for this chunk
                    chunk_start = start_time + (KK-1) * N_days;
                    chunk_end = start_time + KK * N_days;

                    % Find indices of data points within this chunk
                    indices = find(results(II,JJ).td.time >= chunk_start & results(II,JJ).td.time < chunk_end);

                    if ~isempty(indices)
                        count = count + 1;

                        % Compute the average for each field in the struct
                        for LL = 1:numel(fields)
                            if ~strcmp(fields{LL}, 'time')
                                % Extract the chunk data
                                chunk_data = results(II,JJ).td.(fields{LL})(indices);
                                results(II,JJ).sd.(fields{LL}).mean(count) = mean(chunk_data);
                                results(II,JJ).sd.(fields{LL}).std(count) = std(chunk_data);
                                results(II,JJ).sd.(fields{LL}).min(count) = min(chunk_data);
                                results(II,JJ).sd.(fields{LL}).max(count) = max(chunk_data);

                            end

                        end
                    end
                end
            end
        end
    end
end

%% Remove td data if it is not a data type flagged to be saved

if strcmp(consts.data.save_types, 'td') == 0
    results = rmfield(results,'td');
end
