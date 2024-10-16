clear all
% close all
clc

%% Assign data folder
files.absolute_data_dir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\';
files.relative_experiment_dir = 'operating_uncompressed';
files.relative_tare_dir = 'operating\10_10_24\tare';
files.relative_results_save_dir = 'operating_uncompressed\processed';

%% Load calibration struct
load('C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_16_10_24.mat')

%% Load constants
consts = XFlow_Spanish_Fork_testing_constants();

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
unique_filename_timestamps = unique(extractedValues);


%% Process data with the same filename timestamps
for II = 1:length(unique_filename_timestamps)
    II/length(unique_filename_timestamps)
    save_dir = fullfile(files.absolute_data_dir,files.relative_results_save_dir);
    save_name = fullfile(save_dir,sprintf('operating_results_%d.mat',unique_filename_timestamps(II)));
    if ~exist(save_name,'file')
        files.filename_timestamp = unique_filename_timestamps(II);
        results = process_data_folder(files,cal,consts);
        results.td = calculate_XFlow_Spanish_Fork_quantities(results.td,consts);
        results = calculate_sd(results,consts);

        %% Remove td data if it is not a data type flagged to be saved
        if strcmp(consts.data.save_types, 'td') == 0
            results = rmfield(results,'td');
        end

        %% Save results
        if II == 1 && ~exist(save_dir,'dir')
            mkdir(save_dir)
        end
        save(save_name,'results', '-v7.3')
        pause(5)
        clear results
    end
end

