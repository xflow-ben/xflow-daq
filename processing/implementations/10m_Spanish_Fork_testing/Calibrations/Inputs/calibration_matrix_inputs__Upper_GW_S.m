function [calib,crosstalk] = calibration_matrix_inputs__Upper_GW_S(consts)

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Upper_GW_S'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper GW S'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of Upper_GW_S Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_GW_S';
calib(calibNum).applied_load_scaling = consts.lbf_to_N;
calib(calibNum).output_units = 'N'; 
