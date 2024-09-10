function [calib,crosstalk] = calibration_matrix_inputs__low_yoke_My(consts)

moment_distance_MY = consts.cali.arm_moment_distance;
%% Crosstalk grouping high level info

crosstalk.loads_names = {'Lower_Yoke_My'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower Yoke My'}; % Names of load channels of intrest
crosstalk.output_units = {'N-m'}; % Units of load channels after calibration
calibNum = 0; % Initiate counting varible

%% Calibration of lower yoke +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_yoke_+My';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N*moment_distance_MY;

%% Calibration of lower yoke -My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_yoke_-My';
calib(calibNum).applied_load_scaling = -consts.units.lbf_to_N*moment_distance_MY;

