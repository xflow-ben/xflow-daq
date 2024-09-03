function [calib,crosstalk] = calibration_matrix_inputs__low_arm_root_Mz(consts)

moment_distance = 5.61304498; % Distance from hub face to lower arm-blade hinge, along 0.3 chord spanwise arm line [m]
moment_distance_MZ = 32*consts.inch_to_m;
%% Crosstalk grouping high level info
crosstalk.loads_names = {'Lower_Arm_Mz'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower Arm Mz'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of Lower Arm Root Mz #1 Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_Mz_+y';
calib(calibNum).applied_load_scaling = consts.lbf_to_N*moment_distance_MZ;
calib(calibNum).output_units = 'N-m'; 

%% Calibration of Lower Arm Root Mz #2 Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_Mz_-y';
calib(calibNum).applied_load_scaling = consts.lbf_to_N*moment_distance_MZ;
calib(calibNum).corrections.load = [8 0];
calib(calibNum).output_units = 'N-m'; 
