function [calib,crosstalk] = calibration_matrix_inputs__up_arm_root_Mx(consts)

moment_distance = 5.49192071; % Distance from hub face to upper arm-blade hinge, along 0.3 chord spanwise arm line [m]
moment_distance_MZ = 32*consts.inch_to_m;
%% Crosstalk grouping high level info
crosstalk.loads_names = {'Upper_Arm_Mx'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper Arm Mx'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of Upper Arm Root +Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'upper_arm_+Mx';
calib(calibNum).applied_load_scaling = consts.lbf_to_N*moment_distance;
calib(calibNum).output_units = 'N-m'; 

%% Calibration of Upper Arm Root -Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_-Mx';
calib(calibNum).applied_load_scaling = -consts.lbf_to_N*moment_distance;
calib(calibNum).output_units = 'N-m'; 
calib(calibNum).corrections.load = [2 27.5];

