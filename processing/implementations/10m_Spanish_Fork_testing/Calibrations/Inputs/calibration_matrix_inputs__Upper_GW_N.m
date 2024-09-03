function [calib,crosstalk] = calibration_matrix_inputs__Upper_GW_N(consts)

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Upper_GW_N'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper GW N'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of Upper_GW_N Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_GW_N';
calib(calibNum).applied_load_scaling = consts.lbf_to_N;
calib(calibNum).corrections.load = [9 0];
calib(calibNum).output_units = 'N'; 
