function [calib,crosstalk] = calibration_matrix_inputs__blade_bending(consts)

%% Sources for applied load scaling
% https://structx.com/Beam_Formulas_026.html
% https://structx.com/Beam_Formulas_007.html

overhang = consts.blade.overhang_without_winglets; % Distance from the hinge to the end of the pultrusion (where load was applied for upper and lower) [m]
L = consts.blade.hinge_to_hinge_distance; % Distance between the hinges [m]
d = consts.guages.blade_center_to_guage_distance; % distance from blade center to guage location in the direction of the upper joint [m]
w = consts.cali.jig_thickness; % thickness of load application jig [m]
a = overhang - w/2;

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Upper_Blade_Mx','Center_Blade_Mx','Lower_Blade_Mx'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper Blade Bend','Center Blade Bend','Lower Blade bend'}; % Names of load channels of intrest
crosstalk.output_units = {'N-m','N-m','N-m'}; 
calibNum = 0; % Initiate counting varible

%% Calibration of Blade Upper Mx Pulling in +Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_upper_+Fy';
calib(calibNum).applied_load_scaling = -consts.units.lbf_to_N*[a; a*(L/2+d)/L; 0];

%% Calibration of Blade Upper Mx Pulling in -Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_upper_-Fy';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N*[a; a*(L/2+d)/L; 0];

%% Calibration of Blade Center Mx Pulling in +Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_center_+Fy';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N*[0; (L/2-d)/2; 0];

%% Calibration of Blade Center Mx Pulling in -Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_center_-Fy';
calib(calibNum).applied_load_scaling = -consts.units.lbf_to_N*[0; (L/2-d)/2; 0];
% calib(calibNum).corrections.load = [2 27.5];

%% Calibration of Blade Lower Mx Pulling in +Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_lower_+Fy';
calib(calibNum).applied_load_scaling = -consts.units.lbf_to_N*[0; a*(L/2-d)/L; a];

%% Calibration of Blade Lower Mx Pulling in -Y 
calibNum = calibNum + 1;
calib(calibNum).folder = 'rotor_segment_lower_-Fy';
calib(calibNum).applied_load_scaling = consts.units.lbf_to_N*[0; a*(L/2-d)/L; a];
