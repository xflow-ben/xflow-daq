clear all
close all
clc

%% Initialize
count_single = 0;
count_multi = 0;
count_split = 0;
consts = XFlow_Spanish_Fork_testing_constants();

%% Constants

data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations';
data_folder = 'upper_arm';
makePlots = 1;
savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName_single = 'upper_arm_cal_single_axis_struct';
saveName_multi = 'upper_arm_cal_multi_axis_struct';
saveName_split = 'upper_arm_cal_split_multi_axis_struct';
tdmsPrefix = 'upper_arm_cal_rotorStrain';

%% Upper Arm Root
% Upper arm root, Mx only 
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_arm_root_Mx(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Upper arm root, My only 
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_arm_root_My(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Upper arm root, Mz only 
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_arm_root_Mz(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Upper arm root all
count_multi = count_multi + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_arm_root(consts);
cal_multi(count_multi) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);
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
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Upper yoke, Fz only
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_yoke_Fz(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Upper yoke, My only
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__up_yoke_My(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);


%%% NOTE: There is a strange behaviour in upper yoke, My data where the
%%% slope is not the same for positive and negative pulls. To account for
%%% this, we use two crosstalk matrices, one for positive and one for
%%% negative upper yoke My data

% % % % % % % % % Upper yoke all %%%% NO LONGER USED
% % % % % % % % count_multi = count_multi + 1;
% % % % % % % % [calib,crosstalk] = calibration_matrix_inputs__up_yoke(consts);
% % % % % % % % cal_multi(count_multi) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath)

% Upper yoke, -My
count_split = count_split + 1;
part = 1;
[calib,crosstalk] = calibration_matrix_inputs__up_yoke_My_neg(consts);
temp{part} = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Upper yoke, +My
part = 2;
[calib,crosstalk] = calibration_matrix_inputs__up_yoke_My_pos(consts);
temp{part} = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

cal_split(count_split) = temp{1};
cal_split(count_split).type = 'multi_part_linear_k';
cal_split(count_split).data.split.input_channel = 3;
cal_split(count_split).data.split.value = 0;

cal_split(count_split).data.k = [];
cal_split(count_split).data.k1 = temp{1}.data.k;
cal_split(count_split).data.k2 = temp{2}.data.k;

cal_split(count_split).data.load_mat = [];
cal_split(count_split).data.response_mat = [];
cal_split(count_split).data.load_mat1 = temp{1}.data.load_mat;
cal_split(count_split).data.load_mat2 = temp{2}.data.load_mat;
cal_split(count_split).data.response_mat1 = temp{1}.data.response_mat;
cal_split(count_split).data.response_mat2 = temp{2}.data.response_mat;

% Enforce that the diagnals are the same for the non-My loads
k11 = mean([temp{1}.data.k(1,1),temp{2}.data.k(1,1)]);
k22 = mean([temp{1}.data.k(2,2),temp{2}.data.k(2,2)]);
cal_split(count_split).data.k1(1,1) = k11;
cal_split(count_split).data.k2(1,1) = k11;
cal_split(count_split).data.k1(2,2) = k22;
cal_split(count_split).data.k2(2,2) = k22;

% disp('Upper Arm Root Crosstalk Matrix = ')
% fprintf('%.2f   \t%.2f   \t%.2f\n',cal_multi(count_multi).data.k)
% fprintf('Diagonals, computed individualy =\n')
% fprintf('%.2f   \t%.2f   \t%.2f\n',[cal_single(count_single-2).data.k,0,0;...
%     0,cal_single(count_single-1).data.k,0;...
%     0,0,cal_single(count_single).data.k])
% fprintf('\n\n')

%% Save
save(fullfile(savePath,saveName_single),'cal_single')
save(fullfile(savePath,saveName_multi),'cal_multi')
save(fullfile(savePath,saveName_split),'cal_split')


