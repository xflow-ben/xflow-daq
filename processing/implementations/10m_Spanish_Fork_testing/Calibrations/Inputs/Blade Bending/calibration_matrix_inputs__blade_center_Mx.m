function [calib,crosstalk] = calibration_matrix_inputs__blade_center_Mx(consts)

%% Sources for applied load scaling
% https://structx.com/Beam_Formulas_026.html
% https://structx.com/Beam_Formulas_007.html

overhang = 1.92319; % Distance from the hinge to the end of the pultrusion (where load was applied for upper and lower) [m]
L = 5.69362; % Distance between the hinges [m]
d = 0.635; % distance from blade center to guage location in the direction of the upper joint [m]
w = (1.375+1/32)*consts.inch_to_m; % thickness of load application jig [m]
a = overhang - w/2;

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Center_Blade_Mx'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Center Blade Bend'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible

%% Calibration of Blade Center Mx Pulling in +Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_center_+Fy';
calib(calibNum).applied_load_scaling = consts.lbf_to_N*(L/2-d)/2;
calib(calibNum).output_units = 'N-m'; 

%% Calibration of Blade Center Mx Pulling in -Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_center_-Fy';
calib(calibNum).applied_load_scaling = -consts.lbf_to_N*(L/2-d)/2;
calib(calibNum).output_units = 'N-m'; 
% calib(calibNum).corrections.load = [2 27.5];

