clear all
close all
clc

%% Assign data folder
files.absolute_data_dir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\';
files.relative_experiment_dir = 'sample_data';

%% Load calibration struct
load('C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_10_10_24.mat')

%% Load constants
consts = XFlow_Spanish_Fork_testing_constants();

%% Process data folder
results = process_data_folder(files,cal,consts);

%% Plot
TSR = results.td.omega_sensor*consts.rotor.radius./results.td.U_primary;
Cp = results.td.Rotor_Torque.*results.td.omega_sensor./(0.5*1*consts.turb.A*results.td.U_primary.^3);
figure
hold on
plot(TSR,Cp,'.')
