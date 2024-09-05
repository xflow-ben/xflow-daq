function [calib,crosstalk] = calibration_matrix_inputs__blade_lower_Mx(consts)

%% Sources for applied load scaling
% https://structx.com/Beam_Formulas_026.html
% https://structx.com/Beam_Formulas_007.html
a = 1.92319; % Distance from the hinge to the end of the pultrusion (where load was applied for upper and lower) [m]
L = 5.69362; % Distance between the hinges [m]

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Lower_Blade_Mx'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower Blade bend'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of Blade Lower Mx Pulling in +Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_lower_+Fy';
calib(calibNum).applied_load_scaling = -consts.lbf_to_N*a;
calib(calibNum).output_units = 'N-m'; 

%% Calibration of Blade Lower Mx Pulling in -Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_lower_-Fy';
calib(calibNum).applied_load_scaling = consts.lbf_to_N*a;
calib(calibNum).output_units = 'N-m'; 
% calib(calibNum).corrections.load = [2 27.5];

