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

%% Plot


% figure
% hold on
% % plot(results.td.TSR,results.td.Cp_gen,'.')
% plot(results.td.theta_encoder,'.')
% plot(results.td.theta_sensor,'.')


figure
hold on
plot(results.td.tau_aero_all_segments,'.')
plot(results.td.tau_gen,'.')

