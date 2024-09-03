function [calib,crosstalk] = calibration_matrix_inputs__low_yoke_Fz(consts)

%% Crosstalk grouping high level info

crosstalk.loads_names = {'Lower_Yoke_Fz'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower Yoke Fz'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible


%% Calibration of lower yoke +Fz Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_yoke_Fz';
calib(calibNum).applied_load_scaling = consts.lbf_to_N;
calib(calibNum).output_units = 'N'; 

