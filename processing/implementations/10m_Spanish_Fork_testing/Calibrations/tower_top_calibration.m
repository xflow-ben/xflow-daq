clear all
close all
clc

%% Initialize
consts = XFlow_Spanish_Fork_testing_constants();

%% Constants
data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\';
data_folder = 'tower';
makePlots = 1;
savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName = 'tower_top_cal_struct';
tdmsPrefix.data_files = {'data_gw_strain','data_nacelle_strain'};
tdmsPrefix.applied_load = 'data_rotor_strain';
%% Tower top
[calib,crosstalk] = calibration_matrix_inputs__tower_top_pulls(consts);
cal = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

%% Save
save(fullfile(savePath,saveName),'cal')