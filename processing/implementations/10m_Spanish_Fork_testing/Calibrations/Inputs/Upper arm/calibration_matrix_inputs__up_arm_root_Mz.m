function [calib,crosstalk] = calibration_matrix_inputs__up_arm_root_Mz(consts)

moment_distance = consts.upperArm.span; % Distance from hub face to upper arm-blade hinge, along 0.3 chord spanwise arm line [m]
moment_distance_MZ = consts.cali.arm_moment_distance;

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Upper_Arm_Mz'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper Arm Mz'}; % Names of load channels of intrest
crosstalk.output_units = {'N-m'}; % Units of load channels after calibration
calibNum = 0; % Initiate counting varible

%% Calibration of Upper Arm Root Mz #1 Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_Mz_+y';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N*moment_distance_MZ;

%% Calibration of Upper Arm Root Mz #2 Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_Mz_-y';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N*moment_distance_MZ;
