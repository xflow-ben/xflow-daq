function [calib,crosstalk] = calibration_matrix_inputs__up_yoke_My_pos(consts)

moment_distance_MY = consts.cali.arm_moment_distance;

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Upper_Yoke_Fx' 'Upper_Yoke_Fz' 'Upper_Yoke_My'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper Yoke Fx' 'Upper Yoke Fz' 'Upper Yoke My'}; % Names of load channels of intrest
crosstalk.output_units = {'N','N','N-m'}; % Units of load channels after calibration
calibNum = 0; % Initiate counting varible

%% Calibration of Upper yoke +Fx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_+My';
calib(calibNum).applied_load_scaling = [consts.units.lbf_to_N; 0; 0];

%% Calibration of Upper yoke -Fx Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_arm_-My';
calib(calibNum).applied_load_scaling = [-consts.units.lbf_to_N; 0; 0];
calib(calibNum).corrections.load = [8 12];

%% Calibration of upper yoke +Fz Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Uppper_arm_Fz';
calib(calibNum).applied_load_scaling = [0; consts.units.lbf_to_N; 0];

%% Calibration of upper yoke +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_yoke_+My';
calib(calibNum).applied_load_scaling = [0; consts.units.lbf_to_N; consts.units.lbf_to_N*moment_distance_MY];

