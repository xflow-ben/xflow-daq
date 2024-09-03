function [calib,crosstalk] = calibration_matrix_inputs__up_yoke(consts)

moment_distance_MY_pos = 32*consts.inch_to_m;
moment_distance_MY_neg = 34*consts.inch_to_m;

%% Crosstalk grouping high level info

crosstalk.loads_names = {'Upper_Yoke_Fx' 'Upper_Yoke_Fz' 'Upper_Yoke_My'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper Yoke Fx' 'Upper Yoke Fz' 'Upper Yoke My'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of Upper yoke +Fx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_calib_+My';
calib(calibNum).applied_load_scaling = [consts.lbf_to_N; 0; 0];
%% Calibration of Upper yoke -Fx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_calib_-My';
calib(calibNum).applied_load_scaling = [-consts.lbf_to_N; 0; 0];
%% Calibration of lower yoke +Fz Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_yoke_calib_+Fz';
calib(calibNum).applied_load_scaling = [0; consts.lbf_to_N; 0];

%% Calibration of lower yoke +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_yoke_calib_+My';
calib(calibNum).applied_load_scaling = [0; consts.lbf_to_N; consts.lbf_to_N*moment_distance_MY_pos];
%% Calibration of lower yoke -My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_yoke_calib_-My';
calib(calibNum).applied_load_scaling = [0; consts.lbf_to_N; -consts.lbf_to_N*moment_distance_MY_neg];
