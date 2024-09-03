clear all
close all
clc

%% Initialize
count_single = 0;
count_multi = 0;

%% Constants
consts.lbf_to_N = 4.44822;
consts.inch_to_m = 0.0254;
data_path = 'C:\Users\Ben Strom\Documents\Loads_Data\load_calibrations';%E:\loads_data\load_calibrations\';
data_folder = 'upper_arm';
makePlots = 1;
savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName_single = 'upper_arm_cal_single_axis_struct';
saveName_multi = 'upper_arm_cal_multi_axis_struct';

%% Upper Arm Root
% Upper arm root, Mx only 
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_arm_root_Mx(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,makePlots,savePath);

% Upper arm root, My only 
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_arm_root_My(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,makePlots,savePath);

% Upper arm root, Mz only 
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_arm_root_Mz(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,makePlots,savePath);

% Upper arm root all
count_multi = count_multi + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_arm_root(consts);
cal_multi(count_multi) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,makePlots,savePath);
disp('Upper Arm Root Crosstalk Matrix = ')
fprintf('%.2f   \t%.2f   \t%.2f\n',cal_multi(count_multi).data.k)
fprintf('Diagonals, computed individualy =\n')
fprintf('%.2f   \t%.2f   \t%.2f\n',[cal_single(count_single-2).data.k,0,0;...
    0,cal_single(count_single-1).data.k,0;...
    0,0,cal_single(count_single).data.k])
fprintf('\n\n')


%% Upper Yoke
% Upper yoke, Fx only
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_yoke_Fx(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,makePlots,savePath);

% Upper yoke, Fz only
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_yoke_Fz(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,makePlots,savePath);

% Upper yoke, My only
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_yoke_My(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,makePlots,savePath);

% Upper yoke all
count_multi = count_multi + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_yoke(consts);
cal_multi(count_multi) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,makePlots,savePath);

disp('Upper Arm Root Crosstalk Matrix = ')
fprintf('%.2f   \t%.2f   \t%.2f\n',cal_multi(count_multi).data.k)
fprintf('Diagonals, computed individualy =\n')
fprintf('%.2f   \t%.2f   \t%.2f\n',[cal_single(count_single-2).data.k,0,0;...
    0,cal_single(count_single-1).data.k,0;...
    0,0,cal_single(count_single).data.k])
fprintf('\n\n')

%% Save
save(fullfile(savePath,saveName_single),'cal_single')
save(fullfile(savePath,saveName_multi),'cal_multi')

