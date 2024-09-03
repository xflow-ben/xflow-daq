function [calib,crosstalk] = calibration_matrix_inputs__low_yoke(consts)

moment_distance_MY = 32*consts.inch_to_m;
%% Crosstalk grouping high level info

crosstalk.loads_names = {'Lower_Yoke_Fx' 'Lower_Yoke_Fz' 'Lower_Yoke_My'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower Yoke Fx' 'Lower Yoke Fz' 'Lower Yoke My'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of Lower yoke +Fx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_calib_+My';
calib(calibNum).applied_load_scaling = [consts.lbf_to_N; 0; 0];
%% Calibration of Lower yoke -Fx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_calib_-My';
calib(calibNum).applied_load_scaling = [-consts.lbf_to_N; 0; 0];
%% Calibration of lower yoke +Fz Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_yoke_calib_+Fz';
calib(calibNum).applied_load_scaling = [0; consts.lbf_to_N; 0];

%% Calibration of lower yoke +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_yoke_calib_+My';
calib(calibNum).applied_load_scaling = [0; consts.lbf_to_N; consts.lbf_to_N*moment_distance_MY];
%% Calibration of lower yoke -My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_yoke_calib_-My';
calib(calibNum).applied_load_scaling = [0; consts.lbf_to_N; -consts.lbf_to_N*moment_distance_MY];
