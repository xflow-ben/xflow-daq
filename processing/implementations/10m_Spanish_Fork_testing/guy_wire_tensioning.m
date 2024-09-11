clear all
close all
clc

%% Assign data folder
files.absolute_data_dir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data';
files.relative_experiment_dir = 'GW_tensioning'; % This is relative to files.absolute_data_dir
files.relative_tare_dir= 'tares'; % This is relative to files.absolute_data_dir


%% Load calibration struct
load('C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_05_09_24.mat')

%% Load constants
consts = XFlow_Spanish_Fork_testing_constants();
% Put any values you want to override here
% consts.data.file_name_conventions = {'guy_wire_cal_towerBaseStrain_*.tdms'};
consts.data.save_types = {'sd'};
consts.data.N = 1; % sd averaging time [s]

%% Process data folder
results = process_data_folder(files,cal,consts);

%% Plot
figure
for II = length(results)
    fields = fieldnames(results(II).sd);
    % only plot most recent tensioning attempt
    count = 0;
    JJ = length(results(II).sd);
    for KK = 1:length(fields)
        if ~sum(strcmp(fields{KK},'time'))
            count = count + 1;
            plot(results(II).sd(JJ).(fields{KK})/consts.units.lbf_to_N,'o')
            hold on
            legStr{count} = fields{KK};
        end
    end
    legend(legStr,'Location','best','Interpreter','none')
    ylabel('Tension [lbf]')
end