function [calib,crosstalk] = calibration_matrix_inputs__tower_top_moments(consts)

tol = 0.2; % Tolerance for comparison of solutions between pairs of guy wire foundations for plumb bob location[m]

% Pull locations
V_B_pull_r = 11.83*consts.units.inch_to_m; % Distance of pull location from system vertical-axis [m]
V_B_pull_z = 84.23*consts.units.inch_to_m; % Distance of pull location from tower top (z = 0) [m]

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Tower_Top_Mx','Tower_Top_My'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper GW N','Upper GW S','Upper GW E','Upper GW W',...
    'Lower GW N','Lower GW S','Lower GW E','Lower GW W',...
    'Torque Arm Left','Torque Arm Right','Nacelle Bending A','Nacelle Bending B'}; % Names of load channels of intrest
crosstalk.output_units = {'N-m','N-m'};
calibNum = 0; % Initiate counting varible

%% V-B, H-B
calibNum = calibNum + 1;
calib(calibNum).folder = 'tower\V-B_H-B';

% Manually recorded information
E_GW_dist = [42*12 + 4, 42*12 + 5, 42*12 + 11, 43*12]*consts.units.inch_to_m;
S_GW_dist = [17*12 + 2, 17*12 + 2.5, 17*12 + 3.5, 17*12 + 7]*consts.units.inch_to_m;
W_GW_dist = [16*12 + 11, 16*12 + 11.5, 16*12 + 10.5, 16*12 + 11]*consts.units.inch_to_m;
horiz_angle = [(-9.3+-10.6)/2, (-10.1+-11.5)/2,...
    (-10.4+-11.0)/2, (-9.1+-9.1)/2];
manual_applied_loads = [0, 0; 1804, 1804; 924, 923; 0, 0; 1133, 1136; 1969, 1964; 0, 0];

% Calculated inputs
[~, theta] = get_tower_pull_coordinate(E_GW_dist,S_GW_dist,W_GW_dist,consts.foundation.E_GW__SW_bolt,consts.foundation.S_GW__NW_bolt,consts.foundation.W_GW__SE_bolt,tol);
moment_arm = V_B_pull_z - V_B_pull_r*sind(horiz_angle);
calib(calibNum).applied_load_scaling = cosd(horiz_angle).*[cosd(theta).*moment_arm; sind(theta).*moment_arm];
calib(calibNum).corrections.load = [(1:length(manual_applied_loads))', mean(manual_applied_loads,2)];

%% V-B, H-C
calibNum = calibNum + 1;
calib(calibNum).folder = 'tower\V-B_H-C';

% Manually recorded information
E_GW_dist = [18*12 + 0, 18*12 + 1, 18*12 + 0, 17*12 + 11]*consts.units.inch_to_m;
S_GW_dist = [15*12 + 6.5, 15*12 + 4, 15*12 + 6, 15*12 + 6]*consts.units.inch_to_m;
W_GW_dist = [37*12 + 10, 37*12 + 5, 37*12 + 8, 37*12 + 7]*consts.units.inch_to_m;
horiz_angle = [-11.9, -12.3, -11.8, -11.9];
manual_applied_loads = [0, 0; 1982, 1979; 815, 808.5; 0, 0; 975, 976; 2043.5, 2045; 0, 0];

% Calculated inputs
[~, theta] = get_tower_pull_coordinate(E_GW_dist,S_GW_dist,W_GW_dist,consts.foundation.E_GW__SW_bolt,consts.foundation.S_GW__NE_bolt,consts.foundation.W_GW__SE_bolt,tol);
moment_arm = V_B_pull_z - V_B_pull_r*sind(horiz_angle);
calib(calibNum).applied_load_scaling = cosd(horiz_angle).*[cosd(theta).*moment_arm; sind(theta).*moment_arm];
calib(calibNum).corrections.load = [(1:length(manual_applied_loads))', mean(manual_applied_loads,2)];

%% -Z_pos_1
calibNum = calibNum + 1;
calib(calibNum).folder = 'installed_rotor\-Z_pos_1';

% Manually recorded information
N_GW_dist = (37*12 + 0)*consts.units.inch_to_m;
S_GW_dist = (18*12 + 9)*consts.units.inch_to_m;
W_GW_dist = (14*12 + 2)*consts.units.inch_to_m;

% Calculated inputs
[~, theta] = get_tower_pull_coordinate(N_GW_dist,S_GW_dist,W_GW_dist,consts.foundation.N_GW__SW_bolt,consts.foundation.S_GW__NW_bolt,consts.foundation.W_GW__SE_bolt,tol);
moment_arm = consts.rotor.radius;
calib(calibNum).applied_load_scaling = [cosd(theta)*moment_arm; sind(theta)*moment_arm];

%% -Z_pos_2
calibNum = calibNum + 1;
calib(calibNum).folder = 'installed_rotor\-Z_pos_2';

% Manually recorded information
N_GW_dist = (37*12 + 7)*consts.units.inch_to_m;
S_GW_dist = (17*12 + 7)*consts.units.inch_to_m;
E_GW_dist = (15*12 + 10)*consts.units.inch_to_m;

% Calculated inputs
[~, theta] = get_tower_pull_coordinate(N_GW_dist,S_GW_dist,E_GW_dist,consts.foundation.N_GW__SE_bolt,consts.foundation.S_GW__NE_bolt,consts.foundation.E_GW__SW_bolt,tol);
moment_arm = consts.rotor.radius;
calib(calibNum).applied_load_scaling = [cosd(theta)*moment_arm; sind(theta)*moment_arm];

