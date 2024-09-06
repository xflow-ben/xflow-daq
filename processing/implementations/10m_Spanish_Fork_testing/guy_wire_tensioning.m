clear all
close all
clc

%% Assign data folder
files.absolute_data_dir = 'E:\loads_data\';
files.relative_experiment_dir = 'GW_tensioning'; % This is relative to files.absolute_data_dir
files.relative_tare_dir= 'tares'; % This is relative to files.absolute_data_dir
files.data_name_conventions = {'guy_wire_cal_towerBaseStrain_*.tdms'};

%% Load calibration struct
load('C:\Users\XFlow Energy\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_05_09_24.mat')

%% Load constants
consts = XFlow_Spanish_Fork_testing_constants();

%% Process data folder

results = process_data_folder(files,cal,consts);

%% Plot
fields = fieldnames(results.td);

% only plot most recent tensioning attempt
figure
count = 0;
II = length(results.td);
for JJ = 1:length(fields)
    if ~sum(strcmp(fields{JJ},'time'))
        count = count + 1;
        plot(results.td(II).(fields{JJ})/consts.units.lbf_to_N)
        hold on
        legStr{count} = fields{JJ};
    end
end
legend(legStr,'Location','best','Interpreter','none')

ylabel('Tension [lbf]')
