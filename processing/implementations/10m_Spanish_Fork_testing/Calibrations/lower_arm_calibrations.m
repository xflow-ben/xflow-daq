clear all
close all
clc

%% Initialize
count_single = 0;
count_multi = 0;
consts = XFlow_Spanish_Fork_testing_constants();

%% Constants
data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\';
data_folder = 'lower_arm';
makePlots = 1;
savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName_single = 'lower_arm_cal_single_axis_struct';
saveName_multi = 'lower_arm_cal_multi_axis_struct';
tdmsPrefix = 'lower_arm_cal_rotorStrain';

%% Lower Arm Root
% Lower arm root, Mx only 
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__low_arm_root_Mx(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Lower arm root, My only 
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__low_arm_root_My(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Lower arm root, Mz only 
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__low_arm_root_Mz(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Lower arm root all
count_multi = count_multi + 1;
[calib,crosstalk] = calibration_matrix_inputs__low_arm_root(consts);
cal_multi(count_multi) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);
disp('Lower Arm Root Crosstalk Matrix = ')
fprintf('%.2f   \t%.2f   \t%.2f\n',cal_multi(count_multi).data.k)
fprintf('Diagonals, computed individualy =\n')
fprintf('%.2f   \t%.2f   \t%.2f\n',[cal_single(count_single-2).data.k,0,0;...
    0,cal_single(count_single-1).data.k,0;...
    0,0,cal_single(count_single).data.k])
fprintf('\n\n')


%% Lower Yoke
% Lower yoke, Fx only
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__low_yoke_Fx(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Lower yoke, Fz only
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__low_yoke_Fz(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Lower yoke, My only
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__low_yoke_My(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Lower yoke all
count_multi = count_multi + 1;
[calib,crosstalk] = calibration_matrix_inputs__low_yoke(consts);
cal_multi(count_multi) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

disp('Lower Arm Root Crosstalk Matrix = ')
fprintf('%.2f   \t%.2f   \t%.2f\n',cal_multi(count_multi).data.k)
fprintf('Diagonals, computed individualy =\n')
fprintf('%.2f   \t%.2f   \t%.2f\n',[cal_single(count_single-2).data.k,0,0;...
    0,cal_single(count_single-1).data.k,0;...
    0,0,cal_single(count_single).data.k])
fprintf('\n\n')

%% Save
% save(fullfile(savePath,saveName_single),'cal_single')
% save(fullfile(savePath,saveName_multi),'cal_multi')

