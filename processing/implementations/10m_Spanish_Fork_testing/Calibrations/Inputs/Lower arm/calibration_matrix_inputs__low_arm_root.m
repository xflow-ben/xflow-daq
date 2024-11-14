function [calib,crosstalk] = calibration_matrix_inputs__low_arm_root(consts)

moment_distance = consts.lowerArm.span; % Distance from hub face to lower arm-blade hinge, along 0.3 chord spanwise arm line [m]
moment_distance_MZ = consts.cali.arm_moment_distance;

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Lower_Arm_Mx','Lower_Arm_My','Lower_Arm_Mz'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower Arm Mx','Lower Arm My','Lower Arm Mz'}; % Names of load channels of intrest
crosstalk.output_units = {'N-m','N-m','N-m'}; % Units of load channels after calibration
calibNum = 0; % Initiate counting varible

%% Calibration of Lower Arm Root +Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_+Mx';
calib(calibNum).applied_load_scaling = [consts.units.lbf_to_N*moment_distance; 0; 0];

%% Calibration of Lower Arm Root -Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_-Mx';
calib(calibNum).applied_load_scaling = [-consts.units.lbf_to_N*moment_distance; 0; 0];

%% Calibration of Lower Arm Root +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_+My';
calib(calibNum).applied_load_scaling = [0 ;consts.units.lbf_to_N*moment_distance; 0];

%% Calibration of Lower Arm Root +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_-My';
calib(calibNum).applied_load_scaling = [0 ;-consts.units.lbf_to_N*moment_distance; 0];

%% Calibration of Lower Arm Root Mz #1 Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_Mz_+y';
scale_temp = [-consts.units.lbf_to_N*moment_distance; 0; consts.units.lbf_to_N*moment_distance_MZ];
scale_temp = repmat(scale_temp,[1,12]);
scale_temp(1,:) = scale_temp(1,:).*(mod(1:12, 2) * 2 - 1);
calib(calibNum).applied_load_scaling = scale_temp;

%% Calibration of Lower Arm Root Mz #2 Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_Mz_-y';
scale_temp = [consts.units.lbf_to_N*moment_distance; 0 ;consts.units.lbf_to_N*moment_distance_MZ];
scale_temp = repmat(scale_temp,[1,12]);
scale_temp(1,:) = scale_temp(1,:).*(mod(1:12, 2) * 2 - 1);
calib(calibNum).applied_load_scaling = scale_temp;
calib(calibNum).corrections.load = [8 0];
