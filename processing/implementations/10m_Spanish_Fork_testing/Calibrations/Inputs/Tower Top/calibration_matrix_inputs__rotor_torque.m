function [calib,crosstalk] = calibration_matrix_inputs__rotor_torque(consts)

tol = 0.2; % Tolerance for comparison of solutions between pairs of guy wire foundations for plumb bob location[m]

%% Crosstalk grouping high level info
crosstalk.loads_names = {'tau_gen'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Torque Arm Left','Torque Arm Right'}; % Names of load channels of intrest
crosstalk.output_units = {'N-m'};
calibNum = 0; % Initiate counting varible

%% Rotor torque, -X
calibNum = calibNum + 1;
calib(calibNum).folder = 'installed_rotor\-X';

% Calculated inputs
calib(calibNum).applied_load_scaling = -cosd(consts.blade.pitch_30)*consts.rotor.radius*consts.units.lbf_to_N;

%% Rotor torque, +X
calibNum = calibNum + 1;
calib(calibNum).folder = 'installed_rotor\+X';

% Calculated inputs
calib(calibNum).applied_load_scaling = cosd(consts.blade.pitch_30)*consts.rotor.radius*consts.units.lbf_to_N;
