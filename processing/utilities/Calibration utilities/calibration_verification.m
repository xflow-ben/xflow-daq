function [applied_load, calculated_load] = calibration_verification(verify)


% verify is a struct with the following elements
% - verify.absolute_data_path is the absolute path to the data directory
% - verify.relative_data_folder is the relative path from
% verify.absolute_data_path to the relevant data folder
% - verify.tdms_filter is the tdms filter for the tdms files which should be
% read
% - verify.func is a function handle to a function for how the data should be
% processed to calculate the relevant load
% - verify.data.physical_loads is a cell array of the physical loads of
% intrest which is produced by the calibration
% - verify.data.relative_cali_struct is a cell array of relative paths to the
% calibration structs from verify.data.absolute_cali_path which apply to
% each of the load channels in verify.data.chanNames

verify.consts.isCalibration = 1; % This script is only for verfication cases, which have the same data strucutres as calibrations
 
data_files = dir(fullfile(verify.absolute_data_path,verify.relative_data_folder,verify.tdms_filter));

if isempty(data_files)
    error(sprintf('No files with the format %s found in %s',verify.tdms_filter,fullfile(verify.absolute_data_path,verify.relative_data_folder)))
end


%% Extract applied load
% This is done first so we can generate the tare list when using
% process_data_folder
for II =1:length(data_files)
    TDMS = readTDMS(data_files(II).name,fullfile(verify.absolute_data_path,verify.relative_data_folder));
    d = convertTDMStoXFlowFormat(TDMS);

    applied_load_ind = find(strcmp({TDMS.property.name},verify.applied_load_var_name));
    applied_load(II) = verify.applied_load_scaling*str2double(TDMS.property(applied_load_ind).value);
end

%% Create tareList in the data directory
tareList = {data_files(applied_load == 0).name};
save(fullfile(verify.absolute_data_path,verify.relative_data_folder,'tareList.mat'),'tareList')

%% Process data folder
files = struct;
files.absolute_data_dir = '';
files.relative_experiment_dir =  fullfile(verify.absolute_data_path,verify.relative_data_folder); % This is relative to files.absolute_data_dir
files.relative_tare_dir = files.relative_experiment_dir; % This is relative to files.absolute_data_dir

load(verify.data.absolute_cali_path)
for II =1:length(data_files)
    files.filename_timestamp = str2num(data_files(II).name(end-8:end-5));
    temp = process_data_folder(files,cal,verify.consts);
    verify.consts.data.N = NaN; % sd averaging time [s]
    results(II) = calculate_sd(temp,verify.consts);
end

%% Calculate load of intrest

for KK = 1:size(results,2) % for each file in the data folder
    physical_load = [];
    for II = 1:length(verify.data.physical_loads)
        ind = [];
        for JJ = 1:size(results,1)
            if isstruct(results(JJ,1).sd) & sum(flexibleStrCmp(verify.data.physical_loads{II},fieldnames(results(JJ,1).sd))) > 0
                ind = JJ;
            end
        end
        if isempty(ind)
            error(sprintf('Physical load of intrest, %s,not found in the data',verify.data.physical_loads{II}))
        end
        if length(results(ind,KK).sd.(verify.data.physical_loads{II}).mean)>1
            error('Set consts.data.N = NaN so that sd averages the entire file')
        end
        physical_load(II) = results(ind,KK).sd.(verify.data.physical_loads{II}).mean;
    end
    calculated_load(KK) = verify.func(physical_load);
end