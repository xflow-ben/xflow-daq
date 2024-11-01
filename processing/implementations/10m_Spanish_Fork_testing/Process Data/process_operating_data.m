clear all
% close all
clc


%% Assign data folder
files.absolute_data_dir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\';
files.relative_experiment_dir = 'operating_uncompressed';
files.relative_tare_dir = files.relative_experiment_dir;
files.relative_results_save_dir = 'operating_uncompressed\processed';

%% Load calibration struct
load('C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_30_10_24.mat')

%% Load constants
consts = XFlow_Spanish_Fork_testing_constants();
consts.debugMode = 1;

%% Extract data groupings
% Grouping is a set of files with the same embedded timestamp in the
% filename

% Get a list of all files in the directory
fileList = dir(fullfile(files.absolute_data_dir,files.relative_experiment_dir, 'data_*.tdms'));

% Initialize an array to store the extracted values
extractedValues = [];

% Loop through the files and extract the filename timestamps
for i = 1:length(fileList)
    fileName = fileList(i).name;
    % Extract the filename timestamps part using regular expression
    tokens = regexp(fileName, 'data_(\d+)_*', 'tokens');
    if ~isempty(tokens)
        % Convert the extracted value to a number and store it
        extractedValues(end + 1) = str2double(tokens{1}{1});
    end
end

% Get the set of unique filename timestamp values
all_filename_timestamps = unique(extractedValues);

%% Determine if any of these filenames correspond to tares
tare_count = 0;
data_files_count = 0;
for II = 1:length(all_filename_timestamps)
    dataFiles = dir(fullfile(files.absolute_data_dir,files.relative_experiment_dir,sprintf('data_%d%s',all_filename_timestamps(II),consts.data.file_name_conventions{1})));
    if length(dataFiles) == 2
        % Load data
        tdms = readTDMS(dataFiles(1).name,fullfile(files.absolute_data_dir,files.relative_experiment_dir));
        [raw, ~, ~] = convertTDMStoXFlowFormat(tdms,consts.data.default_rates(1));
        if size(raw.data,1) == 98304
            tare_count = tare_count + 1;
            tareList{tare_count} = sprintf('data_%d_nacelle_strain_0000.tdms',all_filename_timestamps(II));
            tare_count = tare_count + 1;
            tareList{tare_count} = sprintf('data_%d_nacelle_strain_0001.tdms',all_filename_timestamps(II));
            tare_count = tare_count + 1;
            tareList{tare_count} = sprintf('data_%d_rotor_strain_0000.tdms',all_filename_timestamps(II));
            tare_count = tare_count + 1;
            tareList{tare_count} = sprintf('data_%d_rotor_strain_0001.tdms',all_filename_timestamps(II));
        else
            data_files_count = data_files_count + 1;
            data_filename_timestamps(data_files_count) = all_filename_timestamps(II);
        end
    else
        data_files_count = data_files_count + 1;
        data_filename_timestamps(data_files_count) = all_filename_timestamps(II);
    end
end
save(fullfile(files.absolute_data_dir,files.relative_tare_dir,'tareList.mat'),'tareList')

%% Process data with the same filename timestamps
if consts.debugMode
    forLoopInd = 6;
else
    forLoopInd = 1:length(data_filename_timestamps);
end
for II = forLoopInd
    II/length(data_filename_timestamps)
    save_dir = fullfile(files.absolute_data_dir,files.relative_results_save_dir);
    save_name = fullfile(save_dir,sprintf('operating_results_%d.mat',data_filename_timestamps(II)));
    save_name_td = fullfile(save_dir,sprintf('operating_results_td_%d.mat',data_filename_timestamps(II)));
    % if ~exist(save_name_td,'file')
        files.filename_timestamp = data_filename_timestamps(II);
        results = process_data_folder(files,cal,consts);
        % results.td = calculate_XFlow_Spanish_Fork_quantities(results.td,consts);
        % results = calculate_sd(results,consts);

        %% Save results
        if II == 1 && ~exist(save_dir,'dir')
            mkdir(save_dir)
        end
        if consts.debugMode
            save_name_td = fullfile(save_dir,sprintf('DEBUG_operating_results_td_%d.mat',data_filename_timestamps(II)));
        else
        save_name_td = fullfile(save_dir,sprintf('operating_results_td_%d.mat',data_filename_timestamps(II)));
        end
        save(save_name_td,'results', '-v7.3')
        % pause(5)
        % % Remove td data if it is not a data type flagged to be saved
        % if strcmp(consts.data.save_types, 'td') == 0
        %     results = rmfield(results,'td');
        % end
        % 
        % save(save_name,'results', '-v7.3')
        
        clear results
    % end
end

