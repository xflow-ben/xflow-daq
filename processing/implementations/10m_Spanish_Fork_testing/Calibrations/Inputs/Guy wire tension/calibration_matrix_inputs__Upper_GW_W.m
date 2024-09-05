function [calib,crosstalk] = calibration_matrix_inputs__Upper_GW_W(consts)

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Upper_GW_W'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper GW W'}; % Names of load channels of intrest
crosstalk.output_units = {'N'}; % Units of load channels after calibration
calibNum = 0; % Initiate counting varible

%% Calibration of Upper_GW_W Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Upper_GW_W';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N;
