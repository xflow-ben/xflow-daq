function [calib,crosstalk] = calibration_matrix_inputs__blade_upper_Mx(consts)

%% Sources for applied load scaling
% https://structx.com/Beam_Formulas_026.html
% https://structx.com/Beam_Formulas_007.html

overhang = consts.blade.overhang_without_winglets; % Distance from the hinge to the end of the pultrusion (where load was applied for upper and lower) [m]
L = consts.blade.hinge_to_hinge_distance; % Distance between the hinges [m]
d = consts.guages.blade_center_to_guage_distance; % distance from blade center to guage location in the direction of the upper joint [m]
w = consts.cali.jig_thickness; % thickness of load application jig [m]
a = overhang - w/2;

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Upper_Blade_Mx'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper Blade Bend'}; % Names of load channels of intrest
crosstalk.output_units = {'N-m'}; 
calibNum = 0; % Initiate counting varible

%% Calibration of Blade Upper Mx Pulling in +Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_upper_+Fy';
calib(calibNum).applied_load_scaling = -consts.units.lbf_to_N*a;

%% Calibration of Blade Upper Mx Pulling in -Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_upper_-Fy';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N*a;

