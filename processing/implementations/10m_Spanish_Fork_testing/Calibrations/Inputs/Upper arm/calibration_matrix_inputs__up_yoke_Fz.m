function [calib,crosstalk] = calibration_matrix_inputs__up_yoke_Fz(consts)

%% Crosstalk grouping high level info

crosstalk.loads_names = {'Upper_Yoke_Fz'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper Yoke Fz'}; % Names of load channels of intrest
crosstalk.output_units = {'N'}; % Units of load channels after calibration
calibNum = 0; % Initiate counting varible


%% Calibration of lower yoke +Fz Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Uppper_arm_Fz';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N;

