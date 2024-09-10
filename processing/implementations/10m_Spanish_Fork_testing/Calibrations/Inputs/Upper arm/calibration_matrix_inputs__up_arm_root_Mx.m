function [calib,crosstalk] = calibration_matrix_inputs__up_arm_root_Mx(consts)

moment_distance = consts.upperArm.span; % Distance from hub face to upper arm-blade hinge, along 0.3 chord spanwise arm line [m]

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Upper_Arm_Mx'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper Arm Mx'}; % Names of load channels of intrest
crosstalk.output_units = {'N-m'}; % Units of load channels after calibration
calibNum = 0; % Initiate counting varible

%% Calibration of Upper Arm Root +Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'upper_arm_+Mx';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N*moment_distance;

%% Calibration of Upper Arm Root -Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_-Mx';
calib(calibNum).applied_load_scaling = -consts.units.lbf_to_N*moment_distance;
calib(calibNum).corrections.load = [2 27.5];

