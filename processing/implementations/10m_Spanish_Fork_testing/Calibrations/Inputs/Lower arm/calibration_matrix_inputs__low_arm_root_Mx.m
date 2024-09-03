function [calib,crosstalk] = calibration_matrix_inputs__low_arm_root_Mx(consts)

moment_distance = 235.7563*consts.inch_to_m; % distance for computing moment, lower arm, THIS VALUE IS TO THE ROTOR AXIS OF ROTATION [m]

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Lower_Arm_Mx'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower Arm Mx'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of Lower Arm Root +Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_+Mx';
calib(calibNum).applied_load_scaling = consts.lbf_to_N*moment_distance;
calib(calibNum).output_units = 'N-m'; 

%% Calibration of Lower Arm Root -Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_-Mx';
calib(calibNum).applied_load_scaling = -consts.lbf_to_N*moment_distance;
calib(calibNum).output_units = 'N-m'; 
