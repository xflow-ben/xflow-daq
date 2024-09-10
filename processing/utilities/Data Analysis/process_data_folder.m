function results = process_data_folder(files,cal,consts)
% files contains absolute and relative path information
% cal is an array of calibration structs
% consts is a struct with project specific values

% Initialize the data name conventions which will be processed
if sum(strcmp(fieldnames(files),'data_name_conventions')) == 0
    files.data_name_conventions = consts.data.data_file_name_conventions;
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

for II = 1:length(files.data_name_conventions)
    count = 0;
    pattern = strrep(files.data_name_conventions{II}, '*', '.*');
    for JJ = 1:length(tareList)
        if ~isempty(regexp(tareList{JJ},pattern,'once'))
            count = count + 1;
            tare_TDMS = readTDMS(tareList{JJ},fullfile(files.absolute_data_dir,files.relative_tare_dir));
            tare_td = convertTDMStoXFlowFormat(tare_TDMS);
            tare(II).data(count,:) = median(tare_td.data,1);
            if count == 1
                tare(II).data_name_conventions = files.data_name_conventions{II};
                tare(II).chanNames = tare_td.chanNames;
            end
        end
    end
end


%% Process data files
% Loop through all the data files and run them through process_data_point

% Find file names that start with the specified naming convensions
for II = 1:length(files.data_name_conventions)
    II/length(files.data_name_conventions)
    dataFiles = dir(fullfile(files.absolute_data_dir,files.relative_experiment_dir,files.data_name_conventions{II}));
    for JJ = 1:length(dataFiles)
        files.dataFile = dataFiles(JJ).name;
        results{II,JJ} = process_data_point(files,cal,consts,tare(II));
    end
end
%
% %% Create sd
% % Create sd (statistical data): do N-second averaging here (e.g. 10 second). Split data up into chunks,
% % do the averaging
% sd = struct();
%
% N = 10; % Length of chuncks in seconds
% count = 0;
% fields = fieldnames(td);
%
% for i = 1:length(td)
%     % Determine the number of chunks
%     start_time = min(td(i).time);
%     end_time = max(td(i).time);
%     num_chunks = ceil((end_time - start_time) / N);
%
%     % Loop through each chunk
%     for j = 1:num_chunks
%         % Find the start and end times for this chunk
%         chunk_start = start_time + (j-1) * N;
%         chunk_end = start_time + j * N;
%
%         % Find indices of data points within this chunk
%         indices = find(td(i).time >= chunk_start & td(i).time < chunk_end);
%
%         if ~isempty(indices)
%             count = count + 1;
%
%             % Compute the average for each field in the struct
%             for k = 1:numel(fields)
%                 if ~strcmp(fields{k}, 'time')
%                     % Extract the chunk data
%                     chunk_data = td(i).(fields{k})(indices);
%                     sd.(fields{k})(count) = mean(chunk_data);
%                 end
%
%             end
%         end
%     end
% end
%
% %% Create bd
% % Create bd (binned data): Bin data by Re and TSR and compute bin average and std
% bd = struct();

end