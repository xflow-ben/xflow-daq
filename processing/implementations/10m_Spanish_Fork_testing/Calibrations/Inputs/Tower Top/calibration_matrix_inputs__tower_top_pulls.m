function [calib,crosstalk] = calibration_matrix_inputs__tower_top_pulls(consts)

% Inputs are in nacelle-tower interfance coordiante system [m]

% Guy wire foundations
E_GW__SW_bolt = [-16,-291.9]*consts.units.inch_to_m;  % x-y coordinates of east guy wire foundation, SW bolt point [m]
S_GW__NE_bolt = [-294.4,-4]*consts.units.inch_to_m;  % x-y coordinates of south guy wire foundation, NE bolt point [m]
S_GW__NW_bolt = [-294.4,4]*consts.units.inch_to_m;  % x-y coordinates of south guy wire foundation, NW bolt point [m]
W_GW__SE_bolt = [-20.7,286.7]*consts.units.inch_to_m;  % x-y coordinates of west guy wire foundation, SE bolt point [m]
N_GW__SW_bolt = [290.5,10.5]*consts.units.inch_to_m;  % x-y coordinates of north guy wire foundation, SW bolt point [m]
N_GW__SE_bolt = [290.5,-10.5]*consts.units.inch_to_m;  % x-y coordinates of north guy wire foundation, SE bolt point [m]

% Pull locations
pull_height_nacelle = 618*consts.units.inch_to_m; % Height of location where nacelle was pulled from [m]
pull_height_hub = 707.25*consts.units.inch_to_m; % Height of location where hub was pulled from [m]

tol = 0.5; % Tolerance for comparison of solutions between pairs of guy wire foundations for plumb bob location[m]

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Tower_Top_Fx','Tower_Top_Fy','Tower_Top_Mx','Tower_Top_My'}; % Names of physical loads of intrest which are applied during calibrations
% crosstalk.channel_names = {'Upper Blade Bend','Center Blade Bend','Lower Blade bend'}; % Names of load channels of intrest
crosstalk.output_units = {'N','N','N-m','N-m'}; 
calibNum = 0; % Initiate counting varible

%% V-A, H-B 
calibNum = calibNum + 1;
% calib(calibNum).folder = 'rotor_segment_upper_+Fy';
% calib(calibNum).applied_load_scaling = -consts.units.lbf_to_N*[a; a*(L/2+d)/L; 0];

%% V-A, H-C 
calibNum = calibNum + 1;
% calib(calibNum).folder = 'rotor_segment_upper_+Fy';
% calib(calibNum).applied_load_scaling = -consts.units.lbf_to_N*[a; a*(L/2+d)/L; 0];

