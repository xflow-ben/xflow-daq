function [calib,crosstalk] = calibration_matrix_inputs__up_yoke_My(consts)

moment_distance_MY_pos = 32*consts.inch_to_m;
moment_distance_MY_neg = 32*consts.inch_to_m;
%% Crosstalk grouping high level info

crosstalk.loads_names = {'Upper_Yoke_My'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper Yoke My'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of lower yoke +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_yoke_+My';
calib(calibNum).applied_load_scaling = consts.lbf_to_N*moment_distance_MY_pos;
calib(calibNum).output_units = 'N-m'; 

%% Calibration of lower yoke -My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_yoke_-My';
calib(calibNum).applied_load_scaling = -consts.lbf_to_N*moment_distance_MY_neg;
calib(calibNum).output_units = 'N-m'; 

