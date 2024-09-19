function [calib,crosstalk] = calibration_matrix_inputs__tower_top_pulls(consts)

% Inputs are in nacelle-tower interfance coordiante system [m]

% Guy wire foundations
E = [10, -1];  % x-y coordinates of east guy wire foundation point [m]
W = [-10, -1];  % x-y coordinates of west guy wire foundation point [m]
S = [0, -10];  % x-y coordinates of south guy wire foundation point [m]

% Pull locations
pull_A = [-1,-1,0]; % Coordiante of location where the pull occured [m]
pull_B = [-1,-1,0]; % Coordiante of location where the pull occured [m]
pull_C = [-1,-1,10]; % Coordiante of location where the pull occured [m]

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

