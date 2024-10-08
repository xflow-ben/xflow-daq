function [calib,crosstalk] = calibration_matrix_inputs__up_arm_root(consts)

moment_distance = consts.upperArm.span; % Distance from hub face to upper arm-blade hinge, along 0.3 chord spanwise arm line [m]
moment_distance_MZ = consts.cali.arm_moment_distance;

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Upper_Arm_Mx','Upper_Arm_My','Upper_Arm_Mz'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper Arm Mx','Upper Arm My','Upper Arm Mz'}; % Names of load channels of intrest
crosstalk.output_units = {'N-m','N-m','N-m'}; % Units of load channels after calibration
calibNum = 0; % Initiate counting varible

%% Calibration of Upper Arm Root +Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'upper_arm_+Mx';
calib(calibNum).applied_load_scaling = [consts.units.lbf_to_N*moment_distance; 0; 0];

%% Calibration of Upper Arm Root -Mx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_-Mx';
calib(calibNum).applied_load_scaling = [-consts.units.lbf_to_N*moment_distance; 0; 0];
calib(calibNum).corrections.load = [2 27.5];

%% Calibration of Upper Arm Root +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_+My';
calib(calibNum).applied_load_scaling = [0 ;consts.units.lbf_to_N*moment_distance; 0];

%% Calibration of Upper Arm Root +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_-My';
calib(calibNum).applied_load_scaling = [0 ;-consts.units.lbf_to_N*moment_distance; 0];
calib(calibNum).corrections.load = [8 12];

%% Calibration of Upper Arm Root Mz #1 Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_Mz_+y';
scale_temp = [-consts.units.lbf_to_N*moment_distance; 0; consts.units.lbf_to_N*moment_distance_MZ];
scale_temp = repmat(scale_temp,[1,12]);
scale_temp(1,:) = scale_temp(1,:).*(mod(1:12, 2) * 2 - 1);
calib(calibNum).applied_load_scaling = scale_temp;

%% Calibration of Upper Arm Root Mz #2 Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_Mz_-y';
scale_temp = [consts.units.lbf_to_N*moment_distance; 0 ; consts.units.lbf_to_N*moment_distance_MZ];
scale_temp = repmat(scale_temp,[1,12]);
scale_temp(1,:) = scale_temp(1,:).*(mod(1:12, 2) * 2 - 1);
calib(calibNum).applied_load_scaling = scale_temp;
