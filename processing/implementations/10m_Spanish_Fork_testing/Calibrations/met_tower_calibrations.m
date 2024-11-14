clear all
close all
clc

%% Constants
savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName = 'met_tower_cal_struct';


%% Get cal data
cal = calibration_matrix_inputs__met_tower();


%% Save
save(fullfile(savePath,saveName),'cal')
