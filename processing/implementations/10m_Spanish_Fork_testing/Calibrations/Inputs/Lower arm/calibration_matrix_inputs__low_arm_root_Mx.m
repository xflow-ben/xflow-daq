function [calib,crosstalk] = calibration_matrix_inputs__low_arm_root_Mx(consts)

moment_distance = consts.lowerArm.span; % Distance from hub face to lower arm-blade hinge, along 0.3 chord spanwise arm line [m]

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Lower_Arm_Mx'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower Arm Mx'}; % Names of load channels of intrest
crosstalk.output_units = {'N-m'}; % Units of load channels after calibration
calibNum = 0; % Initiate counting varible

%% Calibration of Lower Arm Root +Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_+Mx';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N*moment_distance;

%% Calibration of Lower Arm Root -Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_-Mx';
calib(calibNum).applied_load_scaling = -consts.units.lbf_to_N*moment_distance;
