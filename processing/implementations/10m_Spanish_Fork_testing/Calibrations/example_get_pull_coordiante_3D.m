clear all
close all

%% Define constants
E = [10, -1];  % Coordinates of east guy wire foundation point [m]
W = [-10, -1];  % Coordinates of west guy wire foundation point [m]
S = [0, -10];  % Coordinates of south guy wire foundation point [m]
tol = 2; % Tolerance for comparison of pairs of solutions[m]

%% Pull specific information
% Define the distances to the unknown point P
dE = 10;     % Distance from P to E [m]
dW = 10;     % Distance from P to W [m]
dS = 10;  % Distance from P to S [m]
fixed_coordinate = [-1,-1,10]; % Coordiante of location where the pull occured [m]
horizontial_angle = 5; % Angle of the pull from the horizontial plane [deg]

%% Get the coordiante
coordinate = get_pull_coordiante_3D(E,W,S,dE,dW,dS,tol,fixed_coordinate,horizontial_angle)


