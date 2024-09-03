clear all
close all
clc

%% Initialize
count = 0;

%% Constants
consts.lbf_to_N = 4.44822;
consts.inch_to_m = 0.0254;
parent_dir = 'E:\loads_data\load_calibrations\guy_wire_tension';
makePlots = 1;
savePath = 'C:\Users\XFlow Energy\Documents\GitHub\10m_loads_processing\Calibrations\Results\';
saveName = 'guy_wire_cal_struct';

%% Upper GWs
% Upper_GW_N
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Upper_GW_N(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,parent_dir,makePlots,savePath);

% Upper_GW_S
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Upper_GW_S(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,parent_dir,makePlots,savePath);

% Upper_GW_E
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Upper_GW_E(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,parent_dir,makePlots,savePath);

% Upper_GW_W
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Upper_GW_W(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,parent_dir,makePlots,savePath);

%% Lower GWs
% Lower_GW_N
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Lower_GW_N(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,parent_dir,makePlots,savePath);

% Lower_GW_S
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Lower_GW_S(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,parent_dir,makePlots,savePath);

% Lower_GW_E
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Lower_GW_E(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,parent_dir,makePlots,savePath);

% Lower_GW_W
count = count + 1;
[calib,crosstalk] = calibration_matrix_inputs__Lower_GW_W(consts);
cal(count) = build_crosstalk_matrix(crosstalk,calib,parent_dir,makePlots,savePath);

%% Save
save(fullfile(savePath,saveName),'cal')