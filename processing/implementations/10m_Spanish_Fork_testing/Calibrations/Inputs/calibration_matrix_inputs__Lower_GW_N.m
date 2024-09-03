function [calib,crosstalk] = calibration_matrix_inputs__Lower_GW_N(consts)

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Lower_GW_N'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower GW N'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of Lower_GW_N Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_GW_N';
calib(calibNum).applied_load_scaling = consts.lbf_to_N;
calib(calibNum).output_units = 'N'; 
