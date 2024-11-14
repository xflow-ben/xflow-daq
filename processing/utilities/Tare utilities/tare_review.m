clear all
% function tare_review(tareList)

% This function loads the tares from a tareList and displays information
% about them. This can be used to identify bad tares or tends in the tares.

load('X:\Experiments and Data\20 kW Prototype\Loads_Data\operating_uncompressed\tareList.mat')

files.absolute_data_dir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\';
files.relative_experiment_dir = 'operating_uncompressed';
files.relative_tare_dir = files.relative_experiment_dir;
files.relative_results_save_dir = 'operating_uncompressed\processed';

%% Load constants
consts = XFlow_Spanish_Fork_testing_constants();

% Create tare struct
tare(1:length(consts.data.file_name_conventions)) = struct();

for II = 1:length(consts.data.file_name_conventions)
    count = 0;
    pattern = strrep(consts.data.file_name_conventions{II}, '*', '.*');
    for JJ = 1:length(tareList)
        if ~isempty(regexp(tareList{JJ},pattern,'once'))
            count = count + 1;
            tare_TDMS = readTDMS(tareList{JJ},fullfile(files.absolute_data_dir,files.relative_tare_dir));
            tare_td = convertTDMStoXFlowFormat(tare_TDMS,consts.data.default_rates(II));
            tare(II).mean(count,:) = mean(tare_td.data);
            tare(II).max(count,:) = max(tare_td.data);
            tare(II).min(count,:) = min(tare_td.data);
            tare(II).std(count,:) = std(tare_td.data);

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

%% Plot

for II = 1:length(consts.data.file_name_conventions)
    for JJ = 1:length(tare(II).max)
        plot(tare(II).mean(:,JJ)./tare(II).mean(1,JJ))
        hold on
    end
end