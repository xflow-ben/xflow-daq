
%% Assign data folder
files = struct;
files.absolute_data_dir = '';
files.relative_experiment_dir =  'E:\loads_data\GW_tensioning'; % This is relative to files.absolute_data_dir
files.relative_tare_dir = 'E:\loads_data\tares'; % This is relative to files.absolute_data_dir


%% Load calibration struct
load('C:\Users\XFlow Energy\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_05_09_24.mat')

%% Load constants
consts = XFlow_Spanish_Fork_testing_constants();

% Put any values you want to override here
consts.data.file_name_conventions = {'*gw_strain*.tdms'};
consts.data.save_types = {'sd'};
consts.data.N = 0.2; % sd averaging time [s]

%% Process data folder
results = process_data_folder(files,cal,consts);

%% Plot
close all
figure(1); hold on
figure(2); hold on
legStr_upper = {};
legStr_lower = {};
for II = length(results)
    fields = fieldnames(results(II).sd);
    % only plot most recent tensioning attempt
    lower_count = 0;
    upper_count = 0;
    for JJ = 1:length(fields)
        if ~sum(strcmp(fields{JJ},'time')) 
            if contains(fields{JJ},'Lower')
                figure(1); hold on;
                lower_count = lower_count + 1;
                plot(results(II).sd.(fields{JJ}).mean/consts.units.lbf_to_N)
                legStr_lower{lower_count} = fields{JJ};
                legend(legStr_lower,'Location','best','Interpreter','none')
            elseif contains(fields{JJ},'Upper')
                figure(2); hold on;
                upper_count = upper_count + 1;
                plot(results(II).sd.(fields{JJ}).mean/consts.units.lbf_to_N)
                legStr_upper{upper_count} = fields{JJ};
                legend(legStr_upper,'Location','best','Interpreter','none')
            end
            
        end
    end

    ylabel('Tension [lbf]')
end