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

for II =1:length(files)
    TDMS = readTDMS(files(II).name,fullfile(verify.absolute_data_path,verify.relative_data_folder));
    d = convertTDMStoXFlowFormat(TDMS);

    %% Extract applied load
    applied_load_ind = find(strcmp({TDMS.property.name},verify.applied_load_var_name));
    applied_load(II) = verify.applied_load_scaling*str2double(TDMS.property(applied_load_ind).value);

    %% Calculate measured load
    for JJ = 1:length(verify.data.measurment_channels)
        ind = find(strcmp(d.chanNames,verify.data.measurment_channels{JJ}));
        cal = load(fullfile(verify.data.absolute_cali_path,verify.data.relative_cali_struct{JJ}));
        temp = fieldnames(cal); % This is needed since some cal structs have different top level fieldnames
        cal_fieldname = temp{1};

        % Find the relevant element in the calibration struct for applying
        % the calibration
        cali_ind = [];
        for KK = 1:length(cal.(cal_fieldname))
            if sum(strcmp(cal.(cal_fieldname)(KK).output_names,verify.data.physical_loads{JJ})) > 0
                cali_ind = KK;
            end
        end
        if isempty(cali_ind)
            error(sprintf('%s is not a calibrated channel name in the cal struct found at %s',...
                verify.data.physical_loads{JJ},fullfile(verify.data.absolute_cali_path,verify.data.relative_cali_struct{JJ})))
        end

        % Apply calibration
        out = apply_calibration(d.data,d.chanNames,cal.(cal_fieldname)(cali_ind));

        % Extract median of physical load of intrest
        physical_load(JJ) = median(out.(verify.data.physical_loads{JJ}));

    end
    calculated_load_pre_tare(II) = verify.func(physical_load);

end

%% Apply simple tare
tare = median(calculated_load_pre_tare(applied_load==0));
calculated_load = calculated_load_pre_tare - tare;
