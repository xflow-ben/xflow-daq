clear all
close all
clc

%% Initialize
count = 0;
consts = XFlow_Spanish_Fork_testing_constants();

%% Constants
data_path =  'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\';
data_folder = 'guy_wire_tension';
makePlots = 1;
savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName = 'guy_wire_cal_struct';
tdmsPrefix = 'guy_wire_cal_towerBaseStrain';

%% Upper GWs
% Upper_GW_N
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Upper_GW_N(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Upper_GW_S
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Upper_GW_S(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Upper_GW_E
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Upper_GW_E(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Upper_GW_W
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Upper_GW_W(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

%% Lower GWs
% Lower_GW_N
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Lower_GW_N(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Lower_GW_S
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Lower_GW_S(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Lower_GW_E
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Lower_GW_E(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Lower_GW_W
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Lower_GW_W(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

%% Save

for i = 1:length(cal)
    cal(i).stage = 'afterResample';
end
save(fullfile(savePath,saveName),'cal')