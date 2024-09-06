clear all
close all
clc

%% Assign data folder
files.absolute_data_dir = 'E:\loads_data\';
files.relative_experiment_dir = 'GW_tensioning'; % This is relative to files.absolute_data_dir
files.relative_tare_dir= 'tares'; % This is relative to files.absolute_data_dir
files.data_name_conventions = {'guy_wire_cal_towerBaseStrain_*.tdms','lower_arm_cal_BladeRTDs_*.tdms'};

%% Load calibration struct
load('C:\Users\XFlow Energy\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_05_09_24.mat')

%% Load constants
consts = XFlow_Spanish_Fork_testing_constants();

%% Process data folder

[td,sd,bd] = process_data_folder(files,cal,consts);

%% Plot
% plot(sd.TSR,sd.cP,'.')
% grid on
% box on
% xlabel('TSR')
% ylabel('Cp')

for II = 1:length(td{1})

    plot(td{1}(II).Lower_Arm_Mx)
    hold on
end

