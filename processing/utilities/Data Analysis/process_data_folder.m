function [td,sd,bd] = process_data_folder(directory,cal,consts,TDMS_prefix)
% %% Load and average tares
% % gather up the tare files in directory,
% % loop through the tare files
% % create average tare values for the channels indicated in
% % tare.applicableChannels
% % put this into some kind of structure
% % pass into AW_Process_point where those values will be subtracted from the
% % raw data
%
% % Get a list of all files and directories in the current directory
% tarefiles = dir(fullfile(directory,'tare*.mat'));
% % Load the first matching file if it exists
% if isempty(tarefiles)
%     error('No tare files found.');
% end
%
% % extract all tares into struct array
% for i = 1:length(tarefiles)
%     in = load(fullfile(directory,tarefiles(i).name));
%     all_tares(i) = in.tare;
% end
%
% % compress tares into an array which holds the average tare value for each
% % channel
% for i = 1:length(all_tares(1).median)
%     chunk_lg = 0;
%     average_tare.median(i) = 0;
%     for j = 1:length(all_tares)
%         if all_tares(j).applicableChannels(i)
%             chunk_lg = chunk_lg + 1;
%             average_tare.median(i) = average_tare.median(i) + all_tares(j).median(i);
%         end
%     end
%     average_tare.median(i) = average_tare.median(i)/chunk_lg;
% end
% average_tare.median(isnan(average_tare.median)) = 0;
% average_tare.applicableChannels = all_tares(1).applicableChannels;
% average_tare.metaData = all_tares(1).metaData;

%% Process data files
% Loop through all the ata files and run them through AW_process_point

% Find file names that start with the specified naming convensions
if nargin > 3
    name_conventions = TDMS_prefix;
else
    name_conventions = consts.data.data_file_name_conventions;
end
for II = 1:length(name_conventions)
    II
    dataFiles = dir(fullfile(directory,name_conventions{II}));
    for JJ = 1:length(dataFiles)
        td{II}(JJ) = process_data_point(fullfile(directory,dataFiles(JJ).name),cal,consts)
    end
end
%
% %% Create sd
% % Create sd (statistical data): do N-second averaging here (e.g. 10 second). Split data up into chunks,
% % do the averaging
sd = struct();
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
bd = struct();

end