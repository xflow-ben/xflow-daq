function [calib,crosstalk] = calibration_matrix_inputs__low_yoke_Fx(consts)

%% Crosstalk grouping high level info

crosstalk.loads_names = {'Lower_Yoke_Fx'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower Yoke Fx'}; % Names of load channels of intrest
crosstalk.output_units = {'N'}; % Units of load channels after calibration
calibNum = 0; % Initiate counting varible

%% Calibration of Lower yoke +Fx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_+My';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N;

%% Calibration of Lower yoke -Fx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_-My';
calib(calibNum).applied_load_scaling = -consts.units.lbf_to_N;

