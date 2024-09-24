function [applied_load, calculated_load] = calibration_verification(verify)


% verify is a struct with the following elements
% - verify.absolute_data_path is the absolute path to the data directory
% - verify.relative_data_folder is the relative path from
% verify.absolute_data_path to the relevant data folder
% - verify.tdms_filter is the tdms filter for the tdms files which should be
% read
% - verify.func is a function handle to a function for how the data should be
% processed to calculate the relevant load
% - verify.data.measurment_channels is a cell array of the load channels which are used
% in this verification of the applied loads
% - verify.data.physical_loads is a cell array of the physical loads of
% intrest which is produced by the calibration
% - verify.data.relative_cali_struct is a cell array of relative paths to the
% calibration structs from verify.data.absolute_cali_path which apply to
% each of the load channels in verify.data.chanNames


files = dir(fullfile(verify.absolute_data_path,verify.relative_data_folder,verify.tdms_filter));

if isempty(files)
    error(sprintf('No files with the format %s found in %s',verify.tdms_filter,fullfile(verify.absolute_data_path,verify.relative_data_folder)))
end

%% Extract applied load
for II =1:length(files)
    TDMS = readTDMS(files(II).name,fullfile(verify.absolute_data_path,verify.relative_data_folder));
    d = convertTDMStoXFlowFormat(TDMS);

    applied_load_ind = find(strcmp({TDMS.property.name},verify.applied_load_var_name));
    applied_load(II) = verify.applied_load_scaling*str2double(TDMS.property(applied_load_ind).value);
end

%% Create tareList in the data directory
tareList = {files(applied_load == 0).name};
save(fullfile(verify.absolute_data_path,verify.relative_data_folder,'tareList.mat'),'tareList')

%% Process data folder
files = struct;
files.absolute_data_dir = '';
files.relative_experiment_dir =  fullfile(verify.absolute_data_path,verify.relative_data_folder); % This is relative to files.absolute_data_dir
files.relative_tare_dir = files.relative_experiment_dir; % This is relative to files.absolute_data_dir

load(verify.data.absolute_cali_path)
results = process_data_folder(files,cal,verify.consts);

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
            error
        end
        physical_load(II) = mean(results(ind,KK).sd.(verify.data.physical_loads{II}).mean);
    end
    calculated_load(KK) = verify.func(physical_load);
end