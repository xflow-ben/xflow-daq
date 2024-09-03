clear all
close all
clc

%% Initialize
single_count = 0;

%% Constants
consts.lbf_to_N = 4.44822;
consts.inch_to_m = 0.0254;
data_dir = 'E:\loads_data\load_calibrations\upper_arm';
makePlots = 1;
savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName = 'upper_arm_cal_struct';

%% Upper Arm Root
% % Upper arm root, Mx only 
% [calib,crosstalk] = calibration_matrix_inputs__up_arm_root_Mx(consts);
% temp = build_crosstalk_matrix(crosstalk,calib,data_dir,makePlots,savePath);

% % Upper arm root, My only 
% [calib,crosstalk] = calibration_matrix_inputs__up_arm_root_My(consts);
% temp = build_crosstalk_matrix(crosstalk,calib,data_dir,makePlots,savePath);

% % Upper arm root, Mz only 
% [calib,crosstalk] = calibration_matrix_inputs__up_arm_root_Mz(consts);
% temp = build_crosstalk_matrix(crosstalk,calib,data_dir,makePlots,savePath);

% Upper arm root all
[calib,crosstalk] = calibration_matrix_inputs__up_arm_root(consts);
temp = build_crosstalk_matrix(crosstalk,calib,data_dir,makePlots,savePath);
disp('Upper Arm Root Crosstalk Matrix = ')
fprintf('%.2f   \t%.2f   \t%.2f\n',k)
fprintf('Diagonals, computed individualy =\n')
fprintf('%.2f   \t%.2f   \t%.2f\n',[k_Mx,0,0;0,k_My,0;0,0,k_Mz])
fprintf('\n\n')

% 
% %% Upper Yoke
% [calib,crosstalk] = calibration_matrix_inputs__up_yoke_Fx(consts);
% [k_Fx,~,~] = build_crosstalk_matrix(crosstalk,calib,parent_dir,1);
% 
% [calib,crosstalk] = calibration_matrix_inputs__up_yoke_Fz(consts);
% [k_Fz,~,~] = build_crosstalk_matrix(crosstalk,calib,parent_dir,1);
% 
% [calib,crosstalk] = calibration_matrix_inputs__up_yoke_My(consts);
% [k_My,~,~] = build_crosstalk_matrix(crosstalk,calib,parent_dir,1);
% 
% [calib,crosstalk] = calibration_matrix_inputs__up_yoke(consts);
% [k,L,R] = build_crosstalk_matrix(crosstalk,calib,parent_dir,1);
% 
% disp('Upper Yoke Crosstalk Matrix = ')
% fprintf('%.2f   \t%.2f   \t%.2f\n',k)
% fprintf('Diagonals, computed individualy =\n')
% fprintf('%.2f   \t%.2f   \t%.2f\n',[k_Fx,0,0;0,k_Fz,0;0,0,k_My])
% fprintf('\n\n')