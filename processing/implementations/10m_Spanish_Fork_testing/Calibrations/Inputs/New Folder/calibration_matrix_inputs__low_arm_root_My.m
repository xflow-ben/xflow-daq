function [calib,crosstalk] = calibration_matrix_inputs__low_arm_root_My(consts)

moment_distance = 235.7563*consts.inch_to_m; % distance for computing moment, lower arm, THIS VALUE IS TO THE ROTOR AXIS OF ROTATION [m]
moment_distance_MZ = 32*consts.inch_to_m;
%% Crosstalk grouping high level info
crosstalk.loads_names = {'Lower_Arm_My'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower Arm My'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible


%% Calibration of Lower Arm Root +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_calib_+My';
calib(calibNum).applied_load_scaling = consts.lbf_to_N*moment_distance;

%% Calibration of Lower Arm Root +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_calib_-My';
calib(calibNum).applied_load_scaling = -consts.lbf_to_N*moment_distance;

