function [calib,crosstalk] = calibration_matrix_inputs__up_arm_root_Mz(consts)

moment_distance = 235.7563*consts.inch_to_m; % distance for computing moment, lower arm, THIS VALUE IS TO THE ROTOR AXIS OF ROTATION [m]
moment_distance_MZ = 32*consts.inch_to_m;
%% Crosstalk grouping high level info
crosstalk.loads_names = {'Upper_Arm_Mz'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper Arm Mz'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of Upper Arm Root Mz #1 Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_Mz_+y';
calib(calibNum).applied_load_scaling = consts.lbf_to_N*moment_distance_MZ;
calib(calibNum).output_units = 'N-m'; 

%% Calibration of Upper Arm Root Mz #2 Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_Mz_-y';
calib(calibNum).applied_load_scaling = consts.lbf_to_N*moment_distance_MZ;
calib(calibNum).output_units = 'N-m'; 
