clear all
close all
clc

%% Assign data folder
files.absolute_data_dir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\';
files.relative_experiment_dir = 'sample_data';
files.relative_tare_dir = 'operating\10_10_24\tare';
%% Load calibration struct
load('C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_11_10_24.mat')

%% Load constants
consts = XFlow_Spanish_Fork_testing_constants();

%% Process data folder
results = process_data_folder(files,cal,consts);
results.td = calculate_XFlow_Spanish_Fork_quantities(results.td,consts);
results = calculate_sd(results,consts);

%% Remove td data if it is not a data type flagged to be saved
if strcmp(consts.data.save_types, 'td') == 0
    results = rmfield(results,'td');
end

%% Plot

% filter = results.td.acc_sensor < .03;
figure
hold on
plot(results.td.TSR,-results.td.Cp_gen,'.')
plot(results.td.TSR,-results.td.Cp_aero_all_segments,'.')

figure
hold on
plot(results.td.Time,results.td.omega_encoder,'.')
plot(results.td.Time,results.td.omega_sensor,'.')

figure
hold on
plot(results.td.Time,results.td.theta_encoder,'.')
plot(results.td.Time,results.td.theta_sensor,'.')


figure
hold on
plot(results.td.Time,results.td.tau_aero_all_segments,'.')
plot(results.td.Time,results.td.tau_gen,'.')
ylabel('Torque [N-m]')
legend('Calculated from Arm Root Moments', ...
    'Calculated from Torque Arms')
grid on
box on
