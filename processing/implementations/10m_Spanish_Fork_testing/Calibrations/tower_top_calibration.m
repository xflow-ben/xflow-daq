clear all
close all
clc

%% Initialize
consts = XFlow_Spanish_Fork_testing_constants();
count = 0;

%% Constants
data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\';
data_folder = '';
makePlots = 1;
savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName = 'tower_top_cal_struct';
tdmsPrefix.data_files = {'data_gw_strain','data_nacelle_strain'};
tdmsPrefix.applied_load = 'data_rotor_strain';

%% Tower top moments
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__tower_top_moments(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,fullfile(savePath,'tower'));

%% Tower top forces
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__tower_top_forces(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,fullfile(savePath,'tower'));

%% Rotor Torque
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__rotor_torque(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,fullfile(savePath,'installed_rotor'));

%% Save
for i = 1:length(cal)
    cal(i).stage = 'afterResample';
end
save(fullfile(savePath,saveName),'cal')