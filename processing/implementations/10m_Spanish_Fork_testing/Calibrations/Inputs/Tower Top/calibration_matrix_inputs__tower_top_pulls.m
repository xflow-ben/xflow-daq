function [calib,crosstalk] = calibration_matrix_inputs__tower_top_pulls(consts)

% Inputs are in nacelle-tower interfance coordiante system [m]

% Guy wire foundations
E_GW__SW_bolt = [-16,-291.9]*consts.units.inch_to_m;  % x-y coordinates of east guy wire foundation, SW bolt point [m]
S_GW__NE_bolt = [-294.4,-4]*consts.units.inch_to_m;  % x-y coordinates of south guy wire foundation, NE bolt point [m]
S_GW__NW_bolt = [-294.4,4]*consts.units.inch_to_m;  % x-y coordinates of south guy wire foundation, NW bolt point [m]
W_GW__SE_bolt = [-20.7,286.7]*consts.units.inch_to_m;  % x-y coordinates of west guy wire foundation, SE bolt point [m]
% N_GW__SW_bolt = [290.5,10.5]*consts.units.inch_to_m;  % x-y coordinates of north guy wire foundation, SW bolt point [m]
% N_GW__SE_bolt = [290.5,-10.5]*consts.units.inch_to_m;  % x-y coordinates of north guy wire foundation, SE bolt point [m]

% Pull locations
tower_top_height = 618*consts.units.inch_to_m; 
hub_height = 707.25*consts.units.inch_to_m;

tol = 0.2; % Tolerance for comparison of solutions between pairs of guy wire foundations for plumb bob location[m]

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Tower_Top_Fx','Tower_Top_Fy','Tower_Top_Mx','Tower_Top_My'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Upper GW N','Upper GW S','Upper GW E','Upper GW W',...
    'Lower GW N','Lower GW S','Lower GW E','Lower GW W',...
    'Torque Arm Left','Torque Arm Right','Nacelle Bending A','Nacelle Bending B'}; % Names of load channels of intrest
crosstalk.output_units = {'N','N','N-m','N-m'};
calibNum = 0; % Initiate counting varible

% %% V-A, H-A
% calibNum = calibNum + 1;
% calib(calibNum).folder = 'V-A_H-A';
% dist(calibNum) = [];
% % calib(calibNum).applied_load_scaling = -consts.units.lbf_to_N*[a; a*(L/2+d)/L; 0];

%% V-A, H-B
calibNum = calibNum + 1;
calib(calibNum).folder = 'V-A_H-B';

% Manually recorded information
E_GW_dist = [39*12 + 11, 40*12 + 1, 40*12 + 3, 40*12 + 4]*consts.units.inch_to_m;
S_GW_dist = [16*12 + 6, 16*12 + 5.5, 16*12 + 7, 16*12 + 7]*consts.units.inch_to_m;
W_GW_dist = [16*12 + 9, 16*12 + 7 16*12 + 6, 16*12 + 6.5]*consts.units.inch_to_m;
angle = [0.5, 0.3,0.30, 0.50];
manual_applied_loads = [0, 0; 1957, 1951; 1177.5, 1182.5; 0, 0; 1171.2, 1179; 1885, 1882.5; 0, 0];

% Calculated inputs
theta = get_tower_pull_coordinate(E_GW_dist,S_GW_dist,W_GW_dist,E_GW__SW_bolt,W_GW__SE_bolt,S_GW__NW_bolt,tol);
calib(calibNum).applied_load_scaling = cosd(angle).*[sind(theta), cosd(theta), sind(theta)*tower_top_height, cosd(theta)*tower_top_height];
calib(calibNum).corrections.load = [(1:length(manual_applied_loads))', mean(manual_applied_loads,2)];


%% V-A, H-C
calibNum = calibNum + 1;
calib(calibNum).folder = 'V-A_H-C';

% Manually recorded information
E_GW_dist = [18*12 + 1, 18*12 + 7, 18*12 + 3, 18*12 + 9]*consts.units.inch_to_m;
S_GW_dist =[15*12 + 7, 15*12 + 1, 15*12 + 7, 15*12 + 6]*consts.units.inch_to_m;
W_GW_dist = [39*12 + 3, 39*12 + 2, 39*12 + 1, 39*12 + 1]*consts.units.inch_to_m;
angle = [2.8, 2.8, 2.1, 3];
manual_applied_loads = [0, 0; 0, 0; 1976.5, 1975.5; 965.5, 969.5; 0, 0; 0, 0; 880.5, 880.5; 2049, 2050; 0, 0];

% Calculated inputs
theta = get_tower_pull_coordinate(E_GW_dist,S_GW_dist,W_GW_dist,E_GW__SW_bolt,W_GW__SE_bolt,S_GW__NE_bolt,tol);
calib(calibNum).applied_load_scaling = cosd(angle).*[sind(theta), cosd(theta), sind(theta)*tower_top_height, cosd(theta)*tower_top_height];
calib(calibNum).corrections.load = [(1:length(manual_applied_loads))', mean(manual_applied_loads,2)];

%% V-B, H-B
calibNum = calibNum + 1;
calib(calibNum).folder = 'V-B_H-B';

% Manually recorded information
E_GW_dist = [42*12 + 4, 42*12 + 5, 42*12 + 11, 43*12]*consts.units.inch_to_m;
S_GW_dist =[17*12 + 2, 17*12 + 2.5, 17*12 + 3.5, 17*12 + 7 ]*consts.units.inch_to_m;
W_GW_dist = [16*12 + 11, 16*12 + 11.5, 16*12 + 10.5, 16*12 + 11 ]*consts.units.inch_to_m;
angle = [(-9.3+-10.6)/2, (-10.1+-11.5)/2,...
    (-10.4+-11.0)/2, (-9.1+-9.1)/2];
manual_applied_loads = [0, 0; 1804, 1804; 924, 923; 0, 0; 1133, 1136; 1969, 1964; 0, 0];

% Calculated inputs
theta = get_tower_pull_coordinate(E_GW_dist,S_GW_dist,W_GW_dist,E_GW__SW_bolt,W_GW__SE_bolt,S_GW__NW_bolt,tol);
calib(calibNum).applied_load_scaling = cosd(angle).*[sind(theta), cosd(theta), sind(theta)*tower_top_height, cosd(theta)*tower_top_height];
calib(calibNum).corrections.load = [(1:length(manual_applied_loads))', mean(manual_applied_loads,2)];

%% V-B, H-C
calibNum = calibNum + 1;
calib(calibNum).folder = 'V-B_H-C';

% Manually recorded information
E_GW_dist = [18*12 + 0, 18*12 + 1, 18*12 + 0, 17*12 + 11 ]*consts.units.inch_to_m;
S_GW_dist =[15*12 + 6.5, 15*12 + 4, 15*12 + 6, 15*12 + 6 ]*consts.units.inch_to_m;
W_GW_dist = [37*12 + 10, 37*12 + 5, 37*12 + 8, 37*12 + 7 ]*consts.units.inch_to_m;
angle =[-11.9, -12.3, -11.8, -11.9];
manual_applied_loads = [0, 0; 1982, 1979; 815, 808.5; 0, 0; 975, 976; 2043.5, 2045; 0, 0];

% Calculated inputs
theta = get_tower_pull_coordinate(E_GW_dist,S_GW_dist,W_GW_dist,E_GW__SW_bolt,W_GW__SE_bolt,S_GW__NE_bolt,tol);
calib(calibNum).applied_load_scaling = cosd(angle).*[sind(theta), cosd(theta), sind(theta)*tower_top_height, cosd(theta)*tower_top_height];
calib(calibNum).corrections.load = [(1:length(manual_applied_loads))', mean(manual_applied_loads,2)];


%% V-A, H-A
% calibNum = calibNum + 1;
% calib(calibNum).folder = 'V-A_H-A';

% % Manually recorded information
% angle =[0.8, 0.8];
% manual_applied_loads = [0, 0; 2116, 2111; 1132, 1146; 0, 0];
% 
% % Calculated inputs
% calib(calibNum).corrections.load = [(1:length(manual_applied_loads))', mean(manual_applied_loads,2)];
